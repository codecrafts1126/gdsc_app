class EventModel {
  final String eventDomain;
  final String eventName;
  final String eventDescripion;
  final String eventVenue;
  final String eventStartDate;
  final String eventEndDate;
  final String eventStartTime;
  final String eventEndTime;

  EventModel({
    required this.eventDomain,
    required this.eventName,
    required this.eventDescripion,
    required this.eventVenue,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.eventStartTime,
    required this.eventEndTime,
  });
}
