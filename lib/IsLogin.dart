import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'PostPage.dart';
import 'Authen.dart';

class isLogin extends StatefulWidget{
  isLogin({
    this.auth
  });
  final Authentication auth;
  State<StatefulWidget> createState(){
    return _IsLoginState();
  }
}

enum LoginStatus{
  logout,
  login,
}

class _IsLoginState extends State<isLogin>{
  LoginStatus loginStatus = LoginStatus.logout;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.CurrentUser().then((firebaseUserId){
      setState(() {
        loginStatus = firebaseUserId == null ? LoginStatus.logout : LoginStatus.login;
      });
    });
  }

  void _login(){
    setState(() {
      loginStatus = LoginStatus.login;
    });
  }
  void _logout(){
    setState(() {
      loginStatus = LoginStatus.logout;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch(loginStatus){
      case LoginStatus.logout:
      return new LoginPage(
        auth: widget,
        ifLogin: _login,
      );
      case LoginStatus.login:
      return new PostPage(
        auth: widget,
        ifLogout: _logout,
      );
    }
    return null;
  }
}