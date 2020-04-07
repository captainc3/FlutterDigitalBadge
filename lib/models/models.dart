class User {

  final String uid;
  final String name;
  final String bio;
  final String badges;

  User({this.uid, this.name, this.bio, this.badges});

}

class Project {

  final String uid;
  final String name;
  final String description;
  final List<String> badges;
  final String updates;

  Project({this.uid, this.name, this.description, this.badges, this.updates});
}