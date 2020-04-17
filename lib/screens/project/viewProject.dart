import 'package:flutter/material.dart';
import 'package:sample_flutter_app/screens/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sample_flutter_app/models/models.dart';
import 'package:sample_flutter_app/screens/project/editProj.dart';

class ViewProject extends StatefulWidget {
  final Project projValues;

  ViewProject({Key key, this.projValues}) : super (key: key);

  @override
  _ViewProject createState() => _ViewProject();
}

class _ViewProject extends State<ViewProject> {
  final _formKey = GlobalKey<FormState>();

// text field state
  String projectName = '';
  String description = '';
  List<dynamic> badgesList = [];
  var bList;
  String updates = '';
  var textController = TextEditingController();
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
                  RaisedButton(
                    color: Colors.black26,
                    child: Text(
                      'Edit Project',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .push(
                          MaterialPageRoute(
                            builder: (context) => EditProj(projValues : Project(
                                uid: Provider.of<User>(context).uid,
                                name: widget.projValues.name,
                                description: widget.projValues.description,
                                updates: widget.projValues.updates,
                                badges: widget.projValues.badges,
                            )),
                          )
                      );
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