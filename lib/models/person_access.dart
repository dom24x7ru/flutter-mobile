enum Level { nothing, friends, all }
enum NameFormat { name, all }

class NameAccess {
  Level level = Level.nothing;
  NameFormat format = NameFormat.all;

  NameAccess(this.level, this.format);
  NameAccess.fromMap(Map<String, dynamic> map) {
    switch(map['level']) {
      case 'nothing':
        level = Level.nothing;
        break;
      case 'friends':
        level = Level.friends;
        break;
      case 'all':
        level = Level.all;
        break;
    }
    switch(map['format']) {
      case 'name':
        format = NameFormat.name;
        break;
      case 'all':
        format = NameFormat.all;
        break;
    }
  }
}

class ContactAccess {
  Level level = Level.nothing;

  ContactAccess(this.level);
  ContactAccess.fromMap(Map<String, dynamic> map) {
    switch(map['level']) {
      case 'nothing':
        level = Level.nothing;
        break;
      case 'friends':
        level = Level.friends;
        break;
      case 'all':
        level = Level.all;
        break;
    }
  }
}


class PersonAccess {
  NameAccess? name;
  ContactAccess? mobile;
  ContactAccess? telegram;

  PersonAccess(this.name, this.mobile, this.telegram);
  PersonAccess.fromMap(Map<String, dynamic> map) {
    name = NameAccess.fromMap(map['name']);
    mobile = ContactAccess.fromMap(map['mobile']);
    telegram = ContactAccess.fromMap(map['telegram']);
  }
}