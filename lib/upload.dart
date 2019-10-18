import 'dart:io';
import 'package:car_social/PostPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class uploadPage extends StatefulWidget{
  State<StatefulWidget> createState(){
    return _uploadPageState();
  }
}

class _uploadPageState extends State<uploadPage>{
  File selectanimage;
  final formKey = new GlobalKey<FormState>();
  String _myInput;
  String url;

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

  void saveInDatabase(url){
    var dbtimeOfUpload = new DateTime.now();
    var dbDate = new DateFormat('MMM d, yyyy');
    var dbTime = new DateFormat('EEEE, hh:mm aaa');
    String date = dbDate.format(dbtimeOfUpload);
    String time = dbTime.format(dbtimeOfUpload);
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    var data = {
      "image": url,
      "description": _myInput,
      "date": date,
      "time": time,
    };
    databaseReference.child("Posts").push().set(data);
  }

  void upload_to_firebase() async{
    if(Save()){
      final StorageReference storeImage = FirebaseStorage.instance.ref().child("Store Images");
      var timeOfUpload = new DateTime.now();
      final StorageUploadTask uploadTask = storeImage.child(timeOfUpload.toString() + ".jpg").putFile(selectanimage);
      var getImage = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = getImage.toString();
      print("The image url = " + url);
      goPostPage();
      saveInDatabase(url);
    }
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
            SizedBox(height: 10,),
            Image.file(selectanimage, width: 550, height: 250,),
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
              onPressed: upload_to_firebase,
            )
          ],
        ),
      ),
    );
  }
}
