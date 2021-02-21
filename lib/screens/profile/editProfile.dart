import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/blocs/auth_bloc.dart';
import 'package:uni_roomie/customtiles/CustomTile.dart';
import 'package:uni_roomie/screens/login/login.dart';
import 'package:uni_roomie/screens/profile/profile.dart';

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
  String profilePhoto;
  String userId;
  TextEditingController nameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController yearOfStudyController = new TextEditingController();
  Map<String, String> universities = Map<String, String>();
  Map<String, String> courses = Map<String, String>();
  List<QueryDocumentSnapshot> courseDocumentSnapshot;
  List<QueryDocumentSnapshot> universityDocumentSnapshots;

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
        userId = fbUser.uid;
        documentReference.snapshots().listen((event) {
          setState(() {
            if (!mounted) return;
            fullName = event.data()["full_name"];
            nameController.text = fullName;
            email = event.data()["email"];
            gender = event.data()["gender"];
            age = event.data()["age"];
            ageController.text = age.toString();
            university = event.data()["university"];
            if (university != null)
              university.get().then((value) => setState(() {
                    universityName = value.id;
                  }));
            else
              universityName == null;
            course = event.data()["course"];
            if (course != null)
              course.get().then((value) => setState(() {
                    courseName = value.id;
                  }));
            else
              courseName = null;
            yearOfStudy = event.data()["yearOfStudy"];
            yearOfStudyController.text = yearOfStudy.toString();
            profilePhoto = event.data()["profilePhoto"];
          });
        });
        FirebaseFirestore.instance
            .collection('courses')
            .orderBy("name")
            .get()
            .then((results) {
          courseDocumentSnapshot = results.docs;
          results.docs.forEach((element) {
            setState(() {
              courses.putIfAbsent(element.id, () => element["name"]);
            });
          });
        });
        FirebaseFirestore.instance
            .collection('universities')
            .orderBy("name")
            .get()
            .then((results) {
          universityDocumentSnapshots = results.docs;
          results.docs.forEach((element) {
            setState(() {
              universities.putIfAbsent(element.id, () => element["name"]);
            });
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> genders = {
      "Female": "Female",
      "Male": "Male",
      "Other": "Other"
    };
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    EditProfileList universityProfile = EditProfileList(
        Icons.school, 'University', universities, universityName);
    EditProfileList courseProfile =
        EditProfileList(Icons.school, 'Course', courses, courseName);
    EditProfileList genderProfile =
        EditProfileList(Icons.person, 'Gender', genders, gender);
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
                    backgroundImage: profilePhoto == null
                        ? AssetImage('assets/avatar4.png')
                        : NetworkImage(profilePhoto),
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
                child: EditProfileTile(Icons.account_box, 'Name',
                    nameController, TextInputType.text),
              ),
              Container(
                child: genderProfile,
              ),
              Container(
                child: EditProfileTile(
                    Icons.grade, 'Age', ageController, TextInputType.number),
              ),
              FittedBox(
                child: Container(
                  child: universityProfile,
                ),
              ),
              FittedBox(
                child: Container(
                  child: courseProfile,
                ),
              ),
              Container(
                child: EditProfileTile(Icons.trending_up, 'Year Of Study',
                    yearOfStudyController, TextInputType.number),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(userId)
                        .update({
                      "age": int.parse(ageController.text),
                      "course": courseDocumentSnapshot
                          .firstWhere((element) =>
                              element.id == courseProfile.selectedValue)
                          .reference,
                      "full_name": nameController.text,
                      "gender": genderProfile.selectedValue,
                      "university": universityDocumentSnapshots
                          .firstWhere((element) =>
                              element.id == universityProfile.selectedValue)
                          .reference,
                      "yearOfStudy": int.parse(yearOfStudyController.text)
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
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
