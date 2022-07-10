import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'enriched_activity.g.dart';

@HiveType(typeId: 40)
class EnrichedActivity extends Model {
  @HiveField(1)
  IMPerson? actor;
  @HiveField(2)
  late int time;
  @HiveField(3)
  Map<String, dynamic>? latestReactions;
  @HiveField(4)
  Map<String, dynamic>? ownReactions;
  @HiveField(5)
  Map<String, int>? reactionCounts;
  @HiveField(6)
  Map<String, dynamic>? extraData;

  EnrichedActivity(int id) : super(id);

  EnrichedActivity.fromMap(Map<String, dynamic> map) : super(map['id']) {
    if (map['actor'] != null) {
      Person person = Person.fromMap(map['actor']);
      Flat? flat;
      if (map['actor']['flat'] != null) flat = Flat.fromMap(map['actor']['flat']);
      actor = IMPerson(
          person,
          flat,
          map['actor']['profilePhoto'] != null ? map['actor']['profilePhoto']['thumbnail'] : null,
          map['actor']['profilePhoto'] != null ? map['actor']['profilePhoto']['resized'] : null
      );
    }
    time = map['time'];
    latestReactions = map['latestReactions'];
    ownReactions = map['ownReactions'];
    reactionCounts = map['reactionCounts'];
    extraData = map['extraData'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'time': time };
    if (actor != null) map['actor'] = actor!.toMap();
    if (latestReactions != null) map['latestReactions'] = latestReactions;
    if (ownReactions != null) map['ownReactions'] = ownReactions;
    if (reactionCounts != null) map['reactionCounts'] = reactionCounts;
    if (extraData != null) map['extraData'] = extraData;
    return map;
  }
}