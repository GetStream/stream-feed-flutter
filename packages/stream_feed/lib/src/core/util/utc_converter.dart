import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class DateTimeUTCConverter implements JsonConverter<DateTime, String> {
  const DateTimeUTCConverter();
  static final DateFormat FORMAT = DateFormat('yyyy-MM-ddTHH:mm:ssZ');

  @override
  DateTime fromJson(String json) => FORMAT.parse(json, true);

  @override
  String toJson(DateTime json) => formatDateWithOffset(json);
}

String formatDateWithOffset(DateTime date) {
  String twoDigits(int n) => n >= 10 ? '$n' : '0$n';

  final hours = twoDigits(date.timeZoneOffset.inHours.abs());
  final minutes = twoDigits(date.timeZoneOffset.inMinutes.remainder(60));
  final sign = date.timeZoneOffset.inHours > 0 ? '+' : '-';
  final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(date);

  return '$formattedDate$sign$hours:$minutes';
}
