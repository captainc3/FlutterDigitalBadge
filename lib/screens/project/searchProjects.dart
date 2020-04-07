import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_flutter_app/screens/profile/profile.dart';
import 'package:sample_flutter_app/services/auth.dart';
import 'package:sample_flutter_app/screens/project/createNewProject.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sample_flutter_app/models/models.dart';
import 'package:sample_flutter_app/screens/project/viewProject.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}


class SearchProjects extends StatefulWidget {
  @override
  _SearchProjects createState() => _SearchProjects();
}

class _SearchProjects extends State<SearchProjects> {
  Future<List<Post>> search(String search) async {
    List<DocumentSnapshot> documentList = (await Firestore.instance
        .collection("projects")
        .getDocuments()).
    documents;
    await Future.delayed(Duration(seconds: 2));
    List<Post> posts = [];
    for (int i = 0; i < documentList.length; i++) {
      String pName = documentList[i].data.values.toList()[2];
      String pDes = documentList[i].data.values.toList()[3];
      if (pName.toUpperCase().contains(search.toUpperCase())) {
          posts.add(Post("Project Name: " + pName, "Project Desription: " + pDes));
      }
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Post>(
            minimumChars: 1,
            hintText: "Project Name",
            onSearch: search,
            onItemFound: (Post post, int index) {
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.description),
              );
            },
          ),
        ),
      ),
    );
  }
}



















