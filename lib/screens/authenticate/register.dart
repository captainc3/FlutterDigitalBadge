import 'package:flutter/material.dart';
import 'package:sample_flutter_app/services/auth.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.0,
        title: Text('Register for Digital Badge'),
          actions: <Widget>[
            FlatButton.icon(
                textColor: Colors.white,
                onPressed: () {
                  widget.toggleView();
                },

                icon: Icon(Icons.person),
                label: Text('Sign In')
            )
          ]
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
              child: Column(
                children: <Widget>[
                  Image(image: AssetImage('assets/skills.png'),),
                  SizedBox(height: 20.0),
                  TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (val) => val.isEmpty ? 'Please enter a valid name' : null,
                      style: new TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() => name = val);
                      }
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      style: new TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() => email = val);
                      }
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      obscureText: true,
                      validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                      style: new TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() => password = val);
                      }
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.black38,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = await _auth
                            .registerWithEmailAndPassword(email, password, name);
                        if (result == null) {
                          setState(() => error = 'Please use valid email');
                        }
                      }
                    },
                  ),
                  SizedBox(height: 12.0,),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              )
          )
      ),
    );
  }
}
