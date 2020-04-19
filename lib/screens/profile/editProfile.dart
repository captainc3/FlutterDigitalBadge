import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_flutter_app/models/models.dart';
import 'package:flutter/services.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class EditProfile extends StatefulWidget {
  final User userValues;

  EditProfile({Key key, this.userValues}) : super (key: key);

  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  String userName = '';
  String userBio = '';
  String error = '';
  List<dynamic> badgesList = [];
  var bList;

  @override
  Widget build(BuildContext context) {

    Future setUserData(String uid, String name, String bio, List<dynamic> badges, String email) async {
      return await Firestore.instance.collection('profile').document(uid).setData({
        'uid': uid,
        'name': name,
        'bio' : bio,
        'badges' : badges,
        'email' : email,
      });
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.0,
        title: Text("Edit Profile"),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text("Please fill out all fields!", style: TextStyle(color: Colors.redAccent, fontSize: 15.0)),
                  TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(18),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Updated Name:',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      validator: (val) => val.isEmpty ? 'Please enter a valid name' : null,
                      style: new TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() => userName = val);
                      }
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(276),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Updated Bio:',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      validator: (val) => val.isEmpty ? 'Please enter a valid bio' : null,
                      style: new TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() => userBio = val);

                      }
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
                        badgesList = snapshot.data.documents[0].data['badges'];
                        bList = List<String>.from(badgesList);

                        return new RaisedButton(
                          color: Colors.black26,
                          child: Text(
                            'Submit Changes',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setUserData(Provider
                                  .of<User>(context)
                                  .uid, userName, userBio, bList, Provider
                                  .of<User>(context)
                                  .email);
                              Navigator.of(context).pop();
                            } else setState(() => error = 'Please fill out all fields');
                          }

                        );
                      }
                      return new Text("");
                    },
                  ),
                  SizedBox(height: 10,)
                ],
              )
          )
      ),
    );
  }
}