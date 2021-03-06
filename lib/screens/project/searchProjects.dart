import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample_flutter_app/models/models.dart';
import 'package:sample_flutter_app/screens/project/searchviewProject.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';


class Post {
  final String title;
  final String description;
  final String uid;
  final String url;
  final List<dynamic> updates;
  final List<dynamic> badges;

  Post(this.title, this.description, this.uid, this.url, this.updates, this.badges);
}

class SearchProjects extends StatefulWidget {
  @override
  _SearchProjects createState() => _SearchProjects();
}

class _SearchProjects extends State<SearchProjects> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
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
      String pURL = documentList[i].data['imagesURL'];
      List<dynamic> pUpd = documentList[i].data['updates'];
      List<dynamic> pBad = documentList[i].data['badges'];


      if (pName.toUpperCase().contains(search.toUpperCase())) {
          posts.add(Post(pName, pDes, pUid, pURL, pUpd, pBad));
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SearchBar<Post>(
            minimumChars: 1,
            hintText: "Project Name",
            iconActiveColor: Colors.red,
            onSearch: search,
            searchBarController: _searchBarController,
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            header: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("Back"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  child: Text("Sort by creation date"),
                  onPressed: () {
                    _searchBarController.removeSort();
                  },
                ),
                RaisedButton(
                  child: Text("Refresh"),
                  onPressed: () {
                    //isReplay = !isReplay;
                    _searchBarController.replayLastSearch();
                  },
                ),
              ],
            ),
            onItemFound: (Post post, int index) {
              return ListTile(
                title: Text(post.title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                subtitle: Text(post.description, style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchViewProject(projValues : Project(
                      uid: post.uid,
                      name: post.title,
                      description: post.description,
                      imagesURL: post.url,
                      updates: post.updates,
                      badges: post.badges
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