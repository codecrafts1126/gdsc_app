import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String dateTimeToTimeString(TimeOfDay time) {
  return "${DateFormat("HH:mm").format(DateTime(2000, 1, 1, time.hourOfPeriod, time.minute))} ${time.period.name.toUpperCase()}"
      .trim();
}

TimeOfDay stringToTime(String time) {
  final format = DateFormat.jm();
  return TimeOfDay.fromDateTime(format.parse(time));
}

String dateToStringReadable(DateTime date) {
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return "${date.day} ${months[(date.month) - 1]} ${date.year}".trim();
}

DateTime stringToDatetime(String date) {
  return DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
}

String writableDateTimeToReadableDateTime(String date) {
  return dateToStringReadable(stringToDatetime(date));
}

String dateToStringWritable(DateTime date) {
  return DateFormat("yyyy-MM-dd hh:mm:ss").format(date).toString().trim();
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
