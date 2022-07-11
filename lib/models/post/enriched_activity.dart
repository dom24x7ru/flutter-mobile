import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/post/reaction.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'enriched_activity.g.dart';

@HiveType(typeId: 40)
class EnrichedActivity extends Model {
  @HiveField(1)
  IMPerson? actor;
  @HiveField(2)
  late int time;
  @HiveField(3)
  Map<String, List<Reaction>>? latestReactions;
  @HiveField(4)
  Map<String, List<Reaction>>? ownReactions;
  @HiveField(5)
  Map<String, int>? reactionCounts;
  @HiveField(6)
  Map<String, dynamic>? extraData;

  EnrichedActivity(int id) : super(id);

  EnrichedActivity.fromMap(Map<String, dynamic> map) : super(map['id']) {
    if (map['actor'] != null) actor = IMPerson.fromMap(map['actor']);
    time = map['time'];
    if (map['latestReactions'] != null) {
      latestReactions = { 'like': [] };
      for (var reactionMap in map['latestReactions']['like']) {
        (latestReactions!['like'] as List).add(Reaction.fromMap(reactionMap));
      }
    }
    if (map['ownReactions'] != null) {
      ownReactions = { 'like': [] };
      for (var reactionMap in map['ownReactions']['like']) {
        (ownReactions!['like'] as List).add(Reaction.fromMap(reactionMap));
      }
    }
    if (map['reactionCounts'] != null) {
      reactionCounts = { 'like': map['reactionCounts']['like'] as int };
    }
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