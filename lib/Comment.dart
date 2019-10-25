import 'dart:io';
import 'package:car_social/PostPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class CommentPage extends StatefulWidget{
  State<StatefulWidget> createState(){
    return _CommentPageState();
  }
}

class _CommentPageState extends State<CommentPage>{
  final formKey = new GlobalKey<FormState>();
  String _myInput;

  bool Save(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

  void saveInDatabase(){
    var dbtimeOfUpload = new DateTime.now();
    var dbDate = new DateFormat('MMM d, yyyy');
    var dbTime = new DateFormat('EEEE, hh:mm aaa');
    String date = dbDate.format(dbtimeOfUpload);
    String time = dbTime.format(dbtimeOfUpload);
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    var data = {
      "comment": _myInput,
      "date": date,
      "time": time,
    };
    databaseReference.child("Posts").push().set(data);
    goPostPage();
  }



  void goPostPage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return new PostPage();
        }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Container(
    child: new Form(
    key: formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 30,),
          TextFormField(
            decoration: new InputDecoration(labelText: 'Comment'),
            validator: (value){
              return value.isEmpty ? "Comment is required" : null;
            },
            onSaved: (value){
              return _myInput = value;
            },
          ),
          SizedBox(height: 15,),
          RaisedButton(
            elevation: 10,
            child: Text("Add"),
            textColor: Colors.white,
            color: Colors.tealAccent,
            onPressed: saveInDatabase,
          )
        ],
      ),
    ),
    ),
    );
  }

}
