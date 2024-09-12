import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoProvider extends ChangeNotifier {


  final ImagePicker _picker = ImagePicker();
  FirebaseStorage _firebaseStorage=FirebaseStorage.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseFirestore firestore=FirebaseFirestore.instance;


  void getImage(ImageSource src) async {
    final XFile? pickedImageFile = await _picker.pickImage(source: src,imageQuality: 50,maxWidth: 300,maxHeight: 300);
    if (pickedImageFile != null) {
      File pickImage=File(pickedImageFile.path);
      await _firebaseStorage.ref().child(_auth.currentUser!.uid+".jpg").putFile(pickImage); //child :Esm el sora samiha ai haga

      final url =await _firebaseStorage.ref().child(_auth.currentUser!.uid+".jpg").getDownloadURL();

      await firestore.collection("users").doc(_auth.currentUser!.uid).update({"image":url});
      firestore.collection("chat").where("uId", isEqualTo: _auth.currentUser!.uid).get().then((value) {
        value.docs.forEach((element) {
          firestore.collection("chat").doc(element.id).update({"avatarUrl": url});
        });
      });
    }
    else {
          print("no image found");
    }
    notifyListeners();
  }

}
