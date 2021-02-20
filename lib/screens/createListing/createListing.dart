import 'package:flutter/material.dart';

//Divider - > Container(height: 100, child: Divider(color: Colors.black))

class createListingPage extends StatefulWidget {
  @override
  _createListingPageState createState() => _createListingPageState();
}

class _createListingPageState extends State<createListingPage> {
  String genderSelectedValue = 'Female';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Create Listing'),
          backgroundColor: new Color.fromRGBO(69, 93, 122, 1),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              margin: EdgeInsets.fromLTRB(10,10,10,10),
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: new Color.fromRGBO(217, 217, 217, 1),
                  // set border width
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  // set rounded corner radius
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10, color: Colors.black, offset: Offset(1, 3))
                  ]),
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textContainer('Title...', 'Listing Title'),
              SizedBox(height: 50),
              Container(
                  //Address
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text("Address",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),),
                    TextField(
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          enabledBorder: new UnderlineInputBorder(),
                          focusedBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: new Color.fromRGBO(249, 89, 89, 1),
                            ),
                          ),
                          labelText: 'Address Line 1...',
                          labelStyle: TextStyle(fontSize: 12.0)),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      cursorColor: new Color.fromRGBO(249, 89, 89, 1),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          enabledBorder: new UnderlineInputBorder(),
                          focusedBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: new Color.fromRGBO(249, 89, 89, 1),
                            ),
                          ),
                          labelText: 'Address Line 2...',
                          labelStyle: TextStyle(fontSize: 12.0)),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          enabledBorder: new UnderlineInputBorder(),
                          focusedBorder: new UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: new Color.fromRGBO(249, 89, 89, 1),
                            ),
                          ),
                          labelText: 'Address Line 3...',
                          labelStyle: TextStyle(fontSize: 12.0)),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ])),
              SizedBox(
                height: 50,
              ),
              numberContainer('Price...', 'Price Per Week'),
              SizedBox(
                height: 50,
              ),
              numberContainer('Number...', 'Total Rooms In Property'),
              SizedBox(
                height: 50,
              ),
              numberContainer('Rooms...', 'Rooms Available'),
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
                      underline: Container(height: 2, color: Colors.black),
                      onChanged: (String newValue) {
                        setState(() {
                          genderSelectedValue = newValue;
                        });
                      },
                      items: <String>["Female", "Male", "Other", "No Preference"]
                          .map<DropdownMenuItem<String>>((e) {
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
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Container(
                          child: Center(
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/empty_photo.png'),
                              radius: 30.0,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: TextButton(
                              onPressed: () => showDialog(),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Photo',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Container(
                          child: Center(
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/empty_photo.png'),
                              radius: 30.0,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: TextButton(
                              onPressed: () => showDialog(),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Photo',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Container(
                          child: Center(
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/empty_photo.png'),
                              radius: 30.0,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: TextButton(
                              onPressed: () => showDialog(),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Photo',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    onPressed: () {},
                    color: new Color.fromRGBO(249, 89, 89, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Create Listing',
                        style: TextStyle(fontSize: 20.0,
                        color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          )),
        ),
      ),
    );
  }
}

class textContainer extends StatefulWidget {
  @override
  String hiddenText;
  String title;

  textContainer(this.hiddenText, this.title);

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

  numberContainer(this.hiddenText, this.title);

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
