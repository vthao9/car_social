import 'package:flutter/material.dart';
import 'Authen.dart';

class LoginPage extends StatefulWidget{
  LoginPage({
    this.auth,
    this.ifLogin,
  });
  final Authentication auth;
  final VoidCallback ifLogin;
  State<StatefulWidget> createState(){
    return LoginState();
  }
}

enum FormType{
  login,
  register,
}

class LoginState extends State<LoginPage>{
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  bool save(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }
  void submit()async{
    if(save()){
      try{
        if(_formType == FormType.login){
          String userId = await widget.auth.SignIn(_email, _password);
          print("login userID = " + userId);
        }
        else{
          String userId = await widget.auth.SignUp(_email, _password);
          print("register userID = " + userId);
        }
        widget.ifLogin();
      }
      catch(a){
        print('Error = ' + a.toString());
      }
    }
  }
  void goRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }
  void goLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Car Social"),
      ),
      body: new Container(
        margin: EdgeInsets.all(15.0),
        child: new Form(
          key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
        ),
      ),
    );
  }

  List<Widget> createInputs(){
    return[
      SizedBox(height: 10.0,),
      logo(),
      SizedBox(height: 20.0,),

      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value){
          return value.isEmpty ? 'Email is required' : null;
        },
        onSaved: (value){
          return _email = value;
        },
      ),
      SizedBox(height: 10.0,),

      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value){
          return value.isEmpty ? 'Password is required' : null;
        },
        onSaved: (value){
          return _password = value;
        },
      ),
      SizedBox(height: 20.0,),
    ];
  }

  Widget logo(){
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset('images/logo.png'),
      ),
    );
  }

  List<Widget> createButtons(){
    if(_formType == FormType.login){
      return[
        new RaisedButton(
          child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.white,
          color: Colors.tealAccent,
          onPressed: submit,
        ),

        new FlatButton(
          child: new Text("Create Account", style: new TextStyle(fontSize: 14.0)),
          textColor: Colors.black54,
          onPressed: goRegister,
        )
      ];
    }
    else{
      return[
        new RaisedButton(
          child: new Text("Register", style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.white,
          color: Colors.tealAccent,
          onPressed: submit,
        ),

        new FlatButton(
          child: new Text("Already signup? Login", style: new TextStyle(fontSize: 14.0)),
          textColor: Colors.black54,
          onPressed: goLogin,
        )
      ];
    }
  }
}
