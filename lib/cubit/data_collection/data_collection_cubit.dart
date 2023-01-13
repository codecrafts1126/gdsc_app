import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'data_collection_state.dart';

class DataCollectionCubit extends Cubit<DataCollectionState> {
  DataCollectionCubit() : super(const DataCollectionInitialState());
  bool _canTriggerAuthActions = true;

  void showDataCollectionScreen() {
    if (!_canTriggerAuthActions) return;
    _canTriggerAuthActions = false;

    emit(const DataCollectionInitialState());

    _canTriggerAuthActions = true;
  }

  Future<dynamic> addUserDetails() async {
    if (!_canTriggerAuthActions) return;
    _canTriggerAuthActions = false;
    bool updated = true;
    if (updated) {
      emit(const DataCollectedState("Your details have been saved"));
    } else {
      emit(const DataCollectionErrorState("Could not register your data"));
    }

    _canTriggerAuthActions = true;
    return updated;
  }
}
