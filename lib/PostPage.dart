import 'package:flutter/material.dart';
import 'IsLogin.dart';

class PostPage extends StatefulWidget{
  PostPage({
    this.auth,
    this.ifLogout,
  });
  final isLogin auth;
  final VoidCallback ifLogout;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PostPageState();
  }
}

class _PostPageState extends State<PostPage>{
  void _logout()async{
    try{
      await widget.auth.auth.SignOut();
      widget.ifLogout();
    }
    catch(a){
      print("Error = " + a.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Post Here'),
      ),
      body: new Container(

      ),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.teal,
        child: new Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.add_a_photo),
                  iconSize: 50.0,
                  color: Colors.white,
                  onPressed: null
              ),
              new IconButton(
                  icon: new Icon(Icons.not_interested),
                  iconSize: 50.0,
                  color: Colors.white,
                  onPressed: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}