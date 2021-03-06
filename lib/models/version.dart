class Version {
  late int number;
  late int build;

  Version(this.number, this.build);
  Version.fromMap(Map<String, dynamic> map) {
    number = map['number'];
    build = map['build'];
  }

  Map<String, dynamic> toMap() {
    return { 'number': number, 'build': build };
  }
}