import 'package:flutter/material.dart';
import 'package:sample_flutter_app/screens/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sample_flutter_app/models/models.dart';
import 'package:intl/intl.dart';
import 'package:sample_flutter_app/services/auth.dart';
import 'package:flutter/services.dart';

class CreateNew extends StatefulWidget {
  @override
  _CreateNew createState() => _CreateNew();
}

class _CreateNew extends State<CreateNew> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

// text field state
  String projectName = '';
  String description = '';
  String url = '';
  List<dynamic> badges = [];
  String error = '';
  List<dynamic> uList = [];

  var now = new DateTime.now();

  final List<String> selectedBadges = <String>[];
  final List<String> values = <String>['Communicator', 'Initiative', 'Leadership',
    'Appearance', 'Negotations', 'STEM', 'Law & Public Safety', 'Marketing', 'Human Services',
    'Health Science', 'Government', 'Film, Media, & Entertainment', 'Education', 'Business Management',
    'Architecture & Construction', 'Agriculture, Food, & Resources'];
  Widget build(BuildContext context) {

    Future setProjectData(String uid, String name, String description, String url, List<String> badges, List<dynamic> updates) async {
      return await Firestore.instance.collection('projects').document(name + ' - ' +  uid).setData({
        'uid': uid,
        'name': name,
        'description' : description,
        'imagesURL' : url,
        'badges': badges,
        'updates': updates,
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
                  TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(33),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Project Name',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      validator: (val) => val.isEmpty ? 'Please enter a valid name' : null,
                      style: new TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() => projectName = val);
                      }
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(276),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Project Description',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      validator: (val) => val.isEmpty ? 'Please enter a valid description' : null,
                      style: new TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() => description = val);
                      }
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(276),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'URL for project images:',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      validator: (val) => val.isEmpty ? 'Please enter a valid URL' : null,
                      style: new TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() => url = val);
                      }
                  ),
                  SizedBox(height: 10,),
                  DropdownButton<String>(
                    value: selectedBadges.isEmpty ? null : selectedBadges.last,
                    items: values.map<DropdownMenuItem<String>>((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.check,
                              color: selectedBadges.contains(value) ? null : Colors.transparent,
                            ),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        if (selectedBadges.contains(newValue))
                          selectedBadges.remove(newValue);
                        else
                          selectedBadges.add(newValue);
                      });
                    },

                    hint: Text(
                      "Please select applicable badges:",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.black38,
                    child: Text(
                      'Create New Project',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        selectedBadges.insert(0, "Unapproved Project");
                        setProjectData(Provider.of<User>(context).uid, projectName, description, url, selectedBadges,
                            uList.followedBy([DateFormat("MM-dd-yyyy").format(now) + ": Project created."]).toList());
                        Navigator.of(context).pop();
                      } else setState(() => error = 'Please fill out all fields');
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