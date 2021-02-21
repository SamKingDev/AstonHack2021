import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uni_roomie/blocs/AuthBloc.dart';
import 'package:uni_roomie/customtiles/CustomTile.dart';
import 'package:uni_roomie/screens/login/LoginPage.dart';

import 'file:///C:/Users/Joe/AndroidStudioProjects/AstonHack2021/lib/models/ListingRecord.dart';

//Divider - > Container(height: 100, child: Divider(color: Colors.black))

class CreateListingPage extends StatefulWidget {
  TextEditingController titleCont = new TextEditingController();
  TextEditingController priceCont = new TextEditingController();
  TextEditingController totalRoomsCont = new TextEditingController();
  TextEditingController freeRoomsCont = new TextEditingController();
  LocationResult result;

  @override
  _CreateListingPageState createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  StreamSubscription<User> loginStateSubscription;
  DocumentReference userReference;

  bool _hasBeenPressed = false;

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
        FirebaseFirestore.instance
            .collection("users")
            .doc(fbUser.uid)
            .get()
            .then((value) => setState(() {
                  userReference = value.reference;
                }));
      }
    });
    super.initState();
  }

  String genderSelectedValue = 'Female';
  List<File> images = new List<File>();

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    return Scaffold(
      drawer: CustomDrawer(authBloc),
      appBar: AppBar(
          title: Text('Create Listing'),
          backgroundColor: new Color.fromRGBO(69, 93, 122, 1),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/logo.png'),
                    radius: 40.0,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: new Color.fromRGBO(217, 217, 217, 1),
                      // set border width
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      // set rounded corner radius
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.black,
                            offset: Offset(1, 3))
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textContainer(
                          'Title...', 'Listing Title', widget.titleCont),
                      SizedBox(height: 50),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        child: Column(
                          children: [
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)),
                              onPressed: () async {
                                widget.result = await showLocationPicker(
                                    context,
                                    "AIzaSyDY6RwTm0Dhr7YMs_jLi6B8fwqhTyCqzJw");
                                if (widget.result != null) {
                                  setState(() {
                                    _hasBeenPressed = !_hasBeenPressed;
                                  });
                                }
                              },
                              color: _hasBeenPressed
                                  ? Colors.green
                                  : new Color.fromRGBO(249, 89, 89, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _hasBeenPressed
                                          ? 'Edit Selected Location'
                                          : 'Find Location On Map',
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.map,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Visibility(
                                  child: Text(
                                    "Location Set",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: _hasBeenPressed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      numberContainer(
                          'Price...', 'Price Per Week', widget.priceCont),
                      SizedBox(
                        height: 50,
                      ),
                      numberContainer('Number...', 'Total Rooms In Property',
                          widget.totalRoomsCont),
                      SizedBox(
                        height: 50,
                      ),
                      numberContainer(
                          'Rooms...', 'Rooms Available', widget.freeRoomsCont),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Gender Preference",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            DropdownButton<String>(
                              value: genderSelectedValue,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black),
                              underline:
                                  Container(height: 2, color: Colors.black),
                              onChanged: (String newValue) {
                                setState(() {
                                  genderSelectedValue = newValue;
                                });
                              },
                              items: <String>[
                                "Female",
                                "Male",
                                "Other",
                                "NoPreference"
                              ].map<DropdownMenuItem<String>>((e) {
                                return DropdownMenuItem<String>(
                                    value: e, child: Text(e));
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Images(images)],
                      )),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            color: new Color.fromRGBO(249, 89, 89, 1),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Create Listing',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              Future<List<String>> uploadImages() async {
                                List<String> imageURLS = new List<String>();
                                await Future.forEach(images, (f) async {
                                  TaskSnapshot uploadTask = await FirebaseStorage
                                      .instance
                                      .ref(
                                          'listing/${DateTime.now().toIso8601String()}.png')
                                      .putFile(f);
                                  imageURLS.add(
                                      await uploadTask.ref.getDownloadURL());
                                });
                                return imageURLS;
                              }

                              void insertRow() async {
                                ListingRecord listing = new ListingRecord(
                                    widget.titleCont.text,
                                    new GeoPoint(widget.result.latLng.latitude,
                                        widget.result.latLng.longitude),
                                    double.parse(widget.priceCont.text),
                                    int.parse(widget.totalRoomsCont.text),
                                    int.parse(widget.freeRoomsCont.text),
                                    Gender.values.firstWhere(
                                        (element) =>
                                            element.toString() ==
                                            "Gender." + genderSelectedValue,
                                        orElse: () => null),
                                    await uploadImages(),
                                    userReference);
                                FirebaseFirestore.instance
                                    .collection("listings")
                                    .add(listing.toFirebase());
                              }

                              insertRow();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class Images extends StatefulWidget {
  List<File> images = new List<File>();

  Images(this.images);

  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    Future getImage(ImageSource source) async {
      final pickedFile = await picker.getImage(source: source);

      setState(() {
        if (pickedFile != null) {
          widget.images.add(File(pickedFile.path));
        } else {
          print('No image selected.');
        }
      });
    }

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
    List<Widget> imgs = new List<Widget>();
    imgs.add(
      Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          child: Column(
            children: [
              Text('Add Photo'),
              Center(
                child: IconButton(
                  icon: CircleAvatar(
                    backgroundImage: AssetImage('assets/empty_photo.png'),
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    widget.images.forEach((img) {
      imgs.add(Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image(image: AssetImage(img.path)),
        ),
        height: 300,
      ));
    });
    return Column(children: imgs);
  }
}

class textContainer extends StatefulWidget {
  @override
  String hiddenText;
  String title;
  TextEditingController cont;

  textContainer(this.hiddenText, this.title, this.cont);

  _textContainerState createState() => _textContainerState();
}

class _textContainerState extends State<textContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextField(
        controller: widget.cont,
        decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey[600]),
            enabledBorder: new UnderlineInputBorder(),
            focusedBorder: new UnderlineInputBorder(
              borderSide: BorderSide(
                color: new Color.fromRGBO(249, 89, 89, 1),
              ),
            ),
            labelText: widget.hiddenText,
            labelStyle: TextStyle(fontSize: 12.0)),
        keyboardType: TextInputType.multiline,
        maxLines: null,
      )
    ]));
  }
}

class numberContainer extends StatefulWidget {
  @override
  String hiddenText;
  String title;
  TextEditingController cont;

  numberContainer(this.hiddenText, this.title, this.cont);

  _numberContainerState createState() => _numberContainerState();
}

class _numberContainerState extends State<numberContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextField(
        controller: widget.cont,
        decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey[600]),
            enabledBorder: new UnderlineInputBorder(),
            focusedBorder: new UnderlineInputBorder(
              borderSide: BorderSide(
                color: new Color.fromRGBO(249, 89, 89, 1),
              ),
            ),
            labelText: widget.hiddenText,
            labelStyle: TextStyle(fontSize: 12.0)),
        keyboardType: TextInputType.number,
        maxLines: null,
      ),
    ]));
  }
}
