import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_flutter_app/screens/home/home.dart';
import 'package:sample_flutter_app/services/auth.dart';
import 'package:sample_flutter_app/models/models.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {

  final AuthService _auth = AuthService();
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  Duration duration = const Duration(milliseconds: 500);

  String userName = '';
  String userBio = '';
  String userBadges = '';

  List<String> badgesList = <String>[];

  Future setUserData(String uid, String name, String bio) async {
    return await Firestore.instance.collection('profile').document(uid).setData({
      'uid': uid,
      'name': name,
      'bio' : bio,
    });
  }

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
              child: Text("Home", style: TextStyle(color: Colors.white, fontSize: 15),),
              onPressed: () {
                Navigator.of(context)
                    .pop();
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
                    SizedBox(height: 20, width: 20,)
                  ],
                ),
                TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      labelText: 'Name: ',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    style: new TextStyle(color: Colors.white, fontSize: 12),
                    onChanged: (val) {
                      userName = val;
                    }
                ),
                SizedBox(height: 20, width: 20,),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Bio:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ),
                SizedBox(height: 20,),
                TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      labelText: 'Bio: ',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    style: new TextStyle(color: Colors.white, fontSize: 12),
                    onChanged: (val) {
                      userBio = val;
                    }
                ),
                SizedBox(height: 20,),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Badges Acquired:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(
                      color: Colors.white30,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text("display user badges", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),),
                ),
                SizedBox(height: 100),
                RaisedButton(
                  onPressed: () async {
                    setUserData(Provider.of<User>(context).uid, userName, userBio);
                    Navigator.of(context).pop();
                  },
                  color: Colors.black26,
                  child: Text(
                    'Submit Changes',
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