import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/blocs/auth_bloc.dart';
import 'package:uni_roomie/customtiles/CustomTile.dart';
import 'package:uni_roomie/screens/login/login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StreamSubscription<User> loginStateSubscription;

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
      appBar: AppBar(title: Text(''),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(

          ),
          Container(

          ),
          Container(

          ),
          Container(

          ),
          Container(

          ),
          Container(

          ),
          Container(

          ),
        ]),
      ),
    );
  }
}