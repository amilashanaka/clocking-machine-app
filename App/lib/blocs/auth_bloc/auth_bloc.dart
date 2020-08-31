import 'dart:async';

import 'package:ClockIN/data/user/user.dart';
import 'package:ClockIN/data/user/user_dao.dart';
import 'package:ClockIN/graphql/g_actions.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(LoadingAuthState());

  User _user;
  UserDao _userDao = UserDao();
  GActions _actions = GActions();

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
        final _checkUser = await _actions.checkUser(user);

        if (_checkUser) {
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
      final _loginUser = await _actions.loginUser(
        username: event.username,
        password: event.password,
      );

      if (_loginUser != null) {
        _user = _loginUser;

        yield HomePageAuthState(_user);
        await _initUserData(_user);
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
