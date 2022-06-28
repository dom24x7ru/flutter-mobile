// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_answer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoteAnswerAdapter extends TypeAdapter<VoteAnswer> {
  @override
  final int typeId = 24;

  @override
  VoteAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoteAnswer(
      fields[0] as dynamic,
      fields[1] as VoteQuestion,
      fields[2] as Person,
      fields[3] as Flat,
    );
  }

  @override
  void write(BinaryWriter writer, VoteAnswer obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.person)
      ..writeByte(3)
      ..write(obj.flat)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoteAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
