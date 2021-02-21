import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinOnMap extends StatefulWidget {
  GeoPoint geoPoint;

  PinOnMap(this.geoPoint);

  @override
  _PinOnMapState createState() => _PinOnMapState();
}

class _PinOnMapState extends State<PinOnMap> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(widget.geoPoint.latitude, widget.geoPoint.longitude), zoom: 15),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of([Marker(position: LatLng(widget.geoPoint.latitude, widget.geoPoint.longitude), markerId: MarkerId("1"))]),
      ),
    );
  }
}
