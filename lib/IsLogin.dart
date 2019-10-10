import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'PostPage.dart';
import 'Authen.dart';

class isLogin extends StatefulWidget{
  isLogin({this.auth,});
  final Authentication auth;
  State<StatefulWidget> createState(){
    return _isLoginState();
  }
}

enum LoginStatus{
  logout,
  login,
}

class _isLoginState extends State<isLogin>{
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
        auth: widget.auth,
        ifLogin: _login,
      );
      case LoginStatus.login:
      return new PostPage(
        auth: widget.auth,
        ifLogout: _logout,
      );
    }
    return null;
  }
}