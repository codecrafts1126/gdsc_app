import 'package:DSCSITP/utils/input_validator.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:DSCSITP/utils/network_vars.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const SignedOutState());
  bool _canTriggerAuthActions = true;

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      emit(const SignedOutState());
    } on Exception catch (e) {
      throwLoginException(e);
    }
  }

  Future<void> autoLoginStateCall() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(const ProcessingState());
        // check if user has filled details or not and redirect to home page or details page accordingly
        await getUserInfo();
        emit(const LoggedInState());
      } else {
        return;
      }
    } on Exception catch (e) {
      throwLoginException(e);
      await signOut();
      emit(const SignedOutState());
    }
  }

  Future<void> getUserInfo() async {
    try {
      var res = await Dio().post(
        getUserInfoPath,
        data: {
          "uid": FirebaseAuth.instance.currentUser?.uid,
        },
      );

      if (res.statusCode == 200) {
        var data = res.data;
        if (data['status'] == true) {
          userDetails = data['message'];
          if (data['message']['name'] == null) {}
        } else {
          await registerIfNewUser();
          throw DioError(
              error: data['message'].toString(),
              requestOptions: RequestOptions(path: getUserInfoPath));
        }
      } else {
        throw DioError(
            error: "${res.statusCode} ${res.statusMessage}",
            requestOptions: RequestOptions(path: getUserInfoPath));
      }
    } on DioError catch (e) {
      throw DioError(
          error: e.message.toString(),
          requestOptions: RequestOptions(path: getUserInfoPath));
    }
  }

  Future<void> registerIfNewUser() async {
    try {
      await Dio().post(
        registerUserPath,
        data: {
          "uid": FirebaseAuth.instance.currentUser?.uid,
          "name": FirebaseAuth.instance.currentUser?.displayName,
          'email': FirebaseAuth.instance.currentUser?.email
        },
      );
    } on DioError catch (e) {
      await signOut();
      throw DioError(
          error: e.message.toString(),
          requestOptions: RequestOptions(path: registerUserPath));
    }
  }

  Future<void> logInEmailPass(String email, String password) async {
    if (!_canTriggerAuthActions) return;
    _canTriggerAuthActions = false;
    emit(const ProcessingState());

    //auth code goes here
    try {
      // input validation
      dynamic x =
          getValidation([validateEmail(email), validatePassword(password)]);
      if (!x[0]) {
        emit(LogInErrorState(x[1].toString()));
        await signOut();
        _canTriggerAuthActions = true;
        return;
      }

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await registerIfNewUser();

      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        emit(const LogInErrorState(
            "please verify your account using the verification sent on your email c:"));
        await signOut();
        _canTriggerAuthActions = true;
        return;
      }
      await getUserInfo();
      emit(const LoggedInState());
    } on Exception catch (e) {
      throwLoginException(e);
      await signOut();
      emit(const SignedOutState());
    }

    _canTriggerAuthActions = true;
  }

  Future<void> loginGoogle() async {
    if (!_canTriggerAuthActions) return;
    _canTriggerAuthActions = false;
    emit(const ProcessingState());

    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        var authResult =
            await FirebaseAuth.instance.signInWithProvider(googleProvider);

// input validation
        dynamic x = getValidation(
            [validateEmail(authResult.additionalUserInfo?.profile?["email"])]);
        if (!x[0]) {
          emit(LogInErrorState(x[1].toString()));
          await signOut();
          _canTriggerAuthActions = true;
          return;
        }

        if (authResult.additionalUserInfo?.isNewUser == true) {
          await registerIfNewUser();
        }
      }
      await getUserInfo();
      emit(const LoggedInState());
    } on Exception catch (e) {
      throwLoginException(e);
      await signOut();
      emit(const SignedOutState());
    }

    _canTriggerAuthActions = true;
  }

  Future<void> sendResetPassword(String email) async {
    if (!_canTriggerAuthActions) return;
    _canTriggerAuthActions = false;

    emit(const ProcessingState());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(const SignedUpState("A recovery email has been sent c:"));
    } on FirebaseAuthException catch (e) {
      // emit(SignUpErrorState(e.message.toString()));
      emit(const SignUpErrorState(
          "an error occured while performing the action"));
    }
    emit(const SignedOutState());

    _canTriggerAuthActions = true;
  }

  Future<void> signUpEmailPass(String email, String password) async {
    if (!_canTriggerAuthActions) return;
    _canTriggerAuthActions = false;
    emit(const ProcessingState());
    try {
// input validation
      dynamic x =
          getValidation([validateEmail(email), validatePassword(password)]);
      if (!x[0]) {
        emit(LogInErrorState(x[1].toString()));
        await signOut();
        _canTriggerAuthActions = true;
        return;
      }

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(const SignedUpState(
          "Account created successfully. Please verify your email to proceed"));
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      // emit(SignUpErrorState(e.message.toString()));
      emit(const SignUpErrorState(
          "an error occured while performing the action"));
    }
    emit(const SignedOutState());
    _canTriggerAuthActions = true;
  }

  void throwLoginException(Exception e) async {
    switch (e.runtimeType) {
      case (FirebaseAuthException):
        {
          emit(
              LogInErrorState((e as FirebaseAuthException).message.toString()));
        }
        break;
      case (DioError):
        {
          if ((e as DioError).message.toString().contains("vercel")) {
            emit(const LogInErrorState(
                "Could not connect to service, please try again later"));
          } else {
            emit(LogInErrorState((e as DioError).message.toString()));
          }
        }
        break;

      default:
        {
          if ((e as DioError).message.toString().contains("http")) {
            emit(const LogInErrorState("Service error, try again later"));
          } else {
            emit(LogInErrorState(e.toString()));
          }
        }
    }
  }
}
