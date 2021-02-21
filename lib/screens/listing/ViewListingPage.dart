import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/blocs/AuthBloc.dart';
import 'package:uni_roomie/models/ListingRecord.dart';
import 'package:uni_roomie/models/UserRecord.dart';
import 'package:uni_roomie/screens/helpers.dart';
import 'package:uni_roomie/screens/listing/PinOnMapPage.dart';
import 'package:uni_roomie/screens/login/LoginPage.dart';
import 'package:uni_roomie/screens/profile/ViewOtherProfilePage.dart';

class ViewListingPage extends StatefulWidget {
  StreamSubscription<User> loginStateSubscription;
  ListingRecord listing;
  String userName;
  DocumentReference userReference;
  UserRecord otherUser;

  ViewListingPage(this.listing);

  @override
  _ViewListingPageState createState() => _ViewListingPageState();
}

class _ViewListingPageState extends State<ViewListingPage> {
  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    widget.loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        FirebaseFirestore.instance
            .collection("users")
            .doc(fbUser.uid)
            .get()
            .then((value) => widget.userReference = value.reference);
      }
    });
    if (widget.listing != null && widget.listing.userReference != null)
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.listing.userReference.id)
          .get()
          .then((value) => setState(() {
                widget.otherUser = new UserRecord.fromSnapshot(value);
                widget.userName = value.data()["full_name"];
              }));
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.listing.photoURLs
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color.fromRGBO(69, 93, 122, 1),
        title: Text("Property"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: new Color.fromRGBO(180, 190, 201, 1),
              // set border width
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              // set rounded corner radius
              boxShadow: [
                BoxShadow(
                    blurRadius: 10, color: Colors.black, offset: Offset(1, 3))
              ]),
          child: Column(children: [
            Container(
              child: Column(children: [
                CarouselSlider(
                  items: imageSliders,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.listing.photoURLs.map((url) {
                    int index = widget.listing.photoURLs.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ]),
            ),
            Container(
              child: ListingInformationTile(
                  Icons.house, 'Title:', widget.listing.title),
            ),
            Container(
              child: ListingInformationTile(Icons.money, 'Price Per Week:',
                  '£${widget.listing.pricePerWeek}'),
            ),
            Container(),
            Container(
              child: ListingInformationTile(Icons.room, 'Rooms Available',
                  widget.listing.freeRooms.toString()),
            ),
            Container(
              child: ListingInformationTile(Icons.person, 'Owner\'s Name',
                  widget.userName == null ? "N/A" : widget.userName),
            ),
            FittedBox(
              child: Container(
                child: ListingInformationTile(Icons.group, 'Gender Preference',
                    widget.listing.genderPreference.toString().split(".")[1]),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                onPressed: () {
                  DocumentReference userReference = getUserReference();

                  widget.listing.reference.collection("requests").add({
                    "status": "requested",
                    "user": userReference,
                  });

                  sendMessage(
                    context,
                    userReference,
                    widget.listing.userReference,
                    "Hello, I have requested to join your listing for ${widget.listing.title}.",
                    true,
                  );
                },
                color: Colors.greenAccent.shade400,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Request to Join',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                onPressed: () => sendMessage(
                  context,
                  widget.userReference,
                  widget.listing.userReference,
                  "Hello, I'm interested in this listing! Please can I get more info.",
                  true,
                ),
                color: Colors.lightBlueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Message owner',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.message,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewOtherProfilePage(
                            widget.listing.userReference.id)),
                  );
                },
                color: Colors.lightBlueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View Owner\'s profile',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.perm_identity,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PinOnMapPage(widget.listing.geoPoint)),
                  );
                },
                color: Colors.lightBlueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View on map',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.map,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class ListingInformationTile extends StatefulWidget {
  IconData icon;
  String text;
  String content;

  ListingInformationTile(this.icon, this.text, this.content);

  @override
  _ListingInformationTile createState() => _ListingInformationTile();
}

class _ListingInformationTile extends State<ListingInformationTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[800]))),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //x axis
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(widget.icon),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.text,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              Text(widget.content),
            ],
          ),
        ),
      ),
    );
  }
}
