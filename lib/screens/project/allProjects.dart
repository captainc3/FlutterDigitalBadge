import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_flutter_app/screens/profile/profile.dart';
import 'package:sample_flutter_app/services/auth.dart';
import 'package:sample_flutter_app/screens/project/createNewProject.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sample_flutter_app/models/models.dart';
import 'package:sample_flutter_app/screens/project/viewProject.dart';

class AllProjects extends StatefulWidget {
  @override
  _AllProjects createState() => _AllProjects();
}

class _AllProjects extends State<AllProjects> {
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0.0,
          title: Text('Search All Projects'),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          children: <Widget>[
            ListTile(
              title: Text('Test Project 1'),
            ),
            ListTile(
              title: Text('Test Project 2'),
            ),
            ListTile(
              title: Text('Test Project 3'),
            ),
          ],
        ),
    );
  }
}























