import 'package:flutter/material.dart';

class Rfid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scan'),
        ),
        body: BodyLayout(),
      ),
    );
  }
}

class BodyLayout extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    return  Image.asset(
      'assets/images/clock.png', width: 500.0, height: 500.0,
    );

  }
}
