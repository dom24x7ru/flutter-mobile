// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoteAdapter extends TypeAdapter<Vote> {
  @override
  final int typeId = 23;

  @override
  Vote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vote(
      fields[0] as dynamic,
      fields[1] as int,
      fields[2] as String,
      fields[3] as int,
      fields[4] as bool,
      fields[5] as bool,
      fields[6] as bool,
      fields[7] as bool,
      fields[8] as int?,
      fields[9] as int?,
      fields[10] as int,
      (fields[11] as List).cast<VoteQuestion>(),
      (fields[12] as List).cast<VoteAnswer>(),
    );
  }

  @override
  void write(BinaryWriter writer, Vote obj) {
    writer
      ..writeByte(13)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.multi)
      ..writeByte(5)
      ..write(obj.anonymous)
      ..writeByte(6)
      ..write(obj.closed)
      ..writeByte(7)
      ..write(obj.house)
      ..writeByte(8)
      ..write(obj.section)
      ..writeByte(9)
      ..write(obj.floor)
      ..writeByte(10)
      ..write(obj.persons)
      ..writeByte(11)
      ..write(obj.questions)
      ..writeByte(12)
      ..write(obj.answers)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
