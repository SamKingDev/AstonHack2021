import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/blocs/auth_bloc.dart';
import 'package:uni_roomie/customtiles/CustomTile.dart';
import 'package:uni_roomie/screens/login/login.dart';
import 'package:uni_roomie/screens/profile/editProfile.dart';

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
  String userId;
  String profilePhoto;

  File _image;
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
      } else {
        userId = fbUser.uid;
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
            if (university != null ) university.get().then((value) => setState(() {
                  universityName = value.data()["name"];
                }));
            course = event.data()["course"];
            if (course != null ) course.get().then((value) => setState(() {
                  courseName = value.data()["name"];
                }));
            yearOfStudy = event.data()["yearOfStudy"];
            profilePhoto = event.data()["profilePhoto"];
            print(profilePhoto);
          });
        });
      }
    });
    super.initState();
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        UploadTask uploadTask =
            FirebaseStorage.instance.ref('profilePhotos/$userId.png').putFile(_image);
        uploadTask.then((snapshot) => {
              snapshot.ref
                  .getDownloadURL()
                  .then((value) => {
                    FirebaseFirestore.instance.collection("users").doc(userId).update({"profilePhoto": value})
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
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget cameraButton = FlatButton(
      child: Text("Camera"),
      onPressed: () {
        Navigator.of(context).pop();
        getImage(ImageSource.camera);
      },
    );
    Widget galleryButton = FlatButton(
      child: Text("Gallery"),
      onPressed: () {
        Navigator.of(context).pop();
        getImage(ImageSource.gallery);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Photo Location"),
      content: Text("Where do you want to select your new profile photo from?"),
      actions: [cancelButton, galleryButton, cameraButton],
    );
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
                    backgroundImage: profilePhoto == null
                        ? AssetImage('assets/avatar4.png')
                        : NetworkImage(profilePhoto),
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
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    ),
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
              FittedBox(
                child: Container(
                  child: CustomProfileTile(Icons.school, 'University',
                      universityName == null ? "N/A" : universityName),
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  child: CustomProfileTile(Icons.bookmark, 'Course',
                      courseName == null ? "N/A" : courseName),
                ),
              ),
              Container(
                child: CustomProfileTile(Icons.trending_up, 'Year Of Study',
                    yearOfStudy == null ? "N/A" : yearOfStudy.toString()),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );},
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
                        SizedBox(width: 10),
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
