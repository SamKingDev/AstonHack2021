import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/blocs/auth_bloc.dart';
import 'package:uni_roomie/customtiles/CustomTile.dart';
import 'package:uni_roomie/screens/login/login.dart';
import 'package:uni_roomie/screens/viewListings/viewListings.dart';

class viewListingPage extends StatefulWidget {
  @override
  _viewListingPageState createState() => _viewListingPageState();
}

class _viewListingPageState extends State<viewListingPage> {
  StreamSubscription<User> loginStateSubscription;
  String university;
  RangeValues _priceRangeValues = const RangeValues(50, 450);
  RangeValues _distanceRangeValues = const RangeValues(0, 50);

  TextEditingController _roomsAvailableController = TextEditingController();
  TextEditingController _totalRoomsController = TextEditingController();

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    return Scaffold(
      drawer: CustomDrawer(authBloc),
      appBar: AppBar(
        title: Text('Search For Listings'),
        centerTitle: true,
        backgroundColor: new Color.fromRGBO(69, 93, 122, 1),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              child: Text(
                'Listings around $university',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price Range'),
                    Text(
                        '£${_priceRangeValues.start.round()} - £${_priceRangeValues.end.round()} '),
                  ],
                ),
                RangeSlider(
                  values: _priceRangeValues,
                  min: 50,
                  max: 450,
                  divisions: 40,
                  labels: RangeLabels(
                    _priceRangeValues.start.round().toString(),
                    _priceRangeValues.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceRangeValues = values;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Distance'),
                    Text('Within ${_distanceRangeValues.end.round()} Miles'),
                  ],
                ),
                RangeSlider(
                  values: _distanceRangeValues,
                  min: 0,
                  max: 50,
                  divisions: 50,
                  labels: RangeLabels(
                    _distanceRangeValues.start.round().toString(),
                    _distanceRangeValues.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _distanceRangeValues = values;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
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
            child: Row(
              children: [
                Text('Rooms Available:'),
                SizedBox(width: 20),
                Flexible(
                  child: TextFormField(
                    controller: _roomsAvailableController,
                    keyboardType: TextInputType.number,
                    cursorColor: new Color.fromRGBO(249, 89, 89, 1),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      enabledBorder: new UnderlineInputBorder(),
                      focusedBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: new Color.fromRGBO(249, 89, 89, 1),
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    //controller:
                  ),
                ),
              ],
            ),
          ),
          Container(
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
            child: Row(
              children: [
                Text('Total Rooms:'),
                SizedBox(width: 20),
                Flexible(
                  child: TextFormField(
                    controller: _totalRoomsController,
                    keyboardType: TextInputType.number,
                    cursorColor: new Color.fromRGBO(249, 89, 89, 1),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      enabledBorder: new UnderlineInputBorder(),
                      focusedBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: new Color.fromRGBO(249, 89, 89, 1),
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    //controller:
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                int minPrice = _priceRangeValues.start.toInt();
                int maxPrice = _priceRangeValues.end.toInt();

                int minDistance = _distanceRangeValues.start.toInt();
                int maxDistance = _distanceRangeValues.end.toInt();

                int roomsAvailable = _roomsAvailableController.text.isEmpty ? 0 : int.parse(_roomsAvailableController.text);
                int totalRooms = _totalRoomsController.text.isEmpty ? 0 : int.parse(_totalRoomsController.text);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewListingsPage(
                    minPrice: minPrice,
                    maxPrice: maxPrice,
                    minDistance: minDistance,
                    maxDistance: maxDistance,
                    roomsAvailable: roomsAvailable,
                    totalRooms: totalRooms,
                  )),
                );
              },
              color: new Color.fromRGBO(249, 89, 89, 1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Search For Rooms',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
          Container(),
          Container(),
        ]),
      ),
    );
  }
}
