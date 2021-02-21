import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/blocs/AuthBloc.dart';
import 'package:uni_roomie/screens/profile/ProfilePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  StreamSubscription<User> loginStateSubscription;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(''),
          backgroundColor: new Color.fromRGBO(69, 93, 122, 1),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            child: Image(
              image: AssetImage('assets/logo.png'),
              height: 300,
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                authBloc.loginGoogle();
              },
              color: new Color.fromRGBO(249, 89, 89, 1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Login Using Google',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 40.0),
          Container(),
          Container(),
          Container(),
          Container(),
        ]),
      ),
    );
  }
}
