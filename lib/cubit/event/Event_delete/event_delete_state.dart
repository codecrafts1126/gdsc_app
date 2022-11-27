part of 'event_delete_cubit.dart';

@immutable
abstract class EventDeleteState {
  const EventDeleteState();
}

class EventDeleteInitialState extends EventDeleteState {
  const EventDeleteInitialState();
}

class EventDeleteProcessingState extends EventDeleteState {
  const EventDeleteProcessingState();
}

class EventDeletedState extends EventDeleteState {
  final String message;
  const EventDeletedState(this.message);
}

class EventDeleteErrorState extends EventDeleteState {
  final String message;
  const EventDeleteErrorState(this.message);
}
