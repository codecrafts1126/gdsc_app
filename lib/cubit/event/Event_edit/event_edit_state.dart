part of 'event_edit_cubit.dart';

@immutable
abstract class EventEditState {
  const EventEditState();
}

class EventEditInitialState extends EventEditState {
  const EventEditInitialState();
}

class EventEditProcessingState extends EventEditState {
  const EventEditProcessingState();
}

class EventEditErrorState extends EventEditState {
  final String message;
  const EventEditErrorState(this.message);
}

class EventEditedState extends EventEditState {
  final String message;
  const EventEditedState(this.message);
}
