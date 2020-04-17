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
  String badges = "";

  bool isCollapsed = true;
  double screenWidth, screenHeight;
  Duration duration = const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.0,
        title: Text('Profile Page'),
      ),
      body: Stack(
        children: <Widget>[
          dashboard(context),
        ],
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
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
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

                        return new Text("Hi, " + name + "!", style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),);
                    }
                    return new Text("");
                  },
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Bio:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ),
                SizedBox(height: 20,),
                StreamBuilder(
                  stream: Firestore.instance.collection("profile").where("uid",
                      isEqualTo: Provider.of<User>(context).uid).snapshots(),
                  builder: (BuildContext  context, AsyncSnapshot<QuerySnapshot> snapshot)
                  {
                    if (!snapshot.hasData || snapshot.data?.documents == null) {
                      return new Text("TESTING");
                    } else if (snapshot.data.documents.length > 0) {
                      bio = snapshot.data.documents[0].data['bio'];
                      print(bio);

                      return new Text(bio, style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),);
                    }
                    return new Text("");
                  },
                ),
                SizedBox(height: 20,),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Badges Acquired:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ),
                SizedBox(height: 20,),
                StreamBuilder(
                  stream: Firestore.instance.collection("profile").where("uid",
                      isEqualTo: Provider.of<User>(context).uid).snapshots(),
                  builder: (BuildContext  context, AsyncSnapshot<QuerySnapshot> snapshot)
                  {
                    if (!snapshot.hasData || snapshot.data?.documents == null) {
                      return new Text("TESTING");
                    } else if (snapshot.data.documents.length > 0) {
                      badges = snapshot.data.documents[0].data['badges'];
                      print(badges);

                      return new Text(badges, style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),);
                    }
                    return new Text("");
                  },
                ),
                SizedBox(height: 100, ),
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
            ),
          ),
        ),
      ),
    );
  }
}
