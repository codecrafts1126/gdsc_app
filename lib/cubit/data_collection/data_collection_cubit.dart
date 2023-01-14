import 'package:DSCSITP/Models/user_data_model.dart';
import 'package:DSCSITP/utils/network_vars.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Future<dynamic> addUserDetails() async {
  //   if (!_canTriggerAuthActions) return;
  //   _canTriggerAuthActions = false;
  //   bool updated = true;
  //   if (updated) {
  //     emit(const DataCollectedState("Your details have been saved"));
  //   } else {
  //     emit(const DataCollectionErrorState("Could not register your data"));
  //   }

  //   _canTriggerAuthActions = true;
  //   return updated;
  // }

  Future<dynamic> UpdateUserDetails(UserDataModel userData) async {
    if (!_canTriggerAuthActions) return;
    _canTriggerAuthActions = false;
    emit(const DataCollectionProcessingState());

    try {
      var res = await Dio().post(
        updateUserInfoPath,
        data: {
          "uid": FirebaseAuth.instance.currentUser?.uid,
          "name": userData.branch.toString(),
          "prn": userData.prn.toString(),
          "number": userData.phoneNumber.toString(),
          "branch": userData.branch.toString(),
        },
      );
      if (res.statusCode == 200) {
        var jsonRes = res.data;
        if (jsonRes["status"] == true) {
          emit(DataCollectedState(jsonRes["message"].toString()));
        } else {
          emit(DataCollectionErrorState(jsonRes["message"].toString()));
        }
      } else {
        emit(DataCollectionErrorState(
            "Server returned an error with status code ${res.statusCode}"));
      }

      // emit(const EventEditInitialState());
    } on DioError catch (e) {
      emit(DataCollectionErrorState(e.error.toString()));
      // emit(const EventEditInitialState());
    } on Exception catch (e) {
      emit(DataCollectionErrorState(e.toString()));
      // emit(const EventEditInitialState());
    }
    _canTriggerAuthActions = true;
  }
}
