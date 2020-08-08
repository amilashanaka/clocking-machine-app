import 'package:ClockIN/Animation/FadeAnimation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
 

class Home extends StatelessWidget {


  @override

  
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,


        body: Container(

          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/home.jpg'),
                  fit: BoxFit.fill
              )
          ),

          child: Container(

            child: Column(
              children: <Widget>[
                Container(


                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(1, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-1.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.3, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-2.png')
                              )
                          ),
                        )),
                      ),

                      Positioned(
                        left: 170,
                        width: 80,
                        height: 400,
                        child: FadeAnimation(1.3, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.5, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        child: FadeAnimation(1.6, Container(
                          margin: EdgeInsets.only(top: 300),
                          child: Center(
                            child: Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                          ),
                        )),



                      ),

                      Positioned(
                        child: FadeAnimation(1.6, Container(
                          margin: EdgeInsets.only(top: 400),
                          child: Center(
                            child: Text("10:20 AM", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                          ),
                        )),

                      ),


                      SizedBox(height: 30,),
                      FadeAnimation(2, Container(

                        margin: EdgeInsets.only(top: 500,left: 50),
                        height: 50,

                        width: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ]
                            )
                        ),
                        child: Center(
                          child: FlatButton(
                            textColor: Colors.white,
                            color: Colors.transparent,

                            child: Text('With Card'),

                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            },

                          ),

                        ),

                      )),

                      SizedBox(height: 30,),
                      FadeAnimation(2, Container(

                        margin: EdgeInsets.only(top: 610,left: 50),
                        height: 50,

                        width: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ]
                            )
                        ),
                        child: Center(
                          child: FlatButton(
                            textColor: Colors.white,
                            color: Colors.transparent,

                            child: Text('With Out Card'),

                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            },

                          ),

                        ),

                      )),

                    ],
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}