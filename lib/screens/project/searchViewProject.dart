import 'package:flutter/material.dart';
import 'package:sample_flutter_app/screens/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sample_flutter_app/models/models.dart';

class SearchViewProject extends StatefulWidget {
  final Project projValues;

  SearchViewProject({Key key, this.projValues}) : super (key: key);

  @override
  _SearchViewProject createState() => _SearchViewProject();
}

class _SearchViewProject extends State<SearchViewProject> {
  final _formKey = GlobalKey<FormState>();

// text field state
  String projectName = '';
  String description = '';
  String badges = '';
  String updates = '';
  List<dynamic> badgesList = [];
  var bList;
  final List<String> selectedBadges = <String>[];
  final List<String> values = <String>['Communicator', 'Initiative', 'Leadership',
    'Appearance', 'Negotations', 'STEM', 'Law & Public Safety', 'Marketing', 'Human Services',
    'Health Science', 'Government', 'Film, Media, & Entertainment', 'Education', 'Business Management',
    'Architecture & Construction', 'Agriculture, Food, & Resources'];

  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.0,
        title: Text(widget.projValues.name),
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text("Name:", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  Text(widget.projValues.name, style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10),
                  Text("Description:", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  Text(widget.projValues.description, style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center),
                  SizedBox(height: 10),
                  Text("Project History:", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  Text(widget.projValues.updates, style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10),
                  Text("Badges:", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  SizedBox(height: 10),
                  StreamBuilder(
                    //this is poor coding practice, but i could not get the listviewbuilder to work with the
                    //properly formatted badgeslist and blist without using a streambuilder
                    //the streambuilder itself here is not used
                    stream: Firestore.instance.collection("projects").where("uid",
                        isEqualTo: Provider.of<User>(context).uid).snapshots(),
                    builder: (BuildContext  context, AsyncSnapshot<QuerySnapshot> snapshot)
                    {
                      badgesList = widget.projValues.badges;
                      bList = List<String>.from(badgesList);

                      return new Flexible(child: new ListView.builder(
                          shrinkWrap: true,
                          itemCount: badgesList.length,
                          itemBuilder: (context, idx) {
                            if (idx == 0) {
                              if (bList[idx] == 'Unapproved Project') {
                                return Text(bList[idx], style: TextStyle(color: Colors.red,
                                    decoration: TextDecoration.underline),
                                    textAlign: TextAlign.center);
                              }
                              return Text(bList[idx], style: TextStyle(color: Colors.green,
                                  decoration: TextDecoration.underline),
                                  textAlign: TextAlign.center);
                            } else {
                              return Text(bList[idx], style: TextStyle(color: Colors.lightBlueAccent),
                                  textAlign: TextAlign.center);
                            }
                            return Text(bList[idx], style: TextStyle(color: Colors.lightBlueAccent),
                              textAlign: TextAlign.center,);
                          }));

                      return new Text("");
                    },
                  ),
                ],
              )
          )
      ),
    );
  }
}