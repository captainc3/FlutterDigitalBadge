import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_flutter_app/screens/profile/profile.dart';
import 'package:sample_flutter_app/services/auth.dart';
import 'package:sample_flutter_app/screens/project/createNewProject.dart';
import 'package:sample_flutter_app/screens/project/searchProjects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sample_flutter_app/models/models.dart';
import 'package:sample_flutter_app/screens/project/viewProject.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  final AuthService _auth = AuthService();

  bool isCollapsed = true;
  double screenWidth, screenHeight;
  Duration duration = const Duration(milliseconds: 500);
  String badges = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ],
      ),
    );
  }

  getProjects(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => Card(
          color: Colors.black45,
          child: new ListTile(title: new Text(doc["name"], style: TextStyle(fontSize: 12, color: Colors.white),),
          onTap: () {
            Navigator.of(context)
                .push(
                MaterialPageRoute(
                    builder: (context) => ViewProject(projValues : Project(
                      uid: doc["uid"],
                      name: doc["name"],
                      description: doc["description"],
                        updates: doc["updates"],
                        badges: doc["badges"],
                        // NEED TO FIGURE OUT HOW TO MAKE THE BADGES IMPORTABLE FROM FIRESTORE
                    )),
                )
            );
          },
            subtitle: new Text(doc["description"], style: TextStyle(fontSize: 12, color: Colors.white))),
        ))
        .toList();
  }

  Widget menu(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 32,),
            RaisedButton(
              color: Colors.black38,
              child: Text("Profile", style: TextStyle(color: Colors.white, fontSize: 15),),
            onPressed: () {
              Navigator.of(context)
                  .push(
                  MaterialPageRoute(
                      builder: (context) => Profile()
                  )
              );
            },),
            SizedBox(height: 16,),
            RaisedButton(
              color: Colors.black38,
              child: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 15),),
              onPressed: () async{
                await _auth.signOut();
//                Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()),);
              },),
            SizedBox(height: 0,),
          ],
        ),
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: isCollapsed ? 0 : 0 * screenHeight,
      bottom: isCollapsed ? 0 : 0 * screenHeight,
      left: isCollapsed ? 0 : 0.4 * screenWidth,
      right: isCollapsed ? 0 : -0.6 * screenWidth,
      child: Material(
        elevation: 8,
        color: backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                        Icons.menu, color: Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          isCollapsed = !isCollapsed;
                        });
                      },
                    ),
                    Text("Welcome to Digital Badge!", style: TextStyle(fontSize: 20, color: Colors.white),),
                    SizedBox(height: 20, width: 20,)
                  ],
                ),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                            MaterialPageRoute(
                                builder: (context) => SearchProjects()
                            )
                        );
                      },
                      color: Colors.black38,
                      child: Text("Search All Projects", style: TextStyle(fontSize: 12, color: Colors.white),),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => CreateNew()
                          )
                        );
                      },
                      color: Colors.black38,
                      child: Text("Create New Project", style: TextStyle(fontSize: 12, color: Colors.white),)
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Text("Your Projects", style: TextStyle(fontSize: 16, color: Colors.white),),
                StreamBuilder(
                  stream: Firestore.instance.collection('projects').where("uid",
                      isEqualTo: Provider.of<User>(context).uid).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return new Text("There are no projects.");
                      return new ListView(
                        scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: getProjects(snapshot));
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

