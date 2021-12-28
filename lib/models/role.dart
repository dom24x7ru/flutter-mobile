class Role {
  late int id;
  late String name;

  Role(this.id, this.name);
  Role.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}