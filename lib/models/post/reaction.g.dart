// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReactionAdapter extends TypeAdapter<Reaction> {
  @override
  final int typeId = 41;

  @override
  Reaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reaction(
      fields[0] as int,
    )
      ..user = fields[1] as IMPerson?
      ..data = (fields[2] as Map?)?.cast<String, dynamic>()
      ..createdAt = fields[3] as int
      ..latestChildren = (fields[4] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<Reaction>()))
      ..ownChildren = (fields[5] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<Reaction>()))
      ..childrenCounts = (fields[6] as Map?)?.cast<String, int>();
  }

  @override
  void write(BinaryWriter writer, Reaction obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.latestChildren)
      ..writeByte(5)
      ..write(obj.ownChildren)
      ..writeByte(6)
      ..write(obj.childrenCounts)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
