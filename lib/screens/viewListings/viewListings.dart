import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uni_roomie/objects/listing.dart';
import 'package:uni_roomie/screens/viewListings/singleListing.dart';

import '../profile/profile.dart';

class Tag extends StatefulWidget {
  String text;
  Color color;

  Tag(this.text, this.color);

  @override
  _Tag createState() => _Tag();
}

class _Tag extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Container(
            child: Text(widget.text),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.color,
        ),
      ),
    );
  }
}

class ViewListingsPage extends StatefulWidget {
  final int minPrice;
  final int maxPrice;
  final int minDistance;
  final int maxDistance;
  final int roomsAvailable;
  final int totalRooms;

  ViewListingsPage(
      {Key key,
      this.minPrice,
      this.maxPrice,
      this.minDistance,
      this.maxDistance,
      this.roomsAvailable,
      this.totalRooms})
      : super(key: key);

  @override
  _ViewListingsPageState createState() => _ViewListingsPageState(
      minPrice, maxPrice, minDistance, maxDistance, roomsAvailable, totalRooms);
}

class _ViewListingsPageState extends State<ViewListingsPage> {
  final int minPrice;
  final int maxPrice;
  final int minDistance;
  final int maxDistance;
  final int roomsAvailable;
  final int totalRooms;

  _ViewListingsPageState(this.minPrice, this.maxPrice, this.minDistance,
      this.maxDistance, this.roomsAvailable, this.totalRooms);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color.fromRGBO(69, 93, 122, 1),
        title: Text('Search Results'),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("listings")
          .where("pricePerWeek", isGreaterThanOrEqualTo: minPrice)
          .where("pricePerWeek", isLessThanOrEqualTo: maxPrice)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        List<Listing> listings =
            snapshot.data.docs.map((e) => Listing.fromSnapshot(e)).toList();

        listings = listings
            .where((e) =>
                e.totalRooms <= totalRooms && e.freeRooms <= roomsAvailable)
            .toList();

        return _buildList(context, listings);
      },
    );
  }

  Widget _buildList(BuildContext context, List<Listing> listings) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: listings
          .map<Widget>((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Listing listingRecord) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          splashColor: new Color.fromRGBO(69, 93, 122, 1),
          onTap: () {
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleListingPage(listingRecord)),
              );
            }
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://www.accommodationengine.co.uk/imagecache/750/450/storage/galleries/bC3fWJ/Student_Accommodation_Birmingham_Bentley_House_1.jpg"),
                            fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listingRecord.title),
                        SizedBox(
                          height: 8,
                        ),
                        Text("0 Miles Away"),
                        SizedBox(
                          height: 8,
                        ),
                        Text("£${listingRecord.pricePerWeek} Per Week"),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Tag("Male", Colors.red),
                            Tag("${listingRecord.totalRooms} Bedroom House",
                                Colors.blue),
                            Tag("${listingRecord.freeRooms} Free Rooms",
                                Colors.blue),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            alignment: Alignment.center,
          ),
        ));
  }
}
