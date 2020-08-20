import 'dart:async';

import 'package:ClockIN/const.dart';
import 'package:ClockIN/data/user/user.dart';
import 'package:ClockIN/data/user/user_dao.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoadingAuthState());

  User _user;
  UserDao _userDao = UserDao();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is CheckAuthEvent) {
      yield* _mapCheckAuthEvent();
    } else if (event is LoginAuthEvent) {
      yield* _mapLoginAuthEvent(event);
    } else if (event is LogoutAuthEvent) {
      yield* _mapLogoutAuthEvent();
    }
  }

  Stream<AuthState> _mapCheckAuthEvent() async* {
    try {
      yield LoadingAuthState();

      User user = await _userDao.getUser();

      if (user != null && user.username != null || user.username != "") {
        final data = user.toMap();
        Response response = await Dio().post(Const.loginUserURL, data: data);

        if (response.data["success"]) {
          _user = user;
          yield HomePageAuthState(user);
        } else {
          yield LoginPageAuthState();
        }
      } else {
        yield LoginPageAuthState();
      }
    } catch (_) {
      yield (LoginPageAuthState());
    }
  }

  Stream<AuthState> _mapLoginAuthEvent(LoginAuthEvent event) async* {
    try {
      final data = event.user.toMap();
      Response response = await Dio().post(Const.loginUserURL, data: data);

      if (response.data["success"]) {
        yield HomePageAuthState(event.user);
        await _initUserData(event.user);
      } else {
        yield LoginPageAuthState(
          error: "Incorrect username or password!",
        );
      }
    } catch (_) {
      yield LoginPageAuthState(
        error: "Something went wrong!",
      );
    }
  }

  Stream<AuthState> _mapLogoutAuthEvent() async* {
    yield LoginPageAuthState();
  }

  Future<void> _initUserData(User user) async {
    _user = user;
    await _userDao.delete();
    await _userDao.insert(_user);
  }
}
