import 'package:intl/intl.dart';
import 'package:nyxx/nyxx.dart';

class TimeConverters {
  /// Returns DateTime according user input
  static DateTime getRawDateTime(
    final String time,
    final String date,
  ) {
    return DateFormat('HH mm dd MM yyyy').parse('$time $date');
  }

  /// Converts **raw** DateTime to UTC time.
  static DateTime convertToUTC({
    required final int userTimezoneOffset,
    required final DateTime rawDate,
  }) {
    int localTimezone = 3;
    int difference = localTimezone - userTimezoneOffset;

    return rawDate.add(Duration(hours: difference)).toUtc();
  }

  /// Converts DateTime to Discord timestamp. You must provide DateTime in UTC.
  static String convertToDiscordTime(final DateTime time) {
    return TimeStampStyle.longDateTime.format(time);
  }

  /// Converts user input date to Discord timestamp.
  static String convertRawDateToDiscordTime({
    required final String time,
    required final String date,
    required final int userTimezoneOffset,
  }) {
    final rawDate = getRawDateTime(time, date);
    final utcTime = convertToUTC(
      userTimezoneOffset: userTimezoneOffset,
      rawDate: rawDate,
    );

    return convertToDiscordTime(utcTime);
  }
}
