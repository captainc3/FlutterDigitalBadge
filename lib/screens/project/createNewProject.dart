import 'package:flutter/material.dart';
import 'package:sample_flutter_app/screens/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sample_flutter_app/models/user.dart';

class CreateNew extends StatefulWidget {
  @override
  _CreateNew createState() => _CreateNew();
}

class _CreateNew extends State<CreateNew> {
  final _formKey = GlobalKey<FormState>();

// text field state
  String projectName = '';
  String description = '';
  String badges = '';
  final List<String> selectedValues = <String>[];
  final List<String> values = <String>['One', 'Two', 'Free', 'Four'];

  Widget build(BuildContext context) {

    Future setProjectData(String uid, String name, String description, List<String> badges) async {
      return await Firestore.instance.collection('projects').document(name).setData({
        'uid': uid,
        'name': name,
        'description' : description,
        'badges': badges,
      });
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.0,
        title: Text('Create New Project'),
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
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        labelText: 'Project\'s name:',
                        labelStyle: TextStyle(color: Colors.white, fontSize: 12),
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
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        labelText: 'Brief description about your project:',
                        labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      maxLines: 6,
                      style: new TextStyle(color: Colors.white, fontSize: 12),
                      onChanged: (val) {
                        description = val;
                      }
                  ),
                  SizedBox(height: 10,),
                  DropdownButton<String>(
                    value: selectedValues.isEmpty? null : selectedValues.last,
                    onChanged: (String newValue) {
                      setState(() {
                        if (selectedValues.contains(newValue))
                          selectedValues.remove(newValue);
                        else
                          selectedValues.add(newValue);
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
                              color: selectedValues.contains(value) ? null : Colors.transparent,
                            ),
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
                    color: Colors.black38,
                    child: Text(
                      'Complete Project Creation',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () async {
                      setProjectData(Provider.of<User>(context).uid, projectName, description, selectedValues);
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