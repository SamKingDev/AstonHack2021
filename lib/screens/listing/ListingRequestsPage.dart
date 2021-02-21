import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_roomie/models/ListingRecord.dart';
import 'package:uni_roomie/models/RequestRecord.dart';
import 'package:uni_roomie/models/UserRecord.dart';

import 'SearchListingsResultsPage.dart';

class ListingRequestsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListingRequestsPageState();
}

class _ListingRequestsPageState extends State<ListingRequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Requests"),
        backgroundColor: new Color.fromRGBO(69, 93, 122, 1),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser.uid;

    DocumentReference userReference =
        FirebaseFirestore.instance.collection("users").doc(currentUser);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("listings")
          .where("owner", isEqualTo: userReference)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        if (snapshot.data.docs.length == 0) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "You do not have any active listings.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          );
        }

        ListingRecord listing =
            ListingRecord.fromSnapshot(snapshot.data.docs.first);

        if (listing.freeRooms <= 0) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Your listing has no free rooms left :D",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          );
        }

        return StreamBuilder<QuerySnapshot>(
          stream: listing.reference
              .collection("requests")
              .limit(listing.freeRooms)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            if (snapshot.data.docs.length == 0) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "There are no new requests.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              );
            }

            List<RequestRecord> requestRecords = snapshot.data.docs
                .map((e) => RequestRecord.fromSnapshot(e))
                .toList();

            return _buildList(context, requestRecords, listing);
          },
        );
      },
    );
  }

  _buildList(BuildContext context, List<RequestRecord> requestRecords,
      ListingRecord listingRecord) {
    return ListView(
      padding: const EdgeInsets.only(top: 5.0),
      children: requestRecords
          .map<Widget>((data) => _buildListItem(context, data, listingRecord))
          .toList(),
    );
  }

  Widget _buildHeader(BuildContext context, UserRecord otherUser) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
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
                          image: otherUser.profilePicture == null
                              ? AssetImage("assets/avatar4.png")
                              : NetworkImage(otherUser.profilePicture),
                          fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(otherUser.fullName),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Tag("Male", Colors.red),
                          Tag("Year 2", Colors.blue)
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
//                      Row(
//                        children: [
//                          SizedBox(width: 180),
//                          Icon(
//                            Icons.arrow_drop_down,
//                            size: 40,
//                          ),
//                        ],
//                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, RequestRecord requestRecord,
      ListingRecord listingRecord) {
    return FutureBuilder(
      future: getUserInfo(requestRecord.user),
      builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
        if (!userSnapshot.hasData) return LinearProgressIndicator();

        UserRecord otherUser = UserRecord.fromSnapshot(userSnapshot.data);

        return ExpandableNotifier(
          // <-- Provides ExpandableController to its children
          child: Column(
            children: [
              ScrollOnExpand(
                scrollOnExpand: true,
                scrollOnCollapse: false,
                child: ExpandablePanel(
                  header: _buildHeader(context, otherUser),
                  collapsed: Container(),
                  expanded: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () {
                            listingRecord.reference.update({
                              "freeRooms": listingRecord.freeRooms <= 0
                                  ? 0
                                  : FieldValue.increment(-1),
                            });

                            requestRecord.reference.delete();
                          },
                          color: new Color.fromRGBO(249, 89, 89, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Accept',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () {
                            requestRecord.reference.delete();
                          },
                          color: new Color.fromRGBO(249, 89, 89, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Deny',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          onPressed: () {},
                          color: new Color.fromRGBO(249, 89, 89, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Message Requester',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<DocumentSnapshot> getUserInfo(
      DocumentReference documentReference) async {
    return await documentReference.get();
  }
}
