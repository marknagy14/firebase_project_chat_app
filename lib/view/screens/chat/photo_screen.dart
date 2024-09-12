import 'package:firebase_app/provider/chat/photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../provider/chat/chat_provider.dart';

class PhotoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<PhotoProvider>(context,listen: false);
    var chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Photo Screen'),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: CircleAvatar(
                    backgroundImage: NetworkImage(chatProvider.userModel==""?
                        "https://www.salonlfc.com/wp-content/uploads/2018/01/image-not-found-scaled-1150x647.png":chatProvider.userModel.image),
                    radius: 100),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Row(
                  children: [SizedBox(width: 10,),
                    ElevatedButton(
                        onPressed: () {
                          provider.getImage(ImageSource.gallery);
                        },
                        child: Text(
                          "add image from gallery",
                          style: TextStyle(fontSize: 15),
                        ))
                  ,SizedBox(width: 18,),Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            provider.getImage(ImageSource.camera);
                          },
                          child: Text(
                            "take a picture",
                            style: TextStyle(fontSize: 15),
                          )),
                  ),SizedBox(width: 10)],
                ),
              )
            ],
          ),
        ));
  }
}
