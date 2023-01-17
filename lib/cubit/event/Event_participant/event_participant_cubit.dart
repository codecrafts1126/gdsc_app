import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:DSCSITP/utils/network_vars.dart';
import 'package:meta/meta.dart';

part 'event_participant_state.dart';

class EventParticipantCubit extends Cubit<EventParticipantState> {
  EventParticipantCubit() : super(EventParticipantInitialState());

  bool _canTriggerActions = true;

  Future<void> addParticipant(String eid) async {
    if (!_canTriggerActions) return;
    _canTriggerActions = false;
    emit(const EventParticipantProcessingState());

    try {
      var res = await Dio().post(
        addEventParticipantPath,
        data: {
          "uid": FirebaseAuth.instance.currentUser?.uid,
          "eid": eid,
        },
      );
      if (res.statusCode == 200) {
        var jsonRes = res.data;
        if (jsonRes["status"] == true) {
          emit(EventParticipantAddedState(jsonRes["message"].toString()));
        } else {
          emit(EventParticipantErrorState(jsonRes["message"].toString()));
        }
      } else {
        emit(EventParticipantErrorState(
            "Server returned an error with status code ${res.statusCode}"));
      }
      emit(const EventParticipantInitialState());
      _canTriggerActions = true;
    } on DioError catch (e) {
      emit(EventParticipantErrorState(e.error.toString()));
      emit(const EventParticipantInitialState());
    } on Exception catch (e) {
      emit(EventParticipantErrorState(e.toString()));
      emit(const EventParticipantInitialState());
    }
    _canTriggerActions = true;
  }

  Future<void> removeParticipant(String eid) async {
    if (!_canTriggerActions) return;
    _canTriggerActions = false;
    emit(const EventParticipantProcessingState());

    try {
      var res = await Dio().delete(
        removeEventParticipantPath,
        data: {
          "uid": FirebaseAuth.instance.currentUser?.uid,
          "eid": eid,
        },
      );
      if (res.statusCode == 200) {
        var jsonRes = res.data;
        if (jsonRes["status"] == true) {
          emit(EventParticipantRemovedState(jsonRes["message"].toString()));
        } else {
          emit(EventParticipantErrorState(jsonRes["message"].toString()));
        }
      } else {
        emit(EventParticipantErrorState(
            "Server returned an error with status code ${res.statusCode}"));
      }
      emit(const EventParticipantInitialState());
      _canTriggerActions = true;
    } on DioError catch (e) {
      emit(EventParticipantErrorState(e.error.toString()));
      emit(const EventParticipantInitialState());
    } on Exception catch (e) {
      emit(EventParticipantErrorState(e.toString()));
      emit(const EventParticipantInitialState());
    }
    _canTriggerActions = true;
  }

  Future<dynamic> getParticipants(String eid) async {
    if (!_canTriggerActions) return;
    _canTriggerActions = false;
    emit(const EventParticipantProcessingState());

    try {
      var res = await Dio().post(
        eventParticipantsReadPath,
        data: {
          "uid": FirebaseAuth.instance.currentUser?.uid,
          "eid": eid,
        },
      );
      if (res.statusCode == 200) {
        var jsonRes = res.data;
        if (jsonRes["status"] == true) {
          participantDetails = jsonRes['message'];
          sortedParticipantsDetails = Map.fromEntries(participantDetails.entries
              .toList()
            ..sort((e1, e2) => e1.value['name'].compareTo(e2.value['name'])));

          emit(const EventParticipantsLoadedState());
        } else {
          emit(EventParticipantErrorState(jsonRes["message"].toString()));
        }
      } else {
        emit(EventParticipantErrorState(
            "Server returned an error with status code ${res.statusCode}"));
      }
      emit(const EventParticipantInitialState());
      _canTriggerActions = true;
    } on DioError catch (e) {
      emit(EventParticipantErrorState(e.error.toString()));
      emit(const EventParticipantInitialState());
    } on Exception catch (e) {
      emit(EventParticipantErrorState(e.toString()));
      emit(const EventParticipantInitialState());
    }
    _canTriggerActions = true;
  }
}
