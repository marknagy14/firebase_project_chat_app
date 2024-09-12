import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';


class ChatProvider extends ChangeNotifier {
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth=FirebaseAuth.instance;
UserModel userModel = UserModel(name: "", email: "", image: "", userId: "");

Stream<List<ChatModel>> getChatStream(){
  return _firestore.collection("chat").orderBy("time",descending: true).snapshots().map((event){ //snapshots means you want all data not a specific document
     return List<ChatModel>.from(event.docs.map((e) => ChatModel.fromJson(e.data())));
  });
}

void sendMessage(ChatModel chatModel)async{
  await _firestore.collection("chat").add(chatModel.toJson());
}

getUser()async{
  await _firestore.collection("users").doc(_auth.currentUser!.uid).get().then((value)  {
     userModel=UserModel.fromJson(value.data()!);
     notifyListeners();
  });
}




}
