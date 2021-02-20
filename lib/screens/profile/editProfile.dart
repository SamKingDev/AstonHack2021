import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/blocs/auth_bloc.dart';
import 'package:uni_roomie/customtiles/CustomTile.dart';
import 'package:uni_roomie/screens/login/login.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  StreamSubscription<User> loginStateSubscription;
  String fullName;
  String email;
  String gender;
  int age;
  DocumentReference university;
  String universityName;
  DocumentReference course;
  String courseName;
  int yearOfStudy;

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
      } else {
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection('users').doc(fbUser.uid);
        documentReference.snapshots().listen((event) {
          setState(() {
            if (!mounted) return;
            fullName = event.data()["full_name"];
            email = event.data()["email"];
            gender = event.data()["gender"];
            age = event.data()["age"];
            university = event.data()["university"];
            university.get().then((value) => setState(() {
                  universityName = value.data()["name"];
                }));
            course = event.data()["course"];
            course.get().then((value) => setState(() {
                  courseName = value.data()["name"];
                }));
            yearOfStudy = event.data()["yearOfStudy"];
          });
        });
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
        title: Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: new Color.fromRGBO(69, 93, 122, 1),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: new Color.fromRGBO(180, 190, 201, 1),
              ),
              child: Container(
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar4.png'),
                    radius: 40.0,
                  ),
                ),
              ),
            ),
          ],
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
              Container(
                child: EditProfileTile(Icons.account_box, 'Name'),
              ),
              Container(
                child: EditProfileList(Icons.person, 'Gender'),
              ),
              Container(
                child: EditProfileTile(Icons.grade, 'Age'),
              ),
              Container(
                child: CustomProfileTile(Icons.school, 'University',
                    universityName == null ? "N/A" : universityName),
              ),
              Container(
                child: CustomProfileTile(Icons.bookmark, 'Course',
                    courseName == null ? "N/A" : courseName),
              ),
              Container(
                child: EditProfileTile(Icons.trending_up, 'Year Of Study'),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()),
                    );
                  },
                  color: new Color.fromRGBO(249, 89, 89, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.save_alt,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(),
            ],
          ),
        ),
      ])),
    );
  }
}
