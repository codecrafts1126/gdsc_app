import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:gdsc_app/Models/event_model.dart';

part 'event_register_state.dart';

class EventRegisterCubit extends Cubit<EventRegisterState> {
  EventRegisterCubit() : super(const EventRegisterInitialState());

  bool _canRegister = true;

  Future<void> registerEvent(EventModel eventData) async {
    if (!_canRegister) return;
    _canRegister = false;
    emit(const EventRegisterProcessingState());
    try {
      await Future.delayed(const Duration(seconds: 3), () {
        var x = Random();
        var y = x.nextInt(2);
        if (y.isOdd) throw Exception();
        emit(const EventRegisteredState("Event registered successfully c:"));
      });
    } catch (e) {
      emit(const EventRegisterErrorState("Could not register event :C"));
    }
    emit(const EventRegisterInitialState());
    _canRegister = true;
  }
}
