import 'package:firebase_database/firebase_database.dart';

String serverAddress = 'https://gdsc-server.onrender.com';
String eventsPath = '${serverAddress}/read/events';
String registerUserPath = '${serverAddress}/create/user';

var events = {};
//  = {
//   "195d49a2d439df41c75c77d604b8f8fbbd16539a84396baa87959f1f5bb7eb3a1c": {
//     "date": "12th december 2022",
//     "description": "Crash course for flutter",
//     "endTime": "12 pm",
//     "name": "Flutter Crash Course",
//     "startTime": "12 am"
//   },
// };
