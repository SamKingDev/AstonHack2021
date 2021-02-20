import 'package:flutter/material.dart';

//Divider - > Container(height: 100, child: Divider(color: Colors.black))

class createListingPage extends StatefulWidget {
  @override
  _createListingPageState createState() => _createListingPageState();
}

class _createListingPageState extends State<createListingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Listing'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  //Listing Title
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text("Listing Title"),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Title...',
                          labelStyle: TextStyle(fontSize: 10.0)),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    )
                  ])),
              SizedBox(
                height: 50,
              ),
              Container(
                  //Address
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text("Address"),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Address Line 1...',
                          labelStyle: TextStyle(fontSize: 10.0)),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Address Line 2...',
                          labelStyle: TextStyle(fontSize: 10.0)),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Address Line 3...',
                          labelStyle: TextStyle(fontSize: 10.0)),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ])),
              SizedBox(
                height: 50,
              ),
              Container(
                  //Price
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text("Price Per Week"),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Price...',
                          labelStyle: TextStyle(fontSize: 10.0)),
                      keyboardType: TextInputType.number,
                      maxLines: null,
                    ),
                  ])),
              SizedBox(
                height: 50,
              ),
              Container(
                  //no. of people
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text("Number of People Currently In The Flat"),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Number...',
                          labelStyle: TextStyle(fontSize: 10.0)),
                      keyboardType: TextInputType.number,
                      maxLines: null,
                    ),
                  ])),
              SizedBox(
                height: 50,
              ),
              Container(
                  //no. of rooms
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text("Number of Rooms"),
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Rooms...',
                          labelStyle: TextStyle(fontSize: 10.0)),
                      keyboardType: TextInputType.number,
                      maxLines: null,
                    ),
                  ])),
              SizedBox(
                height: 50,
              ),
              Container(
                  //gender preference
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text("Gender Preference"),
                    DropdownButton<String>(
                      items: <String>['Male', 'Female', 'Other']
                          .map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    )
                  ])),
              SizedBox(
                height: 50,
              ),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.add_a_photo, size: 50),
                  Icon(Icons.add_a_photo, size: 50),
                  Icon(Icons.add_a_photo, size: 50),
                ],
              )),
              SizedBox(
                height: 50,
              ),
              Center(
                child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0)),
                    color: Color.fromRGBO(249, 89, 89, 1),
                    child: Text("Create Listing"),
                    onPressed: () {}),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
