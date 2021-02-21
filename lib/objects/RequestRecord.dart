import 'package:cloud_firestore/cloud_firestore.dart';

class RequestRecord {
  final DocumentReference user;
  final String status;
  final DocumentReference reference;

  RequestRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["user"] != null),
        assert(map["status"] != null),
        user = map["user"],
        status = map["status"];

  RequestRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "RequestRecord<$user:$status:$reference>";
}
