import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  State<StatefulWidget> createState(){
    return LoginState();
  }
}

class LoginState extends State<LoginPage>{
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
      ),
      SizedBox(height: 10.0,),

      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
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
    return[
      new RaisedButton(
        child: new Text("Login", style: new TextStyle(fontSize: 20.0)),
        textColor: Colors.white,
        color: Colors.tealAccent,
        onPressed: () {},
      ),

      new FlatButton(
        child: new Text("Create Account", style: new TextStyle(fontSize: 14.0)),
        textColor: Colors.black54,
        onPressed: () {},
      )
    ];
  }
}
