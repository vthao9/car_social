import 'package:flutter/material.dart';
import 'PostPage.dart';
import 'Authen.dart';
import 'package:car_social/IsLogin.dart';
import 'LoginPage.dart';

void main () {

  runApp(new CarApp());
}

class CarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "Car App",
      theme: new ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: isLogin(auth: Authen(),),
    );
  }
}