import 'package:flutter/material.dart';
import 'package:sample_flutter_app/screens/profile/profile.dart';
import 'package:sample_flutter_app/services/auth.dart';
import 'package:sample_flutter_app/screens/project/createNewProject.dart';

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
              child: Text("Profile", style: TextStyle(color: Colors.white, fontSize: 15),),
            onPressed: () {
              Navigator.of(context)
                  .push(
                  MaterialPageRoute(
                      builder: (context) => ProfilePage()
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
                ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Home Park Community Cleanup", style: TextStyle(fontSize: 12, color: Colors.white),),
                        subtitle: Text("State Street", style: TextStyle(fontSize: 12, color: Colors.white),),
                        trailing: Text("scorrales3", style: TextStyle(fontSize: 12, color: Colors.white),)
                      );
                    }, separatorBuilder: (context, index) {
                  return Divider(height: 16,);
                }, itemCount: 1)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

