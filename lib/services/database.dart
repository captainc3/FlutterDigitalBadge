import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference profiles = Firestore.instance.collection("profile");

  final CollectionReference projectCollection = Firestore.instance.collection('projects');

  Future updateUserData(String name, String bio, String badges) async {
    return await profiles.document(uid).setData({
      'name': name,
      'bio': bio,
      'badges': badges,
    });
  }

  Stream<QuerySnapshot> get profile {
    return profiles.snapshots();
  }
}