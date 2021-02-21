import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_roomie/models/ChatRecord.dart';
import 'package:uni_roomie/models/UserRecord.dart';

import 'chat/ViewChatPage.dart';

void sendMessage(
  BuildContext context,
  DocumentReference user1,
  DocumentReference user2,
  String messageContent,
  bool redirect,
) {
  FirebaseFirestore.instance.collection("chats").add({
    "user1": user1,
    "user2": user2,
  }).then((value) {
    FirebaseFirestore.instance
        .collection("chats")
        .doc(value.id)
        .collection("messages")
        .add({
      "content": messageContent,
      "sender": user1,
      "timestamp": Timestamp.now(),
    }).then(
      (message) => FirebaseFirestore.instance
          .collection("users")
          .doc(user2.id)
          .get()
          .then((user2Record) => {
                if (redirect)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewChatPage(
                        chatRecord: ChatRecord.fromMap({
                          "user1": user1,
                          "user2": user2,
                          "messages": message.parent,
                        }, reference: value),
                        otherUser: UserRecord.fromSnapshot(user2Record),
                      ),
                    ),
                  ),
              }),
    );
  });
}

DocumentReference getUserReference() {
  User currentUser = FirebaseAuth.instance.currentUser;

  return FirebaseFirestore.instance.collection("users").doc(currentUser.uid);
}
