part of 'event_register_cubit.dart';

@immutable
abstract class EventRegisterState {
  const EventRegisterState();
}

class EventRegisterInitial extends EventRegisterState {
  const EventRegisterInitial();
}

class EventRegisterProcessing extends EventRegisterState {
  const EventRegisterProcessing();
}

class EventRegisterError extends EventRegisterState {
  final String message;
  const EventRegisterError(this.message);
}

class EventRegistered extends EventRegisterState {
  final String message;
  const EventRegistered(this.message);
}
