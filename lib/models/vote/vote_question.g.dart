// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoteQuestionAdapter extends TypeAdapter<VoteQuestion> {
  @override
  final int typeId = 25;

  @override
  VoteQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoteQuestion(
      fields[0] as dynamic,
      fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VoteQuestion obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoteQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
