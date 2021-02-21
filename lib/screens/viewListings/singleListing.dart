import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:uni_roomie/objects/listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_roomie/screens/profile/viewOtherProfile.dart';

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
    if (widget.listing != null && widget.listing.userReference != null)
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.listing.userReference.id)
          .get()
          .then((value) => setState(() {
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
                onPressed: () => {},
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
                onPressed: () => {},
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
                    MaterialPageRoute(builder: (context) => viewOtherProfilePage(widget.listing.userReference.id)),
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
