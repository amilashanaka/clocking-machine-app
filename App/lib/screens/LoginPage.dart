import 'package:ClockIN/Animation/FadeAnimation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import '../blocs/auth_bloc/auth_bloc.dart';
import '../data/user.dart';

class LoginPage extends StatelessWidget {
  final String errorText;
  LoginPage({this.errorText = ""});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  void _onPressedLogin(BuildContext context) {
    if (_loginFormKey.currentState.validate()) {
      final user = User(
        username: _usernameController.text,
        password: _passwordController.text,
      );
      BlocProvider.of<AuthBloc>(context).add(LoginAuthEvent(user));
    }
  }

  void _onPressedForgotPassword() {}

  String _validator(String value) {
    if (value == null || value == "") {
      return "Required field!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _loginFormKey,
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(
                          1,
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/light-1.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                          1.3,
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/light-2.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 170,
                        width: 80,
                        height: 400,
                        child: FadeAnimation(
                          1.3,
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/logo.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                          1.5,
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/clock.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: FadeAnimation(
                          1.6,
                          Container(
                            margin: EdgeInsets.only(top: 150),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                        1.8,
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10),
                                )
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                decoration: BoxDecoration(),
                                child: TextFormField(
                                  controller: _usernameController,
                                  validator: _validator,
                                  decoration: InputDecoration(
                                    icon: FaIcon(FontAwesomeIcons.user),
                                    labelText: 'User Name',
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                decoration: BoxDecoration(),
                                child: TextFormField(
                                  obscureText: true,
                                  controller: _passwordController,
                                  validator: _validator,
                                  decoration: InputDecoration(
                                    icon: FaIcon(FontAwesomeIcons.key),
                                    labelText: 'Password',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      (this.errorText != null && this.errorText != "")
                          ? FadeAnimation(
                              2,
                              Column(
                                children: [
                                  Text(
                                    "Incorrect username and password!",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      FadeAnimation(
                        2,
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ],
                            ),
                          ),
                          child: Center(
                            child: FlatButton(
                              textColor: Colors.white,
                              color: Colors.transparent,
                              child: Text('Login'),
                              onPressed: () => _onPressedLogin(context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      FadeAnimation(
                        1.5,
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
