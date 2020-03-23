import 'package:flutter/material.dart';
import 'package:sample_flutter_app/screens/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sample_flutter_app/models/models.dart';

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
  String badges = '';
  String updates = '';
  final List<String> selectedBadges = <String>[];
  final List<String> values = <String>['Communicator', 'Initiative', 'Leadership',
    'Appearance', 'Negotations', 'STEM', 'Law & Public Safety', 'Marketing', 'Human Services',
    'Health Science', 'Government', 'Film, Media, & Entertainment', 'Education', 'Business Management',
    'Architecture & Construction', 'Agriculture, Food, & Resources'];

  Widget build(BuildContext context) {

    Future setProjectData(String uid, String name, String description,
        List<String> badges, String updates) async {
      return await Firestore.instance.collection('projects')
          .document(name + ' - ' +  uid)
          .setData({
            'uid': uid,
            'name': name,
            'description': description,
            'badges': badges,
            'updates' : updates,
      });
    }

    void getProjectData(String uid, String name) async {
      Firestore.instance.collection('projects')
          .document(name + ' - ' + uid)
          .get().then((datasnapshot) {
            print(datasnapshot.data['uid'].toString());
      });
    }

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
                children: <Widget>[
                  TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white, width: 2.0),
                        ),
                        labelText: "Name:",
                        hintText: widget.projValues.name,
                        hintStyle: TextStyle(
                            color: Colors.white, fontSize: 12),
                        labelStyle: TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                      maxLines: 1,
                      style: new TextStyle(color: Colors.white, fontSize: 12),
                      onChanged: (val) {
                        projectName = val;
                      }
                  ),
                  SizedBox(height: 10,),
                  TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white, width: 2.0),
                        ),
                        labelText: "Description:",
                        hintText: widget.projValues.description,
                        hintStyle: TextStyle(
                            color: Colors.white, fontSize: 12),
                        labelStyle: TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                      minLines: 1,
                      maxLines: 5,
                      style: new TextStyle(color: Colors.white, fontSize: 12),
                      onChanged: (val) {
                        description = val;
                      }
                  ),
                  SizedBox(height: 10,),
                  TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white, width: 2.0),
                        ),
                        labelText: "Project History:",
                        hintText: widget.projValues.updates,
                        hintStyle: TextStyle(
                            color: Colors.white, fontSize: 12),
                        labelStyle: TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                      minLines: 1,
                      maxLines: 5,
                      style: new TextStyle(color: Colors.white, fontSize: 12),
                      onChanged: (val) {
                        updates = val;
                      }
                  ),
                  SizedBox(height: 10,),
                  DropdownButton<String>(
                    value: selectedBadges.isEmpty ? null : selectedBadges.last,
                    onChanged: (String newValue) {
                      setState(() {
                        if (selectedBadges.contains(newValue))
                          selectedBadges.remove(newValue);
                        else
                          selectedBadges.add(newValue);
                      });
                    },
                    items: values.map<DropdownMenuItem<String>>((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.check,
                              color: selectedBadges.contains(value)
                                  ? null
                                  : Colors.transparent,
                            ),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Please select applicable badges:",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.black26,
                    child: Text(
                      'Complete Edit',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () async {
                      setProjectData(Provider
                          .of<User>(context)
                          .uid, widget.projValues.name, description, selectedBadges, updates);
                      Navigator.of(context).pop();
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