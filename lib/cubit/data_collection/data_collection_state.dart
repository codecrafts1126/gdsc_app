part of 'data_collection_cubit.dart';

@immutable
abstract class DataCollectionState {
  const DataCollectionState();
}

class DataCollectionInitialState extends DataCollectionState {
  const DataCollectionInitialState();
}

class DataCollectionProcessingState extends DataCollectionState {
  const DataCollectionProcessingState();
}

class DataCollectionErrorState extends DataCollectionState {
  final String message;
  const DataCollectionErrorState(this.message);
}

class DataCollectedState extends DataCollectionState {
  final String message;
  const DataCollectedState(this.message);
}
