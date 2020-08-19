import 'package:ClockIN/blocs/staff_auth_bloc/staff_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ClockIN/Animation/FadeAnimation.dart';
import 'package:ClockIN/data/staff.dart';

class StaffAuthPage extends StatelessWidget {
  final bool manual;

  const StaffAuthPage({this.manual = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StaffAuthBloc()..add(manual ? ManualAuthEvent() : ReadNfcEvent()),
      child: StaffAuthPageWidget(),
    );
  }
}

class StaffAuthPageWidget extends StatefulWidget {
  @override
  _StaffAuthPageWidgetState createState() => _StaffAuthPageWidgetState();
}

class _StaffAuthPageWidgetState extends State<StaffAuthPageWidget> {
  StaffAuthBloc _staffAuthBloc;

  TextEditingController _txtPinCode = TextEditingController();
  final _pincodeFromKey = GlobalKey<FormState>();

  @override
  void initState() {
    _staffAuthBloc = BlocProvider.of<StaffAuthBloc>(context);
    super.initState();
  }

  void _onPressedInAction() => _staffAuthBloc.add(InActionEvent());

  void _onPressedOutAction() => _staffAuthBloc.add(OutActionEvent());

  void _onPressedSendPinCode() {
    if (_pincodeFromKey.currentState.validate()) {
      _staffAuthBloc.add(SetManualAuthEvent(_txtPinCode.text));
    }
  }

  String _validatePinCode(String value) {
    if (value == null || value.trim() == "" || value.length != 4) {
      return "PIN CODE must be 4 digits";
    }

    return null;
  }

  Widget _customizedButton(String title, Function onPressed) {
    return SizedBox(
      height: 50,
      width: 300,
      child: RaisedButton(
        color: Colors.transparent,
        onPressed: onPressed,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(143, 163, 251, 1),
                Color.fromRGBO(143, 148, 251, .6),
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: 50.0,
              minWidth: 50,
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitPouringHourglass(
            color: Colors.black.withOpacity(0.5),
            size: 50.0,
          ),
          SizedBox(height: 20),
          Text(
            "Please wait",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _scanningNfcWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/scan_image.gif",
          height: 150,
        ),
        Text(
          "Scanning...",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.5)),
        ),
        SizedBox(height: 10),
        Text(
          "Make sure to keep the NFC tag\nnear the phone.",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 40),
            child: RaisedButton(
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: _onPressedCancel,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Colors.redAccent, width: 1.5),
              ),
              color: Colors.white,
              splashColor: Colors.redAccent,
            ),
          ),
        )
      ],
    );
  }

  Widget _showManualAuthWidget() {
    return Form(
      key: _pincodeFromKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter your",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "PIN CODE",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: TextFormField(
                controller: _txtPinCode,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.black, width: 4),
                  ),
                  counterText: "",
                  hintText: "PIN CODE HERE",
                  hintStyle: TextStyle(letterSpacing: 2),
                ),
                validator: _validatePinCode,
                keyboardType: TextInputType.number,
                style: TextStyle(letterSpacing: 40, fontSize: 20),
                textAlign: TextAlign.center,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLength: 4,
                maxLines: 1,
                maxLengthEnforced: true,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 85),
              child: _customizedButton("SEND", _onPressedSendPinCode),
            ),
            SizedBox(height: 40),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 25),
                child: RaisedButton(
                  child: Text(
                    "Go back",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  onPressed: _onPressedCancel,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                        color: Colors.black.withOpacity(0.6), width: 1.5),
                  ),
                  color: Colors.white,
                  splashColor: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showSelectActionWidget(Staff staff) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Your NFC detected!",
          style: TextStyle(
            fontSize: 20,
            // fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.5),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Text(
          "Name: ${staff.name}\nID: ${staff.rfid}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.5),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(right: 200),
            child: Text(
              "Select a Option:",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black.withOpacity(0.5),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        SizedBox(height: 10),
        _customizedButton("IN", _onPressedInAction),
        SizedBox(height: 10),
        _customizedButton("OUT", _onPressedOutAction),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: RaisedButton(
              child: Text(
                "Go back",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              onPressed: _onPressedCancel,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                    color: Colors.black.withOpacity(0.6), width: 1.5),
              ),
              color: Colors.white,
              splashColor: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _showMessageWidget(bool error, String message) {
    final icon = error ? Icons.error : Icons.check_circle;
    final color = error ? Colors.redAccent : Colors.greenAccent;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
          size: 50,
        ),
        SizedBox(height: 10),
        Text(
          message,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
        RaisedButton(
          child: Text(
            "Go back",
            style: TextStyle(fontSize: 16),
          ),
          onPressed: _onPressedCancel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: color, width: 1.5),
          ),
          color: Colors.white,
          splashColor: color,
        ),
      ],
    );
  }

  void _onPressedCancel() {
    Navigator.pop(context);
  }

  Future<bool> _willPopCallback() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Stack(
          children: [
            FadeAnimation(
              0.2,
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    height: 350,
                    width: double.infinity,
                    child: Center(
                      child: BlocBuilder<StaffAuthBloc, StaffAuthState>(
                        builder: (context, state) {
                          if (state is ScanningNfcState) {
                            return _scanningNfcWidget();
                          } else if (state is ShowManualAuthState) {
                            return _showManualAuthWidget();
                          } else if (state is SelectActionState) {
                            return _showSelectActionWidget(state.staff);
                          } else if (state is SuccessState) {
                            return _showMessageWidget(false, state.message);
                          } else if (state is ErrorState) {
                            return _showMessageWidget(true, state.message);
                          }

                          return _loadingWidget();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
