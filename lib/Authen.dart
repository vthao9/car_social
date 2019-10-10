import 'package:firebase_auth/firebase_auth.dart';

abstract class Authentication{
  Future<String> SignIn(String email, String password);
  Future<String> SignUp(String email, String password);
  Future<void> SignOut();
  Future<String> CurrentUser();
}

class Authen implements Authentication{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> SignIn(String email, String password) async{
    final FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }
  Future<String> SignUp(String email, String password) async{
    final FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }
  Future<void> SignOut() async{
    _firebaseAuth.signOut();
  }
  Future<String> CurrentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }
}