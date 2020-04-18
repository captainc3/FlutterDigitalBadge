import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_flutter_app/services/auth.dart';
import 'package:sample_flutter_app/models/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  File _image;
  String _imageUrl;

  final AuthService _auth = AuthService();
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  Duration duration = const Duration(milliseconds: 500);

  String userName = '';
  String userBio = '';
  String userBadges = '';

  List<String> badgesList = <String>[];

//  void initState() {
//    super.initState();
//
//    var ref = FirebaseStorage.instance.ref().child(_imageUrl);
//    ref.getDownloadURL().then((loc) => setState(() => _imageUrl = loc));
//  }

  Future setUserData(String uid, String name, String bio, String badges, String email, String imageURL) async {
    print('profile picture URL: ' + imageURL);

    return await Firestore.instance.collection('profile').document(uid).setData({
      'uid': uid,
      'name': name,
      'bio' : bio,
      'badges' : badges,
      'email' : email,
      'profilePictureURL' : imageURL,
    });
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print('henlo');

    if (this.mounted) {
      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }
  }

  Future uploadImage(BuildContext context) async {
    String fileName = basename(_image.path); // get the file name
    StorageReference storageReference = FirebaseStorage.instance.ref().child(fileName); // get the reference
    StorageUploadTask uploadTask = storageReference.putFile(_image); // put the file in firebase
    await uploadTask.onComplete;

    _imageUrl = await storageReference.getDownloadURL();
    print(_imageUrl);

//    storageReference.getDownloadURL().then((fileURL) {
////      if (this.mounted) {
//        setState(() {
//          _imageUrl = fileURL;
//          print('imageURL $_imageUrl');
//      });
//    });
  }

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
            padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Text('Picture'),
                      Divider(),
                      GridView.count(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.all(30),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 1,
                        children: <Widget>[
                          GestureDetector(
                            onTap: _getImage,
                            child: Container(
                              color: Colors.white70,
//                              child: _image == null ? Text('+') : Image.file(_image, fit: BoxFit.fill),

//                              child: _uploadedFileURL == null ? Text('+')
//                                    : Image.network(_uploadedFileURL, fit: BoxFit.fill),

                                child: _imageUrl == null ? Text('TESTING') : Image.network(_imageUrl, fit: BoxFit.fill),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
//                SizedBox(height: 20, width: 20,),
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
                StreamBuilder(
                  stream: Firestore.instance.collection("profile").where("uid",
                      isEqualTo: Provider.of<User>(context).uid).snapshots(),
                  builder: (BuildContext  context, AsyncSnapshot<QuerySnapshot> snapshot)
                  {
                    if (!snapshot.hasData || snapshot.data?.documents == null) {
                      return new Text("TESTING");
                    } else if (snapshot.data.documents.length > 0) {
                      userBadges = snapshot.data.documents[0].data['badges'];
                      print(userBadges);

                      return new Text(userBadges, style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),);
                    }
                    return new Text("");
                  },
                ),
                SizedBox(height: 100),
                StreamBuilder(
                  stream: Firestore.instance.collection("profile").where("uid",
                      isEqualTo: Provider.of<User>(context).uid).snapshots(),
                  builder: (BuildContext  context, AsyncSnapshot<QuerySnapshot> snapshot)
                  {
                    if (!snapshot.hasData || snapshot.data?.documents == null) {
                      return new Text("TESTING");
                    } else if (snapshot.data.documents.length > 0) {
                      userBadges = snapshot.data.documents[0].data['badges'];
                      print(userBadges);

                      return new RaisedButton(
                        onPressed: () async {
                          uploadImage(context);
                          setUserData(Provider.of<User>(context).uid, userName, userBio, userBadges, Provider.of<User>(context).email, _imageUrl);
                          Navigator.of(context).pop();
                        },
                        color: Colors.black26,
                        child: Text(
                          'Submit Changes',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      );
                    }
                    return new Text("");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}