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
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[Text("Name:", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  Text(widget.projValues.name, style: TextStyle(color: Colors.white),),
                  SizedBox(height: 10,),
                  Text("Description:", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  Text(widget.projValues.description, style: TextStyle(color: Colors.white),),
                  SizedBox(height: 10,),
                  Text("Project History:", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  Text(widget.projValues.updates, style: TextStyle(color: Colors.white),),
                  SizedBox(height: 10,)
                ],
              )
          )
      ),
    );
  }
}