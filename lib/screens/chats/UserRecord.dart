import 'package:cloud_firestore/cloud_firestore.dart';

class UserRecord {
  final String email;
  final String fullName;
  final DocumentReference reference;
  String profilePicture;

  UserRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["email"] != null),
        assert(map["full_name"] != null),
        email = map["email"],
        fullName = map["full_name"],
        profilePicture = map["profilePhoto"];

  UserRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "UserRecord<$email:$fullName:$reference>";
}