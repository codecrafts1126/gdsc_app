import 'package:DSCSITP/Models/user_data_model.dart';
import 'package:DSCSITP/utils/input_validator.dart';
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

  Future<dynamic> updateUserDetails(UserDataModel userData) async {
    if (!_canTriggerAuthActions) return;
    _canTriggerAuthActions = false;
    emit(const DataCollectionProcessingState());

    try {
// input validation
      dynamic x = getValidation([
        validatePersonName(userData.name.toString().trim()),
        validatePRN(userData.prn.toString().trim()),
        validatePhoneNumber(userData.phoneNumber.toString().trim()),
        validateBranch(userData.branch.toString().trim())
      ]);
      if (!x[0]) {
        emit(DataCollectionErrorState(x[1].toString()));
        _canTriggerAuthActions = true;
        return;
      }

      var res = await Dio().post(
        updateUserInfoPath,
        data: {
          "uid": FirebaseAuth.instance.currentUser?.uid.toString(),
          "name": userData.name.toString().trim(),
          "prn": userData.prn.toString().trim(),
          "number": userData.phoneNumber.toString().trim(),
          "branch": userData.branch.toString().trim(),
          "pfp": FirebaseAuth.instance.currentUser?.photoURL.toString()
        },
      );
      if (res.statusCode == 200) {
        var jsonRes = res.data;
        if (jsonRes["status"] == true) {
          // emit(DataCollectedState(jsonRes["message"].toString()));
          emit(const DataCollectedState("Your details have been saved"));
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
