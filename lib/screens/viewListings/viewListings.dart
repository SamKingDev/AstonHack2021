import 'package:flutter/material.dart';

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
          child:Container(
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

class Listing extends StatefulWidget {
  // IconData icon;
  // String text;
  // Function onTap;

  String img;
  String title;
  double distance; //in miles
  int rooms;
  int price;
  String genderPreference;

  Listing(this.img, this.title, this.distance, this.rooms, this.price, this.genderPreference);

  @override
  _Listing createState() => _Listing();
}

class _Listing extends State<Listing> {
  String tmpImage =
      "https://www.accommodationengine.co.uk/imagecache/750/450/storage/galleries/bC3fWJ/Student_Accommodation_Birmingham_Bentley_House_1.jpg";

  //have access to widget.varname
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
                            image: NetworkImage(tmpImage), fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title),
                        SizedBox(
                          height: 8,
                        ),
                        Text("${widget.distance} Miles Away"),
                        SizedBox(
                          height: 8,
                        ),
                        Text("£${widget.price} Per Week"),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Tag("Male", Colors.red),
                            Tag("2 Bedroom House", Colors.blue),
                          ],
                        ),
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

class viewListingsPage extends StatefulWidget {
  @override
  _viewListingsPageState createState() => _viewListingsPageState();
}

class _viewListingsPageState extends State<viewListingsPage> {
  //have access to widget.varname
  String tmpImage =
      "https://www.accommodationengine.co.uk/imagecache/750/450/storage/galleries/bC3fWJ/Student_Accommodation_Birmingham_Bentley_House_1.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Search Results'), centerTitle: true),
        body: SingleChildScrollView(
          child: Listing(tmpImage, "Title", 5.0, 2, 2, "Male"),
        ));
  }
}

