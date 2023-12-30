import 'package:intl/intl.dart';

class TimeConverters {
  static int userInputToUnix({
    required final String timeInput,
    required final String dateInput,
    required final int timezoneInput,
  }) {
    final timeZoneDiff = DateTime.now().timeZoneOffset.inHours - timezoneInput;
    return DateFormat('dd MM yyyy HH mm')
        .parse('$dateInput $timeInput')
        .add(Duration(hours: timeZoneDiff))
        .toUtc()
        .millisecondsSinceEpoch;
  }
}
