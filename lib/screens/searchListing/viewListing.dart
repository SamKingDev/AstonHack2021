import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/blocs/auth_bloc.dart';
import 'package:uni_roomie/customtiles/CustomTile.dart';
import 'package:uni_roomie/screens/login/login.dart';

class viewListingPage extends StatefulWidget {
  @override
  _viewListingPageState createState() => _viewListingPageState();
}

class _viewListingPageState extends State<viewListingPage> {
  StreamSubscription<User> loginStateSubscription;
  String university;
  RangeValues _priceRangeValues = const RangeValues(100, 1000);
  RangeValues _distanceRangeValues = const RangeValues(0, 50);

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
            padding: const EdgeInsets.all(15.0),
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
            margin: EdgeInsets.all(20),
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
                    Text('Min Value, Max Value'),
                  ],
                ),
                RangeSlider(
                  values: _priceRangeValues,
                  min: 100,
                  max: 1000,
                  divisions: 45,
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
            margin: EdgeInsets.all(20),
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
                    Text('Within ... Miles'),
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
            margin: EdgeInsets.all(20),
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
                Text('Rooms Currently Available'),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
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
                Text('Total Rooms In House'),
              ],
            ),
          ),
          Container(),
          Container(),
        ]),
      ),
    );
  }
}
