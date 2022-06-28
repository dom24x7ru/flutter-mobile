// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instruction_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstructionItemAdapter extends TypeAdapter<InstructionItem> {
  @override
  final int typeId = 34;

  @override
  InstructionItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstructionItem(
      fields[0] as dynamic,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InstructionItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstructionItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
