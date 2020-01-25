import 'package:flutter/material.dart';
import 'package:sample_flutter_app/home/home.dart';

class Wrapper extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {


    //return either home or authenticate widget
    return Home();
  }
}