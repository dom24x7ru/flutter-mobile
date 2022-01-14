class Person {
  String? surname;
  String? name;
  String? midname;
  DateTime? birthday;
  String? sex;
  String? biography;
  String? telegram;
  String? mobile;
  bool deleted = false;
  // access: {name: {level: all, format: name}, mobile: {level: all}, telegram: {level: all}}

  Person(this.surname, this.name, this.midname);
  Person.fromMap(Map<String, dynamic> map) {
    surname = map['surname'];
    name = map['name'];
    midname = map['midname'];
    telegram = map['telegram'];
    mobile = map['mobile'];
    if (map['deleted'] != null) {
      deleted = map['deleted'];
    } else {
      deleted = false;
    }
  }
}