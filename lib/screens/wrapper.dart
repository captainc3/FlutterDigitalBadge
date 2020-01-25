import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_flutter_app/screens/home/home.dart';
import 'package:sample_flutter_app/screens/authenticate/authenticate.dart';
import 'package:sample_flutter_app/models/user.dart';

class Wrapper extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    //return either screens.home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}