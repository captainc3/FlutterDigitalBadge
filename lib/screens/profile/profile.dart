import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_flutter_app/services/auth.dart';
import 'package:sample_flutter_app/screens/profile/editProfile.dart';
import 'package:sample_flutter_app/models/models.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {

  final AuthService _auth = AuthService();
  String bio = "";
  String name = "";
  List<dynamic> badgesList = [];
  var bList;

  bool isCollapsed = true;
  double screenWidth, screenHeight;
  Duration duration = const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.0,
        title: Text("Profile Page"),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Form(
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                    stream: Firestore.instance.collection("profile").where("uid",
                        isEqualTo: Provider.of<User>(context).uid).snapshots(),
                    builder: (BuildContext  context, AsyncSnapshot<QuerySnapshot> snapshot)
                    {
                      if (!snapshot.hasData || snapshot.data?.documents == null) {
                        return new Text("TESTING");
                      } else if (snapshot.data.documents.length > 0) {
                        name = snapshot.data.documents[0].data['name'];
                        print(name);

                        return new Text("Hello, " + name + "!", style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),);
                      }
                      return new Text("");
                    },
                  ),
                  SizedBox(height: 20),
                  Text("Bio:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)),
                  SizedBox(height: 3),
                  StreamBuilder(
                    stream: Firestore.instance.collection("profile").where("uid",
                        isEqualTo: Provider.of<User>(context).uid).snapshots(),
                    builder: (BuildContext  context, AsyncSnapshot<QuerySnapshot> snapshot)
                    {
                      if (!snapshot.hasData || snapshot.data?.documents == null) {
                        return new Text("TESTING");
                      } else if (snapshot.data.documents.length > 0) {
                        bio = snapshot.data.documents[0].data['bio'];
                        print(name);

                        return new Text(bio, style:
                        TextStyle(fontSize: 16, color: Colors.white),);
                      }
                      return new Text("");
                    },
                  ),
                  SizedBox(height: 20),
                  Text("Badges:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)),
                  SizedBox(height: 5),
                  StreamBuilder(
                    //this is poor coding practice, but i could not get the listviewbuilder to work with the
                    //properly formatted badgeslist and blist without using a streambuilder
                    //the streambuilder itself here is not used
                    stream: Firestore.instance.collection("profile").where("uid",
                        isEqualTo: Provider.of<User>(context).uid).snapshots(),
                    builder: (BuildContext  context, AsyncSnapshot<QuerySnapshot> snapshot)
                    {
                      badgesList = snapshot.data.documents[0].data['badges'];
                      bList = List<String>.from(badgesList);

                      return new Flexible(child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: badgesList.length,
                          itemBuilder: (context, idx) {
                            return Text(bList[idx], style: TextStyle(color: Colors.lightBlueAccent),
                                textAlign: TextAlign.center);
                          }));
                    },
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                          MaterialPageRoute(
                              builder: (context) => EditProfile()
                          )
                      );
                    },
                    color: Colors.black26,
                    child: Text(
                      'Edit Info',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              )
          )
      ),
    );
  }
}