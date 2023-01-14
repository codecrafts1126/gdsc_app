String serverAddress = 'https://gdsc-server.onrender.com';

String newsReadPath = '$serverAddress/read/news';

String eventsReadPath = '$serverAddress/read/events';
String eventsRegisterPath = '$serverAddress/create/event';
String eventsEditPath = '$serverAddress/update/event';
String deleteEventpath = '$serverAddress/delete/event';
String addEventParticipantPath = '$serverAddress/create/event_participants';
String removeEventParticipantPath = '$serverAddress/delete/event_participants';

String registerUserPath = '$serverAddress/create/user';
String getUserInfoPath = '$serverAddress/read/userInfo';
String updateUserInfoPath = '$serverAddress/update/user';

var events = {};
var sortedEvents = {};
var news = {};
var userDetails = {};
