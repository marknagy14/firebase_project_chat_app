import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/models/user_model.dart';
import 'package:firebase_app/view/screens/auth/login_screen.dart';
import 'package:firebase_app/view/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  void logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(ChatScreen());
    } catch (e) {
      print(e);
      Get.snackbar("Login error account", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red); // to show error message to user
    }
  }

  void logOut() async {
    try {
      await _auth.signOut();

      Get.offAll(LoginScreen());
    } catch (e) {
      print(e);
    }
  }

  void register(String name, String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(value);
       saveUser(value, name);
      });
      Get.offAll(ChatScreen());
    } catch (e) {
      print(e);
    }
  }

  void googleSignIn()async{
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print(googleUser);

      GoogleSignInAuthentication googleSignInAuthentication=await googleUser!.authentication;

      final AuthCredential credential=GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken,idToken:googleSignInAuthentication.idToken );

      await _auth.signInWithCredential(credential).then((value){
        saveUser(value, "");
        Get.offAll(ChatScreen());
      });


    }
    catch(e){
      print(e);
    }
  }

  void saveUser(UserCredential userCredential,String name)async{
    UserModel userModel = UserModel(
        name: name==""? userCredential.user!.displayName!: name, //if true means he signed in using google
        email: userCredential.user!.email!,
        image: "",
        userId: userCredential.user!
            .uid); //name is taken directly because we took it from textfromfield but the email and password are in firebase
    _firestore.collection("users").doc(userCredential.user!.uid).set(userModel.toJson());
  }



}
