import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRecord {
  final DocumentReference sender;
  final Timestamp timestamp;
  final String content;
  final DocumentReference reference;

  MessageRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["sender"] != null),
        assert(map["timestamp"] != null),
        assert(map["content"] != null),
        sender = map["sender"],
        timestamp = map["timestamp"],
        content = map["content"];

  MessageRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "MessageRecord<$sender:$content:$timestamp:$reference>";
}
