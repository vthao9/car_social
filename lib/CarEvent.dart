import 'package:car_social/Authen.dart';
import 'package:car_social/CarEventPost.dart';
import 'package:car_social/EventPosts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'HelpPage.dart';
import 'PostPage.dart';
import 'SalesPage.dart';
import 'upload.dart';
import 'package:car_social/Posts.dart';
import 'package:car_social/Comment.dart';

class EventPage extends StatefulWidget{
  EventPage({
    this.auth,
    this.ifLogout,
  });
  final Authentication auth;
  final VoidCallback ifLogout;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EventPageState();
  }
}

class _EventPageState extends State<EventPage>{
  List<EventPosts> posts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Event Posts");
    postsRef.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      posts.clear();
      for(var singleKey in KEYS){
        EventPosts post = new EventPosts(
          DATA[singleKey]['event_title'],
          DATA[singleKey]['event_description'],
          DATA[singleKey]['date'],
          DATA[singleKey]['time'],
        );
        posts.add(post);
      }
      setState(() {
        print("Length : $posts.length");
      });
    }
    );
  }

  void _logout()async{
    try{
      await widget.auth.SignOut();
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
        title: new Text('Event Forum'),
      ),
      drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('CarSocial Menu'),
              decoration: BoxDecoration(
                color: Colors.tealAccent,
              ),
            ),
            ListTile(
              title: Text('CarFlex Forum'),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                      return new PostPage();
                    })
                );
              },
            ),
            ListTile(
              title: Text('Event Forum'),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                      return new EventPage();
                    })
                );
              },
            ),
            ListTile(
              title: Text('Sales Forum'),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                      return new SalesPage();
                    })
                );
              },
            ),
            ListTile(
              title: Text('Help Forum'),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                      return new HelpPage();
                    })
                );
              },
            ),
          ],
        ),
      ),
      body: new Container(
        child: posts.length == 0 ? new Text("There are no post.") : new ListView.builder(
            itemCount: posts.length,
            itemBuilder: (_, index){
              return PostsUI(posts[index].event_title, posts[index].event_description, posts[index].time, posts[index].date);
            }
        ),
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
                  icon: new Icon(Icons.add),
                  iconSize: 50.0,
                  color: Colors.white,
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){
                          return new EventPostPage();
                        })
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget PostsUI(String event_title, String event_description, String date, String time){
    return new Card(
      elevation: 10,
      margin: EdgeInsets.all(15),
      child: new Container(
        padding: new EdgeInsets.all(13),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 15,),
            new Text(
              "Event Title: " + event_title,
              style: Theme.of(context).textTheme.headline,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15,),
            new Text(
              "Description: " + event_description,
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}