import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_roomie/screens/viewListings/viewListings.dart';

class Request extends StatefulWidget {
  String img;
  String name;

  Request(this.img, this.name);

  @override
  _Request createState() => _Request();
}

class _Request extends State<Request> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
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
                            image: NetworkImage(widget.img), fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name),
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("View Profile")
                      ],
                    ),

                  ],
                ),
              ),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: new Color.fromRGBO(180, 190, 201, 1),
                // set border width
                borderRadius: BorderRadius.circular(10),
                // set rounded corner radius
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.black, offset: Offset(1, 3))
                ]),
          ),
        ));
  }
}

class listingRequests extends StatefulWidget {
  @override
  _listingRequestsState createState() => _listingRequestsState();
}

class _listingRequestsState extends State<listingRequests> {
  String tmpImage =
      "https://www.accommodationengine.co.uk/imagecache/750/450/storage/galleries/bC3fWJ/Student_Accommodation_Birmingham_Bentley_House_1.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('View Requests'), centerTitle: true),
        body: SingleChildScrollView(
          child: Request(tmpImage, "Bob"),
        ));
  }
}
