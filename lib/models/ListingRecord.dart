import 'package:cloud_firestore/cloud_firestore.dart';

class ListingRecord {
  String title;
  GeoPoint geoPoint;
  double pricePerWeek;
  int totalRooms;
  int freeRooms;
  Gender genderPreference;
  List<dynamic> photoURLs;
  DocumentReference reference;
  CollectionReference requestCollection;
  DocumentReference userReference;

  ListingRecord(
      this.title,
      this.geoPoint,
      this.pricePerWeek,
      this.totalRooms,
      this.freeRooms,
      this.genderPreference,
      this.photoURLs,
      this.userReference);

  ListingRecord.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.title = map["title"];
    this.geoPoint = map["geoPoint"];
    this.pricePerWeek = double.parse(map["pricePerWeek"].toString());
    this.totalRooms = map["totalRooms"];
    this.freeRooms = map["freeRooms"];
    this.genderPreference = Gender.values
        .firstWhere((e) => e.toString() == "Gender." + map["genderPreference"]);
    this.photoURLs = map["photoURLs"];
    this.userReference = map["owner"];
    this.requestCollection = map["requests"];
  }

  ListingRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> toFirebase() {
    return {
      "title": title,
      "geoPoint": geoPoint,
      "pricePerWeek": pricePerWeek,
      "totalRooms": totalRooms,
      "freeRooms": freeRooms,
      "genderPreference": genderPreference.toString().split(".")[1],
      "photoURLs": photoURLs,
      "owner": userReference,
    };
  }
}

enum Gender { Female, Male, Other, NoPreference }
