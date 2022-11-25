part of 'event_register_cubit.dart';

@immutable
abstract class EventRegisterState {
  const EventRegisterState();
}

class EventRegisterInitialState extends EventRegisterState {
  const EventRegisterInitialState();
}

class EventRegisterProcessingState extends EventRegisterState {
  const EventRegisterProcessingState();
}

class EventRegisterErrorState extends EventRegisterState {
  final String message;
  const EventRegisterErrorState(this.message);
}

class EventRegisteredState extends EventRegisterState {
  final String message;
  const EventRegisteredState(this.message);
}
