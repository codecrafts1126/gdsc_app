String serverAddress = 'https://gdsc-server.onrender.com';
String eventsReadPath = '$serverAddress/read/events';
String eventsRegisterPath = '$serverAddress/create/event';
String eventsEditPath = '$serverAddress/update/event';
String registerUserPath = '$serverAddress/create/user';
String getUserInfoPath = '$serverAddress/read/userInfo';
String deleteEventpath = '$serverAddress/delete/event';
String addEventParticipantPath = '$serverAddress/create/event_participants';
String removeEventParticipantPath = '$serverAddress/delete/event_participants';

var events = {};
var sortedEvents = {};
var roles = [];
