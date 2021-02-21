import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/screens/login/LoginPage.dart';

import 'blocs/AuthBloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Provider(
    create: (context) => AuthBloc(),
    child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
      },
    ),
  ));
}
