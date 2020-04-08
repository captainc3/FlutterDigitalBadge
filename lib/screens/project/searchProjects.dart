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
  final String uid;
  final String updates;

  Post(this.title, this.description, this.uid, this.updates);
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
    int j = 0;
    for (int i = 0; i < documentList.length; i++) {
      String pName = documentList[i].data['name'];
      String pDes = documentList[i].data['description'];
      String pUid = documentList[i].data['uid'];
      String pUpd = documentList[i].data['updates'];

      if (pName.toUpperCase().contains(search.toUpperCase())) {
          posts.add(Post("Project Name: " + pName, "Project Desription: " + pDes, pUid, pUpd));
      }
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4A4A58),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Post>(
            minimumChars: 1,
            hintText: "Project Name",
            iconActiveColor: Colors.red,
            onSearch: search,
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            onItemFound: (Post post, int index) {
              return ListTile(
                title: Text(post.title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                subtitle: Text(post.description, style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewProject(projValues : Project(
                      uid: post.uid,
                      name: post.title,
                      description: post.description,
                      updates: post.updates
                    // NEED TO FIGURE OUT HOW TO MAKE THE BADGES IMPORTABLE FROM FIRESTORE
                  ))));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
















