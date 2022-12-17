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
  return DateFormat("yyyy-MM-dd HH:mm:ss").format(date).toString().trim();
}

int hoursBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day, from.hour);
  to = DateTime(to.year, to.month, to.day, to.hour);
  return (to.difference(from).inHours);
}

String timeLeftForEvent(DateTime startDate, DateTime endDate) {
  int hours = hoursBetween(DateTime.now(), startDate);

  int currHour = DateTime.now().hour;
  int startHour = startDate.hour;
  int endHour = endDate.hour;

  // int startTimeHourDiff = startHour - currHour;
  // int endTimeHourDiff = -(endHour - currHour);
  int startTimeHourDiff = hoursBetween(DateTime.now(), startDate);
  int endTimeHourDiff = hoursBetween(DateTime.now(), endDate);

  // print(hours);
  if (DateTime.now().isAfter(endDate)) {
    // print(startDate);
    // print(endDate);
    // print(
    //     DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate));
    return "Event has ended";
  } else if (DateTime.now().isAfter(startDate) &&
      DateTime.now().isBefore(endDate)) {
    return "Event is ongoing";
  } else if (hours < 2) {
    return "Event starts soon";
  } else if (hours < 24) {
    return "Less than a day left";
  } else if ((hours > 24) && (hours < 48)) {
    return "1 day left";
  } else {
    return "${(hours / 24).round()} days left";
  }
}
