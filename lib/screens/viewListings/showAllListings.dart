import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uni_roomie/objects/listing.dart';
import 'package:uni_roomie/screens/viewListings/singleListing.dart';
import 'package:geolocator/geolocator.dart';

class ShowAllListings extends StatefulWidget {
  List<Listing> listings;

  ShowAllListings(this.listings);

  @override
  _ShowAllListingsState createState() => _ShowAllListingsState();
}

class _ShowAllListingsState extends State<ShowAllListings> {
  Completer<GoogleMapController> _controller = Completer();
  Position _currentPosition;

  @override
  Widget build(BuildContext context) {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    widget.listings.forEach((element) {
      markers.putIfAbsent(
          MarkerId(element.reference.id),
          () => Marker(
              markerId: MarkerId(element.reference.id),
              position:
                  LatLng(element.geoPoint.latitude, element.geoPoint.longitude),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleListingPage(element)),
                );
              }));
    });
    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(
                _currentPosition != null ? _currentPosition.latitude : widget.listings.first.geoPoint.latitude,
                _currentPosition != null ? _currentPosition.longitude : widget.listings.first.geoPoint.longitude),
            zoom: 12.5),
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }
}
