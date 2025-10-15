// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.
// @dart=2.12
// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'en';

  static m0(activityName) => "Activity \"${activityName}\" added";

  static m1(activityName) => "Activity \"${activityName}\" removed";

  static m2(userName, activityTitle) =>
      "LFG from user \"${userName}\" with activity \"${activityTitle}\" has been deleted.";

  static m3(error) => "Database unavailable: ${error}";

  static m4(milliseconds) => "Ping: ${milliseconds}ms";

  static m5(count) => "Scheduled: ${count}";

  static m6(error) => "Scheduler unavailable: ${error}";

  static m7(count) => "Total: ${count}";

  static m8(activity, freeSlots, role) => "Activity \"${activity}\" has ${freeSlots} free \"${role}\" roles";

  static m9(reason) =>
      "Cannot complete the command.\nReason: ${reason}\nTry again or contact the server administrators.";

  static m10(channelId) => "This command is only available in the LFG channel: <#${channelId}>";

  static m11(title) => "Your LFG \"${title}\" has been deleted.";

  static m12(metadata) => "Metadata: ${metadata}";

  static m13(stack) => "Stack trace: ${stack}";

  static m14(error) => "An error occurred while executing the command :(\n\n${error}";

  static m15(role) => "You chose role ${role}";

  static m16(channelId) => "LFG channel not found or misconfigured\nID: ${channelId}";

  static m17(current, max) => "Members (${current}/${max}):";

  static m18(id) => "LFG ${id} not found";

  static m19(channelId) => "Announcement channel is misconfigured.\nID: ${channelId}";

  static m20(roleName) => "Role \"${roleName}\" added to the database";

  static m21(roleName, activityName) => "Role \"${roleName}\" linked to activity \"${activityName}\"";

  static m22(roleName, activityName) => "Role \"${roleName}\" detached from activity \"${activityName}\"";

  static m23(roleName) => "Role \"${roleName}\" removed from the database";

  static m24(title, authorName) => "It\'s time for ${title} created by ${authorName}!";

  static m25(role) => "Role chosen: ${role}";

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
        'activityAddDescription': MessageLookupByLibrary.simpleMessage('Add an activity'),
        'activityAddedMessage': m0,
        'activityCommandDescription': MessageLookupByLibrary.simpleMessage('Activity settings'),
        'activityRemoveDescription': MessageLookupByLibrary.simpleMessage('Remove an activity'),
        'activityRemovedMessage': m1,
        'activityRolesAddDescription': MessageLookupByLibrary.simpleMessage('Add a role to the pool'),
        'activityRolesConnectDescription': MessageLookupByLibrary.simpleMessage('Assign a role to an activity'),
        'activityRolesDisconnectDescription': MessageLookupByLibrary.simpleMessage('Detach a role from an activity'),
        'activityRolesGroupDescription': MessageLookupByLibrary.simpleMessage('Manage activity roles'),
        'activityRolesRemoveDescription': MessageLookupByLibrary.simpleMessage('Remove a role from the pool'),
        'adminActivityOptionDescription': MessageLookupByLibrary.simpleMessage('Activity'),
        'adminBotChannelPrefix': MessageLookupByLibrary.simpleMessage('LFG channel: '),
        'adminBotChannelsDescription': MessageLookupByLibrary.simpleMessage('Channels where the bot works'),
        'adminBotGroupDescription': MessageLookupByLibrary.simpleMessage('View current bot configuration'),
        'adminBotPromoChannelPrefix': MessageLookupByLibrary.simpleMessage('Announcement channel: '),
        'adminBotRolesDescription': MessageLookupByLibrary.simpleMessage('Get the list of roles for an activity'),
        'adminChannelOptionDescription': MessageLookupByLibrary.simpleMessage('channel'),
        'adminCommandDescription': MessageLookupByLibrary.simpleMessage('Admin commands'),
        'adminDeleteMessageIdDescription': MessageLookupByLibrary.simpleMessage('Message ID to delete'),
        'adminDeleteSubcommandDescription': MessageLookupByLibrary.simpleMessage('Delete LFG'),
        'adminDeleteSuccess': m2,
        'adminHealthDatabaseUnavailable': m3,
        'adminHealthDescription': MessageLookupByLibrary.simpleMessage('Check bot status'),
        'adminHealthLfgHeader': MessageLookupByLibrary.simpleMessage('**LFGs:**'),
        'adminHealthPing': m4,
        'adminHealthScheduledCount': m5,
        'adminHealthSchedulerUnavailable': m6,
        'adminHealthStatsHeader': MessageLookupByLibrary.simpleMessage('**Stats:**'),
        'adminHealthTotalCount': m7,
        'adminPromoteAdded': MessageLookupByLibrary.simpleMessage('Message added'),
        'adminPromoteListHeader': MessageLookupByLibrary.simpleMessage('**Messages:**'),
        'adminPromoteRemoved': MessageLookupByLibrary.simpleMessage('Message removed'),
        'adminPromotesAddDescription': MessageLookupByLibrary.simpleMessage('Add a new message'),
        'adminPromotesGroupDescription': MessageLookupByLibrary.simpleMessage('Announcement settings'),
        'adminPromotesListDescription': MessageLookupByLibrary.simpleMessage('List all messages'),
        'adminPromotesMessageIdDescription': MessageLookupByLibrary.simpleMessage('Message ID'),
        'adminPromotesRemoveDescription': MessageLookupByLibrary.simpleMessage('Delete message by ID'),
        'adminPromotesTemplateHelp': MessageLookupByLibrary.simpleMessage(
            'Templates: ${AUTHOR}, ${DESCRIPTION}, ${DATE}, ${MAX_MEMBERS}, ${NAME}, ${MESSAGE_URL}'),
        'adminPromotesWeightDescription': MessageLookupByLibrary.simpleMessage('Message weight'),
        'adminRoleOptionDescription': MessageLookupByLibrary.simpleMessage('Role'),
        'adminRolesAvailability': m8,
        'adminSetGroupDescription': MessageLookupByLibrary.simpleMessage('Bot settings'),
        'adminSetLfgChannelCleared': MessageLookupByLibrary.simpleMessage('LFG channel cleared'),
        'adminSetLfgChannelDescription': MessageLookupByLibrary.simpleMessage('Set the LFG channel'),
        'adminSetLfgChannelSet': MessageLookupByLibrary.simpleMessage('LFG channel set'),
        'adminSetPromoChannelCleared': MessageLookupByLibrary.simpleMessage('Announcement channel cleared'),
        'adminSetPromoChannelDescription': MessageLookupByLibrary.simpleMessage('Set the announcement channel'),
        'adminSetPromoChannelSet': MessageLookupByLibrary.simpleMessage('Announcement channel set'),
        'alreadyJoinedMessage': MessageLookupByLibrary.simpleMessage('You already joined this group.'),
        'alwaysUserPermissionError':
            MessageLookupByLibrary.simpleMessage('You do not have permission to use this command'),
        'alwaysUserUnknownMember': MessageLookupByLibrary.simpleMessage('Could not identify the user'),
        'cantRespondError': m9,
        'commandOptionDateDescription':
            MessageLookupByLibrary.simpleMessage('Enter the activity start date [15 01 2023]'),
        'commandOptionDateKey': MessageLookupByLibrary.simpleMessage('date'),
        'commandOptionDescriptionDescription': MessageLookupByLibrary.simpleMessage('Enter the activity description'),
        'commandOptionDescriptionKey': MessageLookupByLibrary.simpleMessage('description'),
        'commandOptionNameDescription': MessageLookupByLibrary.simpleMessage('Enter the activity name'),
        'commandOptionNameKey': MessageLookupByLibrary.simpleMessage('name'),
        'commandOptionTimeDescription': MessageLookupByLibrary.simpleMessage('Enter the activity start time [15 01]'),
        'commandOptionTimeKey': MessageLookupByLibrary.simpleMessage('time'),
        'commandOptionTimezoneDescription': MessageLookupByLibrary.simpleMessage('Enter your current timezone offset'),
        'commandOptionTimezoneKey': MessageLookupByLibrary.simpleMessage('timezone'),
        'commonUnknownUser': MessageLookupByLibrary.simpleMessage('unknown'),
        'commonValueNotSet': MessageLookupByLibrary.simpleMessage('Not set'),
        'createCommandChannelRestriction': m10,
        'createCommandDefaultDescription': MessageLookupByLibrary.simpleMessage('Create a raid'),
        'createCommandDescription': MessageLookupByLibrary.simpleMessage('Create an activity'),
        'createCommandSubcommandDescription': MessageLookupByLibrary.simpleMessage('Create an LFG for an activity'),
        'creatorCannotLeaveMessage': MessageLookupByLibrary.simpleMessage(
            'You cannot leave because you created this group. Right-click the message, open \"Apps\", then pick \"Delete LFG\" if you want to remove it.'),
        'deleteCommandMessageNotFound': MessageLookupByLibrary.simpleMessage('Failed to delete the message [NotFound]'),
        'deleteCommandName': MessageLookupByLibrary.simpleMessage('Delete LFG'),
        'deleteCommandNotAuthor': MessageLookupByLibrary.simpleMessage(
            'You cannot delete this LFG because you are not its author [NotAuthor]'),
        'deleteCommandSuccess': m11,
        'editCommandCompleted': MessageLookupByLibrary.simpleMessage('Edit complete'),
        'editCommandDateLabel': MessageLookupByLibrary.simpleMessage('Start date'),
        'editCommandDescriptionLabel': MessageLookupByLibrary.simpleMessage('Description'),
        'editCommandDescriptionPlaceholder': MessageLookupByLibrary.simpleMessage('Enter a new description'),
        'editCommandMessageNotFound': MessageLookupByLibrary.simpleMessage('Failed to edit the message [NotFound]'),
        'editCommandModalMessageNotFound':
            MessageLookupByLibrary.simpleMessage('Failed to edit the message [NotFound]'),
        'editCommandModalTitle': MessageLookupByLibrary.simpleMessage('Edit LFG'),
        'editCommandName': MessageLookupByLibrary.simpleMessage('Edit LFG'),
        'editCommandNotAuthor':
            MessageLookupByLibrary.simpleMessage('You cannot edit this LFG because you are not its author [NotAuthor]'),
        'editCommandStartTimePlaceholder': MessageLookupByLibrary.simpleMessage('Enter a new start time'),
        'editCommandTimeLabel': MessageLookupByLibrary.simpleMessage('Start time'),
        'generalMetadata': m12,
        'generalStackTrace': m13,
        'interactorCommandError': m14,
        'interactorUnknownResponse': MessageLookupByLibrary.simpleMessage('I don\'t know how to respond to that :('),
        'joinComponentJoined': MessageLookupByLibrary.simpleMessage('You joined the LFG'),
        'joinComponentPrompt': MessageLookupByLibrary.simpleMessage('Pick a role to participate'),
        'joinComponentPromptWithColon': MessageLookupByLibrary.simpleMessage('Pick a role to participate:'),
        'joinComponentRoleExampleOne': MessageLookupByLibrary.simpleMessage('Role 1'),
        'joinComponentRoleExampleThree': MessageLookupByLibrary.simpleMessage('Role 3'),
        'joinComponentRoleExampleTwo': MessageLookupByLibrary.simpleMessage('Role 2'),
        'joinComponentRolePicked': m15,
        'leaveComponentLeft': MessageLookupByLibrary.simpleMessage('You left the LFG'),
        'leaveComponentUnknownErrorTitle':
            MessageLookupByLibrary.simpleMessage('An unexpected error occurred while removing you from the LFG'),
        'lfgChannelInvalid': m16,
        'lfgChannelNotConfigured': MessageLookupByLibrary.simpleMessage('LFG channel is not configured'),
        'lfgJoinButtonLabel': MessageLookupByLibrary.simpleMessage('➕  Join'),
        'lfgLeaveButtonLabel': MessageLookupByLibrary.simpleMessage('➖  Leave'),
        'lfgMembersLabel': m17,
        'lfgNotFoundMessage': m18,
        'lfgStartTimeLabel': MessageLookupByLibrary.simpleMessage('Start time:'),
        'notCreatorMessage': MessageLookupByLibrary.simpleMessage(
            'You cannot run this command because you are not the creator of the group.'),
        'notJoinedMessage': MessageLookupByLibrary.simpleMessage('You cannot leave a group you are not in.'),
        'promoterChannelInvalid': m19,
        'promoterDefaultTemplate': MessageLookupByLibrary.simpleMessage('${AUTHOR} is gathering people for ${NAME}'),
        'promoterNewGatheringTitle': MessageLookupByLibrary.simpleMessage('New gathering!'),
        'promptEnterBannerUrl': MessageLookupByLibrary.simpleMessage('Enter the banner URL'),
        'promptEnterMaxMembers': MessageLookupByLibrary.simpleMessage('Enter the maximum number of participants'),
        'promptEnterRoleName': MessageLookupByLibrary.simpleMessage('Enter the role name'),
        'promptEnterRoleNameWithEmoji': MessageLookupByLibrary.simpleMessage('Enter a role name (emoji allowed)'),
        'promptEnterRoleQuantity': MessageLookupByLibrary.simpleMessage('How many members are required for this role'),
        'promptUploadBanner': MessageLookupByLibrary.simpleMessage('Or upload a banner'),
        'roleAddedToDatabaseMessage': m20,
        'roleConnectedToActivityMessage': m21,
        'roleDisconnectedFromActivityMessage': m22,
        'roleNotPickedMessage': MessageLookupByLibrary.simpleMessage('No role was selected'),
        'rolePickerTimeoutMessage': MessageLookupByLibrary.simpleMessage('Role selection timed out'),
        'roleRemovedFromDatabaseMessage': m23,
        'schedulerPostStartNotification': m24,
        'selectedMessageIsNotLfg':
            MessageLookupByLibrary.simpleMessage('The selected message is not an LFG [LFGNotFound]'),
        'selectedRoleConfirmation': m25,
        'tooManyPlayersMessage':
            MessageLookupByLibrary.simpleMessage('You cannot join because the group is already full.')
      };
}
