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
  from = DateTime(from.year, from.month, from.day, from.hour);
  to = DateTime(to.year, to.month, to.day, to.hour);
  return (to.difference(from).inHours).round();
}

String timeLeftForEvent(DateTime date, TimeOfDay startTime, TimeOfDay endtime) {
  int hours = daysBetween(DateTime.now(), date);
  // DateTime sampleDate = DateTime(2022, 12, 5, 22); //6 dec 11 am
  // int hours = daysBetween(sampleDate, date);

  int days = (hours / 24).round();
  // int days = (hours).round();
  //dont use date for hour calc, only use for date calc
  // int startHour = date.hour;
  int startHour = startTime.hour;
  int endHour = endtime.hour;
  // int currHour = sampleDate.hour;

  print(hours);
  return "$hours hours left";
  // if (hours > 1) {
  //   if (hours < 3) {
  //     return "$hours hours left";
  //   } else {
  //     return "hours left";
  //   }
  // } else {
  //   int startTimeHourDiff = startHour - currHour;
  //   int endTimeHourDiff = endHour - currHour;
  //   print([startTimeHourDiff, endTimeHourDiff].toString());
  //   if (startTimeHourDiff > 0) {
  //     return "event starts soon";
  //   } else if (startTimeHourDiff <= 0 && endTimeHourDiff > 0) {
  //     return "ongoing";
  //   } else {
  //     return "event has ended";
  //   }
  // }
  // if (hours < 0) {
  //   return "Event has ended";
  // } else if (hours < 24) {
  //   int startTimeHourDiff = startHour - currHour;
  //   int endTimeHourDiff = endHour - currHour;
  //   print([startTimeHourDiff, endTimeHourDiff].toString());
  //   //do hours stuff
  //   if (startTimeHourDiff > 0) {
  //     // print(startTimeHourDiff);
  //     if (startTimeHourDiff > 1) {
  //       return "$startTimeHourDiff hours left";
  //     } else {
  //       return "Event starts soon";
  //     }
  //   }
  // } else {
  //   //if (days > 0) {
  //   if (hours <= 48) {
  //     return "${days} day left";
  //   } else {
  //     return "${days} days left";
  //   }
  // }
}
