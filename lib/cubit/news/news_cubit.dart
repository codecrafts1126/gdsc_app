import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:DSCSITP/utils/network_vars.dart';
import 'package:meta/meta.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(const NewsInitialState());
  bool _canTriggerActions = true;

  Future<void> refreshNewsData() async {
    if (!_canTriggerActions) return;
    _canTriggerActions = false;
    emit(const NewsProcessingState());

    try {
      var res = await Dio().post(
        newsReadPath,
        data: {"uid": FirebaseAuth.instance.currentUser?.uid},
      );
      if (res.statusCode == 200) {
        var jsonRes = res.data;
        if (jsonRes["status"] == true) {
          news = jsonRes["message"];
        } else {
          // emit(NewsErrorState(jsonRes["message"].toString()));
          emit(const NewsErrorState(
              "An internal error has occured, try again later"));
        }
      } else {
        emit(NewsErrorState(
            "Server returned an error with status code ${res.statusCode}"));
      }
      emit(const NewsInitialState());
    } on DioError catch (e) {
      emit(NewsErrorState(e.error.toString()));
      emit(const NewsInitialState());
    } on Exception catch (e) {
      emit(NewsErrorState(e.toString()));
      emit(const NewsInitialState());
    }
    _canTriggerActions = true;
  }
}
