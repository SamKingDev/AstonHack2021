import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_roomie/blocs/auth_bloc.dart';
import 'package:uni_roomie/screens/createListing/createListing.dart';
import 'package:uni_roomie/screens/login/login.dart';
import 'package:uni_roomie/screens/profile/profile.dart';
import 'package:uni_roomie/screens/searchListing/viewListing.dart';
import 'package:uni_roomie/screens/viewListings/viewListings.dart';

class CustomDrawerTile extends StatefulWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomDrawerTile(this.icon, this.text, this.onTap);

  @override
  _CustomDrawerTile createState() => _CustomDrawerTile();
}

class _CustomDrawerTile extends State<CustomDrawerTile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: new Color.fromRGBO(249, 89, 89, 1),
        ))),
        child: InkWell(
          splashColor: new Color.fromRGBO(249, 89, 89, 0.8),
          onTap: widget.onTap,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, //x axis
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(widget.icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.text,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    )
                  ],
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  AuthBloc authBloc;

  CustomDrawer(this.authBloc);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
              new Color.fromRGBO(180, 190, 201, 1),
              new Color.fromRGBO(69, 93, 122, 1)
            ])),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Material(
                    elevation: 20,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/logo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomDrawerTile(Icons.person, 'Profile', () => {Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          )}),
          CustomDrawerTile(Icons.add, 'Create a Listing', () => {Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => createListingPage()),
          )}),
          CustomDrawerTile(Icons.house, 'View Listings', () => {Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => viewListingPage()),
          )}),
          CustomDrawerTile(Icons.list, 'Listing Requests', () => {Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          )}),
          CustomDrawerTile(Icons.logout, 'Logout', () => {widget.authBloc.logout()}),
        ],
      ),
    );
  }
}


class CustomProfileTile extends StatefulWidget {
  IconData icon;
  String text;
  String content;

  CustomProfileTile(this.icon, this.text, this.content);

  @override
  _CustomProfileTile createState() => _CustomProfileTile();
}

class _CustomProfileTile extends State<CustomProfileTile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom:
                BorderSide(color: Colors.grey[800]))),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //x axis
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(widget.icon),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.text,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              Text(widget.content),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileTile extends StatefulWidget {
  @override
  IconData icon;
  String text;

  EditProfileTile(this.icon, this.text);

  _EditProfileTileState createState() => _EditProfileTileState();
}

class _EditProfileTileState extends State<EditProfileTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Row(
            children: <Widget>[
              Icon(widget.icon),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.text,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
          new Flexible(
            child: TextFormField(
              cursorColor: new Color.fromRGBO(249, 89, 89, 1),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: new UnderlineInputBorder(),
                focusedBorder: new UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: new Color.fromRGBO(249, 89, 89, 1),
                  ),
                ),
              ),
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              //controller:
            ),
          ),
        ],
      ),
    );
  }
}


class EditProfileList extends StatefulWidget {
  @override
  IconData icon;
  String text;
  List<String> genders = new List<String>();
  List<String> universities = new List<String>();
  List<String> courses = new List<String>();


  EditProfileList(this.icon, this.text);

  _EditProfileListState createState() => _EditProfileListState();
}

class _EditProfileListState extends State<EditProfileList> {
  String genderSelectedValue = 'Female';
  String universitySelectedValue = 'Southampton Solent';
  String coursesSelectedValue = 'Software Engineering';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: <Widget>[
              Icon(widget.icon),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.text,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
          DropdownButton<String>(
            value: genderSelectedValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(height: 2, color: Colors.black),
            onChanged: (String newValue) {
              setState(() {
                genderSelectedValue = newValue;
              });
            },
            items: <String>["Female", "Male"]
                .map<DropdownMenuItem<String>>((e) {
              return DropdownMenuItem<String>(
                  value: e, child: Text(e));
            }).toList(),
          ),
        ],
      ),
    );
  }
}
