import 'dart:io';
import 'package:car_social/PostPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'SalesPage.dart';


class SalesUpload extends StatefulWidget{
  State<StatefulWidget> createState(){
    return _SalesUploadState();
  }
}

class _SalesUploadState extends State<SalesUpload>{
  File selectanimage;
  final formKey = new GlobalKey<FormState>();
  String _myInput;
  String price;
  String contact;
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
      "price": price,
      "contact": contact,
      "date": date,
      "time": time,
    };
    databaseReference.child("Sales").push().set(data);
  }

  void upload_to_firebase() async{
    if(Save()){
      final StorageReference storeImage = FirebaseStorage.instance.ref().child("Store Sales Images");
      var timeOfUpload = new DateTime.now();
      final StorageUploadTask uploadTask = storeImage.child(timeOfUpload.toString() + ".jpg").putFile(selectanimage);
      var getImage = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = getImage.toString();
      print("The image url = " + url);
      goSalesPage();
      saveInDatabase(url);
    }
  }

  void goSalesPage(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return new SalesPage();
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
            TextFormField(
              decoration: new InputDecoration(labelText: 'Price'),
              validator: (value1){
                return value1.isEmpty ? "Price is required" : null;
              },
              onSaved: (value1){
                return price = value1;
              },
            ),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Contact Info'),
              validator: (value1){
                return value1.isEmpty ? "Contact Info is required" : null;
              },
              onSaved: (value2){
                return contact = value2;
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