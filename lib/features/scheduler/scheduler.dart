import 'dart:async';

import 'package:nyxx/nyxx.dart';

import '../../core/bot/core.dart';
import '../../core/utils/database/tables/posts.dart';
import '../lfg_manager/lfg_manager.dart';

/// Scheduler for LFG posts.
/// It is used to schedule posts to be posted at specific time.
///
/// Methods:
/// - [schedulePost] - schedules post to be posted at [startTime].
/// - [cancelPost] - cancels post with [postID].
/// - [editTime] - edits time of post with [postID] to [newTime].
/// - [getScheduledPosts] - returns length of [_posts]
final class PostScheduler {
  /// Creates new post scheduler that will restore posts from [database] and use [core] to post them.
  PostScheduler({
    required final PostsDatabase database,
    required final LFGBotCore core,
    required final LFGManager lfgManager,
  })  : _database = database,
        _core = core,
        _lfgManager = lfgManager {
    _restorePosts();
    _startScheduler();
  }

  /// Database used for storing LFG posts and members.
  final PostsDatabase _database;

  /// Core of the bot.
  final LFGBotCore _core;

  /// LFG manager, used to manage LFG,
  final LFGManager _lfgManager;

  /// Map of all scheduled posts.
  ///
  /// Key is the date of the post. \
  /// Value is the ID of the post in database.
  final Map<DateTime, int> _posts = {};

  /// Timer used to check posts.
  Timer? _timer;

  /// Restores active posts from database to [_posts]. \
  /// If bot was restarted, it will restore all posts that were active before restart only
  /// if they are not older than 2 hours.
  ///
  /// Note: if members was notified about post before restarting, and discord post wasn't deleted,
  /// all members will be notified again and post will be scheduled to be deleted after 15 minutes regardless of time. \
  /// This is intended behavior.
  Future<void> _restorePosts() async {
    final now = DateTime.now();
    final posts = await _database.getAllPosts();
    for (final post in posts) {
      // skip post if difference between now and post time is more than 2 hours
      if (now.difference(post.date).inHours > 2) {
        print(
          '[Scheduler] Schedule post with id ${post.postMessageId} to be deleted because it is too old',
        );
        await _deleteLFGPostAfter(
          postID: post.postMessageId,
          duration: Duration.zero,
        );
      }

      _posts[post.date] = post.postMessageId;
    }
  }

  /// Starts checking posts every 30 seconds.
  void _startScheduler() {
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkPosts(),
    );
  }

  /// Checks if any post is ready to be posted.
  ///
  /// If post is ready, post members are notified and post is scheduled to be deleted. \
  /// Removes post from [_posts] if it is ready.
  void _checkPosts() {
    // skip if there are no posts
    if (_posts.isEmpty) {
      return;
    }

    final now = DateTime.now();
    print('[Scheduler] Checking posts...');

    final toDelete = <int>[];

    for (final post in _posts.entries) {
      if (post.key.isBefore(now)) {
        final postID = post.value;
        toDelete.add(postID);

        print('[Scheduler] Post with id $postID is ready to be posted');
        _notifyMembers(postID: postID);
      }
    }

    for (final postID in toDelete) {
      _posts.removeWhere((_, value) => value == postID);
    }

    print('[Scheduler] ${_posts.length} post(s) checked');
  }

  /// Notifies all members of post with [postID] that it is time to play.
  ///
  /// Schedules post to be deleted using [_deleteLFGPostAfter].
  Future<void> _notifyMembers({
    required final int postID,
  }) async {
    final post = await _database.findPost(postID);
    if (post == null) throw Exception('Cannot find post with id $postID');

    final members = await _database.getMembersForPost(postID);
    final author = await _core.bot.users.get(Snowflake(post.author));

    for (final member in members) {
      final dm = await _core.bot.users.createDm(Snowflake(member));
      print(
        '[Scheduler] Notifying ${dm.recipient.username} about ${post.title}',
      );

      await dm.sendMessage(
        MessageBuilder(
          content: 'Время сбора для ${post.title} от ${author.globalName ?? author.username} наступило!',
        ),
      );

      // wait 1 second to prevent rate limit
      await Future<void>.delayed(const Duration(seconds: 1));
    }

    print(
      '[Scheduler] All members notified, scheduling deleting post with id $postID',
    );
    await _deleteLFGPostAfter(postID: postID);
  }

  /// Deletes post after some [duration].
  ///
  /// It is used to prevent deleting post too early.
  Future<void> _deleteLFGPostAfter({
    final Duration duration = const Duration(minutes: 15),
    required final int postID,
  }) async =>
      Future<void>.delayed(duration, () => _lfgManager.delete(postID));

  /// Schedules post to be posted at [startTime].
  /// [postID] is ID of post in database.
  void schedulePost({
    required final DateTime startTime,
    required final int postID,
  }) {
    _posts[startTime] = postID;
    _checkPosts();
  }

  /// Cancels post with [postID].
  void cancelPost({
    required final int postID,
  }) {
    final post = _posts.entries.firstWhere((e) => e.value == postID);
    final value = _posts.remove(post.key);

    if (value != null) {
      print('[Scheduler] Post with id $postID was removed from scheduler');
    } else {
      print('[Scheduler] Post with id $postID was not found in scheduler');
    }
  }

  /// Edits time of post with [postID] to [newTime].
  void editTime({
    required final int postID,
    required final DateTime newTime,
  }) {
    final post = _posts.entries.firstWhere((e) => e.value == postID);
    _posts.remove(post.key);
    _posts[newTime] = postID;
    _checkPosts();
  }

  /// Return quantity of scheduled posts
  int getScheduledPostsCount() {
    return _posts.length;
  }

  /// Disposes post scheduler and cancels all scheduled posts.
  void dispose() {
    _posts.clear();
    _timer?.cancel();
  }
}
