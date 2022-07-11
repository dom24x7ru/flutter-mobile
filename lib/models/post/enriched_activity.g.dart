// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enriched_activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnrichedActivityAdapter extends TypeAdapter<EnrichedActivity> {
  @override
  final int typeId = 40;

  @override
  EnrichedActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnrichedActivity(
      fields[0] as int,
    )
      ..actor = fields[1] as IMPerson?
      ..time = fields[2] as int
      ..latestReactions = (fields[3] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<Reaction>()))
      ..ownReactions = (fields[4] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<Reaction>()))
      ..reactionCounts = (fields[5] as Map?)?.cast<String, int>()
      ..extraData = (fields[6] as Map?)?.cast<String, dynamic>();
  }

  @override
  void write(BinaryWriter writer, EnrichedActivity obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.actor)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.latestReactions)
      ..writeByte(4)
      ..write(obj.ownReactions)
      ..writeByte(5)
      ..write(obj.reactionCounts)
      ..writeByte(6)
      ..write(obj.extraData)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnrichedActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
