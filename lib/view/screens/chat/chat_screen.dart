
import 'package:firebase_app/provider/chat/chat_provider.dart';
import 'package:firebase_app/view/screens/chat/photo_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../models/chat_model.dart';
import '../../../provider/auth/auth_provider.dart';

class ChatScreen extends StatelessWidget {
  var message = TextEditingController();
  final user=FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    Provider.of<ChatProvider>(context).getUser();
    var userProvider=Provider.of<ChatProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
          userProvider.userModel.image),
            radius: 20),

        backgroundColor: Colors.teal,
        title: GestureDetector(
          onTap: (){Get.to(PhotoScreen());},
            child: Text(userProvider.userModel.name)),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  Provider.of<AuthProvider>(context, listen: false).logOut();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Logout'),
                  ],
                ),
              ),
            ];
          })
        ],
      ),
      body: (Provider.of<ChatProvider>(context).getChatStream()==null)?Center(child: CircularProgressIndicator()):Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatModel>>(
                stream: Provider.of<ChatProvider>(context).getChatStream(),
                //data returned will be in snapshot
                builder: (context, snapshot) {
                  List<ChatModel> chatList = snapshot.data ?? [];

                  return ListView.builder(reverse: true,
                    itemCount: chatList.length,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      bool isMe=chatList[index].userId ==user!.uid;
                      return isMe? Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Align(
                              alignment: (Alignment.topLeft),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (Colors.blue),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Text(
                                      chatList[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      chatList[index].message,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  userProvider.userModel.image),
                              radius: 20,
                            ),
                          )
                        ],
                      ): Row(
                        children: [
                          Container(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://www.salonlfc.com/wp-content/uploads/2018/01/image-not-found-scaled-1150x647.png"),
                              radius: 20,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Align(
                              alignment: (Alignment.topLeft),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (Colors.grey.shade200),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Text(
                                      chatList[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      chatList[index].message,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(controller: message,
                      clipBehavior: Clip.hardEdge,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "type a message...")),
                ),
                FloatingActionButton(
                  onPressed: () {

                    Provider.of<ChatProvider>(context, listen: false)
                        .sendMessage(ChatModel(
                            userId:userProvider.userModel.userId ,
                            name: userProvider.userModel.name,
                            message: message.text,
                            time: DateTime.now().toString(),
                            avatarUrl: userProvider.userModel.image));

                    message.clear();
                    FocusScope.of(context).unfocus(); //to un-focus keyboard after sending the message
                  },
                  child: Icon(Icons.send_sharp),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
