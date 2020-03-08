class User {

  final String uid;

  User({this.uid});

}

class Project {

  final String uid;
  final String name;
  final String description;
  final List<String> badges;

  Project({this.uid, this.name, this.description, this.badges});
}