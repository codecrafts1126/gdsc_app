import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:DSCSITP/utils/network_vars.dart';
import 'package:meta/meta.dart';

part 'event_delete_state.dart';

class EventDeleteCubit extends Cubit<EventDeleteState> {
  EventDeleteCubit() : super(const EventDeleteInitialState());
  bool _canTriggerActions = true;

  Future<void> deleteEvent(String eid) async {
    if (!_canTriggerActions) return;
    _canTriggerActions = false;
    emit(const EventDeleteProcessingState());

    try {
      var res = await Dio().delete(
        deleteEventpath,
        data: {
          "eid": eid,
          "uid": FirebaseAuth.instance.currentUser?.uid,
        },
      );
      if (res.statusCode == 200) {
        var jsonRes = res.data;
        if (jsonRes["status"] == true) {
          emit(EventDeletedState(jsonRes["message"].toString()));
        } else {
          emit(EventDeleteErrorState(jsonRes["message"].toString()));
        }
      } else {
        emit(EventDeleteErrorState(
            "Server returned an error with status code ${res.statusCode}"));
      }
      emit(const EventDeleteInitialState());
      _canTriggerActions = true;
    } on DioError catch (e) {
      emit(EventDeleteErrorState(e.error.toString()));
      emit(const EventDeleteInitialState());
    } on Exception catch (e) {
      emit(EventDeleteErrorState(e.toString()));
      emit(const EventDeleteInitialState());
    }
    _canTriggerActions = true;
  }
}
