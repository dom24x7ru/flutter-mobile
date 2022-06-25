// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_access.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NameAccessAdapter extends TypeAdapter<NameAccess> {
  @override
  final int typeId = 6;

  @override
  NameAccess read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NameAccess(
      fields[1] as Level,
      fields[2] as NameFormat,
    );
  }

  @override
  void write(BinaryWriter writer, NameAccess obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.format);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameAccessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
