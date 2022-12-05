part of 'event_participant_cubit.dart';

@immutable
abstract class EventParticipantState {
  const EventParticipantState();
}

class EventParticipantInitialState extends EventParticipantState {
  const EventParticipantInitialState();
}

class EventParticipantProcessingState extends EventParticipantState {
  const EventParticipantProcessingState();
}

class EventParticipantAddedState extends EventParticipantState {
  final String message;
  const EventParticipantAddedState(this.message);
}

class EventParticipantRemovedState extends EventParticipantState {
  final String message;
  const EventParticipantRemovedState(this.message);
}

class EventParticipantErrorState extends EventParticipantState {
  final String message;
  const EventParticipantErrorState(this.message);
}
