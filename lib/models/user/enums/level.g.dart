// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelAdapter extends TypeAdapter<Level> {
  @override
  final int typeId = 8;

  @override
  Level read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 1:
        return Level.nothing;
      case 2:
        return Level.friends;
      case 3:
        return Level.all;
      default:
        return Level.nothing;
    }
  }

  @override
  void write(BinaryWriter writer, Level obj) {
    switch (obj) {
      case Level.nothing:
        writer.writeByte(1);
        break;
      case Level.friends:
        writer.writeByte(2);
        break;
      case Level.all:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
