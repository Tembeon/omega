import 'package:intl/intl.dart';

class TimeConverters {
  static int userInputToUnix({
    required final String timeInput,
    required final String dateInput,
    required final int timezoneInput,
  }) {
    // Convert input strings to lowercase
    final lowerTimeInput = timeInput.toLowerCase();
    final lowerDateInput = dateInput.toLowerCase();

    // Trim input strings
    final trimmedDateInput = lowerDateInput.trim();
    var trimmedTimeInput = lowerTimeInput.trim().replaceAll(':', ' ');

    // Add minutes if only hours are provided
    if (RegExp(r'^\d{1,2}$').hasMatch(trimmedTimeInput)) {
      trimmedTimeInput = '$trimmedTimeInput 00';
    }

    // Get the current date and time
    final now = DateTime.now();
    final String currentYear = now.year.toString();
    final String currentMonth = now.month.toString().padLeft(2, '0');

    // Handle date input
    final dateTime = _parseDate(trimmedDateInput, currentMonth, currentYear);

    // Handle time input
    final finalDateTime = _combineDateAndTime(dateTime, trimmedTimeInput);

    // Calculate timezone difference
    final timeZoneDiff = DateTime.now().timeZoneOffset.inHours - timezoneInput;

    // Adjust for timezone and convert to Unix timestamp
    final adjustedDateTime = finalDateTime.add(Duration(hours: timeZoneDiff));

    // Ensure the Unix timestamp is correctly formatted for the database
    final unixTimestamp = adjustedDateTime.toUtc().millisecondsSinceEpoch;

    return unixTimestamp;
  }

  static DateTime _parseDate(String dateInput, String currentMonth, String currentYear) {
    // Create a list of possible date formats
    final dateFormats = [
      DateFormat('d MMMM yyyy', 'ru'),
      DateFormat('d M yyyy', 'ru'),
      DateFormat('d MMMM', 'ru'),
      DateFormat('d M', 'ru'),
      DateFormat('d', 'ru'),
    ];

    // Determine the correct date input
    List<String> dateParts = dateInput.split(' ');

    if (dateParts.length == 1) {
      // Only day provided
      dateParts = [dateParts[0], currentMonth, currentYear];
    } else if (dateParts.length == 2) {
      // Day and month provided
      dateParts.add(currentYear);
    } else if (dateParts.length != 3) {
      throw const FormatException('Invalid date input format');
    }

    final adjustedDateInput = dateParts.join(' ');

    // Attempt to parse the date input using the available formats
    for (final format in dateFormats) {
      try {
        final parsedDate = format.parse(adjustedDateInput);
        return parsedDate;
      } on Exception catch (_) {
        continue;
      }
    }

    // If parsing was unsuccessful, throw an exception
    throw const FormatException('Invalid date format');
  }

  static DateTime _combineDateAndTime(DateTime date, String timeInput) {
    // Create a list of possible datetime formats
    final dateTimeFormats = [
      DateFormat('d MMMM yyyy HH mm', 'ru'),
      DateFormat('d M yyyy HH mm', 'ru'),
      DateFormat('d MMMM yyyy H mm', 'ru'),
      DateFormat('d M yyyy H mm', 'ru'),
      DateFormat('d MMMM yyyy HHmm', 'ru'),
      DateFormat('d M yyyy HHmm', 'ru'),
      DateFormat('d MMMM yyyy Hm', 'ru'),
      DateFormat('d M yyyy Hm', 'ru'),
      DateFormat('d MMMM yyyy HH', 'ru'),
      DateFormat('d M yyyy HH', 'ru'),
      DateFormat('d MMMM yyyy H', 'ru'),
      DateFormat('d M yyyy H', 'ru'),
    ];

    // Combine parsed date with time input
    final dateString = DateFormat('d MMMM yyyy', 'ru').format(date);
    final combinedInput = '$dateString $timeInput';

    // Attempt to parse the combined input using the available formats
    for (final format in dateTimeFormats) {
      try {
        final parsedDateTime = format.parse(combinedInput);
        return parsedDateTime;
      } on Exception catch (_) {
        continue;
      }
    }

    // If parsing was unsuccessful, throw an exception
    throw const FormatException('Invalid time format');
  }
}
