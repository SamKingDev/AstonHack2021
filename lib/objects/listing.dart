import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  String title;
  GeoPoint geoPoint;
  double pricePerWeek;
  int totalRooms;
  int freeRooms;
  Gender genderPreference;
  List<String> photoURLs;
  DocumentReference reference;

  Listing(this.title, this.geoPoint, this.pricePerWeek, this.totalRooms,
      this.freeRooms, this.genderPreference, this.photoURLs);

  Listing.fromMap(Map<String, dynamic> map, {this.reference}){
    this.title = map["title"];
    this.geoPoint = map["geoPoint"];
    this.pricePerWeek = map["pricePerWeek"];
    this.totalRooms = map["totalRooms"];
    this.freeRooms = map["freeRooms"];
    this.genderPreference = Gender.values.firstWhere((e) => e.toString() == "Gender." + map["genderPreference"]);
    this.photoURLs = map["photoURLs"];
  }

  Listing.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> toFirebase() {
    return {
      "title": title,
      "geoPoint": geoPoint,
      "pricePerWeek": pricePerWeek,
      "totalRooms": totalRooms,
      "freeRooms": freeRooms,
      "genderPreference": genderPreference.toString().split(".")[1],
      "photoURLs": photoURLs
    };
  }
}

enum Gender {
  Female,
  Male,
  Other,
  NoPreference
}