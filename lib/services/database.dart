import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference profiles = Firestore.instance.collection("profile");

  Future setUserData(String name, String uid, String bio, String badges) async {
    return await Firestore.instance.collection('profile').document(uid).setData({
      'name': name,
      'uid' : this.uid,
      'bio': bio,
      'badges': badges,
    });
  }

  Future setProjectData(String name, String description, String badges, String updates) async {
    return await Firestore.instance.collection('projects').document(name).setData({
      'name': name,
      'description' : description,
      'badges': badges,
      'updates': updates,
    });
  }

  Stream<QuerySnapshot> get profile {
    return profiles.snapshots();
  }
}