import 'package:flutter/material.dart';
import 'package:uni_roomie/objects/listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleListingPage extends StatefulWidget {
  Listing listing;
  String userName;

  SingleListingPage(this.listing);

  @override
  _SingleListingPageState createState() => _SingleListingPageState();
}

class _SingleListingPageState extends State<SingleListingPage> {
  @override
  void initState() {
    if (widget.listing != null && widget.listing.userReference != null) FirebaseFirestore.instance
        .collection("users")
        .doc(widget.listing.userReference.id)
        .get()
        .then((value) => setState(() {
              widget.userName = value.data()["full_name"];
            }));
  }

  @override
  Widget build(BuildContext context) {
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
                //list of photos

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
              child: ListingInformationTile(
                  Icons.person, 'Owner\'s Name', widget.userName == null ? "N/A" : widget.userName),
            ),
            FittedBox(
              child: Container(
                child: ListingInformationTile(Icons.group, 'Gender Preference',
                    widget.listing.genderPreference.toString().split(".")[1]),
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
