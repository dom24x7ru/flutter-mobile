import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/user.dart';

class EnrichedActivity extends Model {
  User? actor;
  late DateTime time;
  Map<String, dynamic>? latestReactions;
  Map<String, dynamic>? ownReactions;
  Map<String, int>? reactionCounts;
  Map<String, dynamic>? extraData;

  EnrichedActivity(int id) : super(id);

  EnrichedActivity.fromMap(Map<String, dynamic> map) : super(map['id']) {
    if (map['actor'] != null) actor = User.fromMap(map['actor']);
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