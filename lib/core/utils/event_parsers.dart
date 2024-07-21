import 'package:nyxx/nyxx.dart';

/// Finds the first option with the given name and returns it.
///
/// Since the [InteractionOption] is a recursive structure, we need to search for the option in the list of options.
T? findInOption<T>(String name, List<InteractionOption> option) {
  for (final opt in option) {
    if (opt.name == name) {
      return opt.value as T;
    }
    if (opt.options != null) {
      final result = findInOption<T>(name, opt.options!);
      if (result != null) {
        return result;
      }
    }
  }
  return null;
}

/// Removes from [input] all discord tags.
///
/// Removes all:
/// * emojis format `<:emoji_name:emoji_id>`
/// * users format `<@!user_id>` or `<@user_id>`
/// * channels format `<#channel_id>`
/// * roles format `<@&role_id>`
///
String sanitize(String input) {
  return input
      .replaceAll(RegExp(r'<a?:\w+:\d+>'), '')
      .replaceAll(RegExp(r'<@&?\d+>'), '')
      .replaceAll(RegExp(r'<#\d+>'), '');
}
