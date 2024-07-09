import 'package:intl/intl.dart';

class TimeConverters {
  static int userInputToUnix({
    required final String timeInput,
    required final String dateInput,
    required final int timezoneInput,
  }) {
    // Get the current year
    final now = DateTime.now();
    final String year = now.year.toString();

    // Append the current year if it's not provided
    final List<String> dateParts = dateInput.split(' ');
    if (dateParts.length == 2) {
      dateParts.add(year);
    } else if (dateParts.length != 3) {
      throw const FormatException('Invalid date input format');
    }

    // Combine date and time input
    final combinedInput = '${dateParts.join(' ')} $timeInput';

    // Determine the correct DateFormat based on the input
    final dateFormat = dateParts[1].contains(RegExp(r'^[0-9]{1,2}$'))
        ? DateFormat('d M yyyy HH mm', 'ru')
        : DateFormat('d MMMM yyyy HH mm', 'ru');

    // Calculate timezone difference
    final timeZoneDiff = DateTime.now().timeZoneOffset.inHours - timezoneInput;

    // Parse the combined input and convert to Unix timestamp
    DateTime dateTime;
    try {
      dateTime = dateFormat.parse(combinedInput).add(Duration(hours: timeZoneDiff));
    } on Exception catch (e) {
      throw FormatException('Invalid date or time format: $e');
    }

    return dateTime.toUtc().millisecondsSinceEpoch;
  }
}
