import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/blocs/auth_bloc.dart';
import 'package:uni_roomie/customtiles/CustomTile.dart';
import 'package:uni_roomie/screens/login/login.dart';

class viewOtherProfilePage extends StatefulWidget {
  String userId;

  viewOtherProfilePage(this.userId);

  @override
  _viewOtherProfilePageState createState() => _viewOtherProfilePageState(userId);
}

class _viewOtherProfilePageState extends State<viewOtherProfilePage> {
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
  String userId;
  String profilePhoto;

  File _image;

  _viewOtherProfilePageState(this.userId);

  final picker = ImagePicker();

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

      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('users').doc(userId);
      documentReference.snapshots().listen((event) {
        setState(() {
          if (!mounted) return;
          fullName = event.data()["full_name"];
          email = event.data()["email"];
          gender = event.data()["gender"];
          age = event.data()["age"];
          university = event.data()["university"];
          if (university != null)
            university.get().then((value) => setState(() {
                  universityName = value.data()["name"];
                }));
          course = event.data()["course"];
          if (course != null)
            course.get().then((value) => setState(() {
                  courseName = value.data()["name"];
                }));
          yearOfStudy = event.data()["yearOfStudy"];
          profilePhoto = event.data()["profilePhoto"];
          print(profilePhoto);
        });
      });
    });
    super.initState();
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        UploadTask uploadTask = FirebaseStorage.instance
            .ref('profilePhotos/$userId.png')
            .putFile(_image);
        uploadTask.then((snapshot) => {
              snapshot.ref.getDownloadURL().then((value) => {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(userId)
                        .update({"profilePhoto": value})
                  })
            });
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);

    return Scaffold(
      drawer: CustomDrawer(authBloc),
      appBar: AppBar(
        title: Text('${fullName}s Profile'),
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
        SizedBox(height: 20.0),
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
                child: CustomProfileTile(Icons.account_box, 'Name',
                    fullName == null ? "N/A" : fullName),
              ),
              Container(
                child: CustomProfileTile(Icons.alternate_email, 'Email',
                    email == null ? "N/A" : email),
              ),
              Container(
                child: CustomProfileTile(
                    Icons.person, 'Gender', gender == null ? "N/A" : gender),
              ),
              Container(
                child: CustomProfileTile(
                    Icons.grade, 'Age', age == null ? "N/A" : age.toString()),
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
                child: CustomProfileTile(Icons.trending_up, 'Year Of Study',
                    yearOfStudy == null ? "N/A" : yearOfStudy.toString()),
              ),
              Container(),
            ],
          ),
        ),
      ])),
    );
  }
}
