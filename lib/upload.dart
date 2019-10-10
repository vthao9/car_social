import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


class uploadPage extends StatefulWidget{
  State<StatefulWidget> createState(){
    return _uploadPageState();
  }
}

class _uploadPageState extends State<uploadPage>{
  File selectanimage;
  final formKey = new GlobalKey<FormState>();
  String _myInput;

  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectanimage = tempImage;
    });
  }

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
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Upload Image"),
      ),
      body: new Center(
        child: selectanimage == null? Text("Select an Image"): enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(onPressed: getImage, tooltip: "Add Image", child: new Icon(Icons.add_a_photo),),
    );
  }

  Widget enableUpload(){
    return Container(
      child: new Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(selectanimage, width: 400, height: 200,),
            SizedBox(height: 15,),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Description of Photo'),
              validator: (value){
                return value.isEmpty ? "Description is required" : null;
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
              onPressed: Save,
            )
          ],
        ),
      ),
    );
  }
}
