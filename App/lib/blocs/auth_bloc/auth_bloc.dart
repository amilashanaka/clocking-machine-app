import 'dart:async';

import 'package:ClockIN/const.dart';
import 'package:ClockIN/data/user.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoginPageAuthState());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginAuthEvent) {
      yield* _mapLoginAuthEvent(event);
    } else if (event is LogoutAuthEvent) {
      yield* _mapLogoutAuthEvent();
    }
  }

  Stream<AuthState> _mapLoginAuthEvent(LoginAuthEvent event) async* {
    try {
      final data = event.user.toMap();
      Response response = await Dio().post(Const.loginUserURL, data: data);

      if (response.data["success"]) {
        yield HomePageAuthState(event.user);
      } else {
        yield LoginPageAuthState(
          error: "Incorrect username or password!",
        );
      }
    } catch (_) {}
  }

  Stream<AuthState> _mapLogoutAuthEvent() async* {
    yield LoginPageAuthState();
  }
}
