// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_format.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NameFormatAdapter extends TypeAdapter<NameFormat> {
  @override
  final int typeId = 9;

  @override
  NameFormat read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 1:
        return NameFormat.name;
      case 2:
        return NameFormat.all;
      default:
        return NameFormat.name;
    }
  }

  @override
  void write(BinaryWriter writer, NameFormat obj) {
    switch (obj) {
      case NameFormat.name:
        writer.writeByte(1);
        break;
      case NameFormat.all:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameFormatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
