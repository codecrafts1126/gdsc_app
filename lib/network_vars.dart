String serverAddress = 'https://gdsc-server.onrender.com';
String eventsReadPath = '$serverAddress/read/events';
String eventsRegisterPath = '$serverAddress/create/event';
String eventsEditPath = '$serverAddress/update/event';
String registerUserPath = '$serverAddress/create/user';
String getUserInfoPath = '$serverAddress/read/userInfo';
String deleteEventpath = '$serverAddress/delete/event';

var events = {};
var sortedEvents = {};
var roles = [];
