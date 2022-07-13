import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'reaction.g.dart';

@HiveType(typeId: 41)
class Reaction extends Model {
  @HiveField(1)
  IMPerson? user;
  @HiveField(2)
  Map<String, dynamic>? data;
  @HiveField(3)
  late int createdAt;
  @HiveField(4)
  Map<String, List<Reaction>>? latestChildren;
  @HiveField(5)
  Map<String, List<Reaction>>? ownChildren;
  @HiveField(6)
  Map<String, int>? childrenCounts;

  Reaction(int id) : super(id);
  
  Reaction.fromMap(Map<String, dynamic> map) : super(map['id']) {
    if (map['user'] != null) user = IMPerson.fromMap(map['user']);
    data = map['data'];
    createdAt = map['createdAt'];
    if (map['latestChildren'] != null) {
      latestChildren = { 'like': [], 'comment': [] };
      for (var reactionMap in map['latestChildren']['like']) {
        (latestChildren!['like'] as List).add(Reaction.fromMap(reactionMap));
      }
      for (var reactionMap in map['latestChildren']['comment']) {
        (latestChildren!['comment'] as List).add(Reaction.fromMap(reactionMap));
      }
    }
    if (map['ownChildren'] != null) {
      ownChildren = { 'like': [], 'comment': [] };
      for (var reactionMap in map['ownChildren']['like']) {
        (ownChildren!['like'] as List).add(Reaction.fromMap(reactionMap));
      }
      for (var reactionMap in map['ownChildren']['comment']) {
        (ownChildren!['comment'] as List).add(Reaction.fromMap(reactionMap));
      }
    }
    if (map['childrenCounts'] != null) {
      childrenCounts = {
        'like': map['childrenCounts']['like'] as int,
        'comment': map['childrenCounts']['comment'] as int
      };
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'createdAt': createdAt };
    if (user != null) map['user'] = user!.toMap();
    if (data != null) map['data'] = data;
    if (latestChildren != null) map['latestChildren'] = latestChildren;
    if (ownChildren != null) map['ownChildren'] = ownChildren;
    if (childrenCounts != null) map['childrenCounts'] = childrenCounts;
    return map;
  }
}