part of 'event_refresh_cubit.dart';

@immutable
abstract class EventRefreshState {
  const EventRefreshState();
}

class EventRefreshInitialState extends EventRefreshState {
  const EventRefreshInitialState();
}

class EventRefreshProcessingState extends EventRefreshState {
  const EventRefreshProcessingState();
}

class EventRefreshErrorState extends EventRefreshState {
  final String message;
  const EventRefreshErrorState(this.message);
}
