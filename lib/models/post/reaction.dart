import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/user.dart';

class Reaction extends Model {
  User? user;
  Map<String, dynamic>? data;

  Reaction(int id) : super(id);

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}