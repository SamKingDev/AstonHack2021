import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
            university.get().then((value) => setState(() {universityName = value.data()["name"];}));
            course = event.data()["course"];
            course.get().then((value) => setState(() {courseName = value.data()["name"];}));
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
        title: Text('Your Profile'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text(
                          'Change Avatar',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: new Color.fromRGBO(180, 190, 201, 1),// set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(10.0)), // set rounded corner radius
              boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))]),
          child: Column(
            children: [
              Container(
                child: CustomProfileTile(Icons.account_box, 'Name', fullName == null ? "N/A" : fullName),
              ),
              Container(
                child: CustomProfileTile(
                    Icons.alternate_email, 'Email', email == null ? "N/A" : email),
              ),
              Container(
                child: CustomProfileTile(Icons.person, 'Gender', gender == null ? "N/A" : gender),
              ),
              Container(
                child: CustomProfileTile(Icons.grade, 'Age', age == null ? "N/A" : age.toString()),
              ),
              Container(
                child: CustomProfileTile(
                    Icons.school, 'University', universityName == null ? "N/A" : universityName),
              ),
              Container(
                child: CustomProfileTile(
                    Icons.bookmark, 'Course', courseName == null ? "N/A" : courseName),
              ),
              Container(
                child: CustomProfileTile(Icons.trending_up, 'Year Of Study', yearOfStudy == null ? "N/A" : yearOfStudy.toString()),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  onPressed: () {},
                  color: new Color.fromRGBO(249, 89, 89, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Icon(
                          Icons.edit,
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
