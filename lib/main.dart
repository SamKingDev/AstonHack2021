import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/screens/createListing/createListing.dart';
import 'package:uni_roomie/screens/login/login.dart';
import 'package:uni_roomie/screens/profile/profile.dart';
import 'package:uni_roomie/screens/searchListing/viewListing.dart';
import 'package:uni_roomie/screens/viewListings/viewListings.dart';


import 'blocs/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Provider(
    create: (context) => AuthBloc(),
    child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/profile': (context) => ProfilePage(),
        '/createListing': (context) => createListingPage(),
        '/viewListing': (context) => viewListingPage(),
      },
    ),
  ));
}
