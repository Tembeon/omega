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