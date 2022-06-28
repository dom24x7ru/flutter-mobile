// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstructionAdapter extends TypeAdapter<Instruction> {
  @override
  final int typeId = 33;

  @override
  Instruction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Instruction(
      fields[0] as dynamic,
      fields[1] as String,
      fields[2] as String,
      (fields[3] as List).cast<InstructionItem>(),
    )..updatedAt = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, Instruction obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstructionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
