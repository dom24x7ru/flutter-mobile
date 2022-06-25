// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flat_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlatTypeAdapter extends TypeAdapter<FlatType> {
  @override
  final int typeId = 14;

  @override
  FlatType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlatType(
      fields[0] as dynamic,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FlatType obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlatTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
