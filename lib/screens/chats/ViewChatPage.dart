import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_roomie/screens/profile/viewOtherProfile.dart';

import 'ChatRecord.dart';
import 'MessageRecord.dart';
import 'UserRecord.dart';

class ViewChatPage extends StatefulWidget {
  final ChatRecord chatRecord;
  final UserRecord otherUser;

  ViewChatPage({Key key, @required this.chatRecord, @required this.otherUser})
      : super(key: key);

  @override
  _ViewChatPageState createState() => _ViewChatPageState(chatRecord, otherUser);
}

class _ViewChatPageState extends State<ViewChatPage> {
  final ChatRecord chatRecord;
  final UserRecord otherUser;

  final messageController = TextEditingController();

  _ViewChatPageState(this.chatRecord, this.otherUser);

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: new Color.fromRGBO(69, 93, 122, 1),
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              IconButton(
                icon: CircleAvatar(
                  backgroundImage: otherUser.profilePicture == null
                      ? AssetImage("assets/avatar4.png")
                      : NetworkImage(otherUser.profilePicture),
                  maxRadius: 20,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => viewOtherProfilePage(otherUser.reference.id)),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      otherUser.fullName,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildChats(context),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: () {
                    String message = messageController.text;

                    if (messageController.text.isEmpty) {
                      return;
                    }

                    User currentUser = FirebaseAuth.instance.currentUser;

                    DocumentReference userReference = FirebaseFirestore.instance
                        .collection("users")
                        .doc(currentUser.uid);

                    chatRecord.reference.collection("messages").add({
                      "content": message,
                      "sender": userReference,
                      "timestamp": Timestamp.now(),
                    });

                    messageController.clear();
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChats(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRecord.reference
          .collection("messages")
          .orderBy("timestamp")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(
      BuildContext context, List<QueryDocumentSnapshot> documents) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 5, bottom: 5),
      children: documents
          .map<Widget>((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  _buildListItem(BuildContext context, QueryDocumentSnapshot data) {
    MessageRecord messageRecord = MessageRecord.fromSnapshot(data);

    User currentUser = FirebaseAuth.instance.currentUser;

    DocumentReference userReference =
        FirebaseFirestore.instance.collection("users").doc(currentUser.uid);

    DateFormat dateFormat = DateFormat.Hm();
    String formattedDate = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(
            messageRecord.timestamp.millisecondsSinceEpoch));

    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      child: Align(
        alignment: (messageRecord.sender == userReference)
            ? Alignment.topLeft
            : Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (messageRecord.sender == userReference)
                ? Colors.blueGrey.shade100
                : Colors.blue.shade100,
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            messageRecord.content,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
