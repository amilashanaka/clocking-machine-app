import 'package:ClockIN/blocs/staff_bloc/staff_bloc.dart';
import 'package:ClockIN/screens/HomePage.dart';
import 'package:ClockIN/blocs/auth_bloc/auth_bloc.dart';
import 'package:ClockIN/screens/NFCScanPage.dart';
import 'package:ClockIN/screens/StaffPage.dart';
import 'package:flutter/material.dart';
import 'package:ClockIN/screens/LoginPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MayApp(),
      ),
    ),
  );
}

class MayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is HomePageAuthState) {
          // return HomePage();
          // return BlocProvider(
          //   create: (context) => StaffBloc()..add(LoadStaffEvent()),
          //   child: StaffPage(),
          // );
          return NFCScanPage();
        } else if (state is LoginPageAuthState) {
          return LoginPage(errorText: state.error);
        }

        return LoginPage();
      },
    );
  }
}
