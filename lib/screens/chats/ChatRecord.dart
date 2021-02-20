import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRecord {
  // self
  final DocumentReference user1;
  final DocumentReference user2;
  final CollectionReference messages;
  final DocumentReference reference;

  ChatRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["user1"] != null),
        assert(map["user2"] != null),
        user1 = map["user1"],
        user2 = map["user2"],
        messages = map["messages"];

  ChatRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  ChatRecord test(Map<String, dynamic> map, value, {reference}) {
    map["user2"] = value;

    return ChatRecord.fromMap(map, reference: reference);
  }

  @override
  String toString() => "ChatRecord<$user1:$user2:$messages:$reference>";
}