import 'dart:async';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc_app/networkVars.dart';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';

part 'event_refresh_state.dart';

final _database = FirebaseDatabase.instance.ref();
StreamSubscription<DatabaseEvent> _eventStream =
    _database.onValue.listen((event) {
  print("event ref changes");
});

class EventRefreshCubit extends Cubit<EventRefreshState> {
  EventRefreshCubit() : super(const EventRefreshInitialState());
  bool _canTriggerActions = true;

  Future<void> refreshEventData() async {
    if (!_canTriggerActions) return;
    _canTriggerActions = false;
    emit(const EventRefreshProcessingState());

    try {
      var res = await Dio().post(
        eventsPath,
        data: {"uid": FirebaseAuth.instance.currentUser?.uid},
      );
      if (res.statusCode == 200) {
        var jsonRes = res.data;
        if (jsonRes["status"] == true) {
          print(jsonRes);
          events = jsonRes["message"];
        } else {
          emit(EventRefreshErrorState(jsonRes["message"].toString()));
        }
      } else {
        emit(EventRefreshErrorState(
            "Server returned an error with status code ${res.statusCode}"));
      }
      emit(const EventRefreshInitialState());
    } on DioError catch (e) {
      print(e);
      emit(EventRefreshErrorState(e.error.toString()));
      emit(const EventRefreshInitialState());
    } on Exception catch (e) {
      print(e);
      emit(EventRefreshErrorState(e.toString()));
      emit(const EventRefreshInitialState());
    }
    _canTriggerActions = true;
  }
}
