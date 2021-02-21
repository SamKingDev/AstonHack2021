import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uni_roomie/models/ListingRecord.dart';
import 'package:uni_roomie/screens/listing/ShowAllListingsOnMap.dart';
import 'package:uni_roomie/screens/listing/ViewListingPage.dart';

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

class SearchListingsResultsPage extends StatefulWidget {
  final int minPrice;
  final int maxPrice;
  final int minDistance;
  final int maxDistance;
  final int roomsAvailable;
  final int totalRooms;
  List<ListingRecord> masterListings;

  SearchListingsResultsPage(
      {Key key,
      this.minPrice,
      this.maxPrice,
      this.minDistance,
      this.maxDistance,
      this.roomsAvailable,
      this.totalRooms})
      : super(key: key);

  @override
  _SearchListingsResultsPageState createState() =>
      _SearchListingsResultsPageState(minPrice, maxPrice, minDistance,
          maxDistance, roomsAvailable, totalRooms);
}

class _SearchListingsResultsPageState extends State<SearchListingsResultsPage> {
  final int minPrice;
  final int maxPrice;
  final int minDistance;
  final int maxDistance;
  final int roomsAvailable;
  final int totalRooms;

  _SearchListingsResultsPageState(this.minPrice, this.maxPrice,
      this.minDistance, this.maxDistance, this.roomsAvailable, this.totalRooms);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color.fromRGBO(69, 93, 122, 1),
        title: Text('Search Results'),
        centerTitle: true,
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.masterListings == null || widget.masterListings.length < 1) return;

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ShowAllListingsOnMapPage(widget.masterListings)),
          );
        },
        child: Icon(Icons.map),
      ),
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

        List<ListingRecord> listings = snapshot.data.docs
            .map((e) => ListingRecord.fromSnapshot(e))
            .toList();

        listings = listings
            .where((e) =>
                e.totalRooms <= totalRooms &&
                e.freeRooms <= roomsAvailable &&
                e.freeRooms > 0)
            .toList();


        widget.masterListings = listings;

        if (listings.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "There are no listings that meet your requirements.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          );
        }

        return _buildList(context, listings);
      },
    );
  }

  Widget _buildList(BuildContext context, List<ListingRecord> listings) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: listings
          .map<Widget>((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, ListingRecord listingRecord) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          splashColor: new Color.fromRGBO(69, 93, 122, 1),
          onTap: () {
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewListingPage(listingRecord)),
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
                            image: NetworkImage(listingRecord.photoURLs.first),
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
                            Tag(
                                listingRecord.genderPreference
                                    .toString()
                                    .split(".")[1]
                                    .replaceAll(
                                        "NoPreference", "No Preference"),
                                Colors.red),
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
