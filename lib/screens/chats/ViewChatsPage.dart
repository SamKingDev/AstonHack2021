import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uni_roomie/screens/searchListing/viewListing.dart';
import 'package:uni_roomie/screens/viewListings/viewListings.dart';

import 'ChatRecord.dart';
import 'UserRecord.dart';
import 'ViewChatPage.dart';

class ViewChatsPage extends StatefulWidget {
  @override
  _ViewChatsPageState createState() => _ViewChatsPageState();
}

class _ViewChatsPageState extends State<ViewChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        backgroundColor: new Color.fromRGBO(69, 93, 122, 1),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    DocumentReference userReference =
        FirebaseFirestore.instance.collection("users").doc(currentUser);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        List<ChatRecord> userRecords = snapshot.data.docs.map((e) => ChatRecord.fromSnapshot(e)).toList();

        return _buildList(context, userRecords.where((e) => e.user1 == userReference || e.user2 == userReference).toList());
      },
    );
  }

  Widget _buildList(
      BuildContext context, List<ChatRecord> chatRecords) {
    if (chatRecords.isEmpty) return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [Text("No current chats, message a listing owner to get chatting!", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),              Container(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0)),
          onPressed: () {Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => viewListingPage()),
          );},
          color: new Color.fromRGBO(249, 89, 89, 1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View Listings',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.house,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),])
    );
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: chatRecords
          .map<Widget>((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  Future<DocumentSnapshot> getUserInfo(
      DocumentReference documentReference) async {
    return await documentReference.get();
  }

  _buildListItem(BuildContext context, ChatRecord chatRecord) {
    User currentUser = FirebaseAuth.instance.currentUser;

    DocumentReference userReference =
        FirebaseFirestore.instance.collection("users").doc(currentUser.uid);

    return FutureBuilder(
        future: getUserInfo(userReference == chatRecord.user1 ? chatRecord.user2 : chatRecord.user1),
        builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
          if (!userSnapshot.hasData) {
            return LinearProgressIndicator();
          }

          UserRecord otherUser = UserRecord.fromSnapshot(userSnapshot.data);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewChatPage(
                      chatRecord: chatRecord, otherUser: otherUser),
                ),
              );
            },
            child: Container(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: otherUser.profilePicture == null
                              ? AssetImage("assets/avatar4.png")
                              : NetworkImage(otherUser.profilePicture),
                          maxRadius: 30,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  otherUser.fullName,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
