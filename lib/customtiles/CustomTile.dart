import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni_roomie/blocs/auth_bloc.dart';
import 'package:uni_roomie/screens/createListing/createListing.dart';

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
          CustomDrawerTile(Icons.person, 'Profile', () => {}),
          CustomDrawerTile(
              Icons.directions,
              'Create a Listing',
              () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => createListingPage()),
                    )
                  }),
          CustomDrawerTile(Icons.star, 'View Listings', () => {}),
          CustomDrawerTile(Icons.list, 'Listing Requests', () => {}),
          CustomDrawerTile(
              Icons.logout, 'Logout', () => {widget.authBloc.logout()}),
        ],
      ),
    );
  }
}
