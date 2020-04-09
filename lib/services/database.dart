import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  final String email;
  DatabaseService({ this.uid, this.email });

  final CollectionReference profiles = Firestore.instance.collection("profile");

  Future setUserData(String name, String uid, String bio, String badges, String email) async {
    return await Firestore.instance.collection('profile').document(uid).setData({
      'name': name,
      'uid' : this.uid,
      'bio': bio,
      'badges': badges,
      'email': this.email,
    });
  }

  Future setProjectData(String name, String description, String badges, String email) async {
    return await Firestore.instance.collection('projects').document(name).setData({
      'name': name,
      'description' : description,
      'badges': badges,
      'email': this.email,
    });
  }

  Stream<QuerySnapshot> get profile {
    return profiles.snapshots();
  }
}