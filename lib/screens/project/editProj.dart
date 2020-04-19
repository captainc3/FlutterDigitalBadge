import 'package:flutter/material.dart';
import 'package:sample_flutter_app/screens/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sample_flutter_app/models/models.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class EditProj extends StatefulWidget {
  final Project projValues;

  EditProj({Key key, this.projValues}) : super (key: key);

  @override
  _EditProj createState() => _EditProj();
}

class _EditProj extends State<EditProj> {
  final _formKey = GlobalKey<FormState>();

// text field state
  String projectName = '';
  String description = '';
  String newUpdate = '';
  String error = '';
  String url = '';
  List<dynamic> uList = [];
  List<dynamic> temp = [];
  var now = new DateTime.now();


  Widget build(BuildContext context) {

    Future setProjectData(String uid, String name, String description, String imagesURL, List<dynamic> badges, List<dynamic> updates) async {
      return await Firestore.instance.collection('projects')
          .document(name + ' - ' +  uid)
          .setData({
        'uid': uid,
        'name': name,
        'description': description,
        'imagesURL': imagesURL,
        'badges': badges,
        'updates' : updates,
      });
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.0,
        title: Text("Edit Project: " + widget.projValues.name),
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
                        new LengthLimitingTextInputFormatter(276),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'New Project Description',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      validator: (val) => val.isEmpty ? 'Please enter a valid name:' : null,
                      style: new TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() => description = val);
                      }
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Project update (Date is automatically added):',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      validator: (val) => val.isEmpty ? 'Please enter an update' : null,
                      style: new TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() => newUpdate = DateFormat("MM-dd-yyyy").format(now) + ": " + val);

                      }
                  ),
                  SizedBox(height: 20,),
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
                  SizedBox(height: 20),
                  RaisedButton(
                    color: Colors.black26,
                    child: Text(
                      'Complete Edit',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        uList = widget.projValues.updates;
                        setProjectData(Provider
                            .of<User>(context)
                            .uid, widget.projValues.name, description, url, widget.projValues.badges, uList.followedBy([newUpdate]).toList());
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