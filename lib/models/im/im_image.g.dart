// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IMImageAdapter extends TypeAdapter<IMImage> {
  @override
  final int typeId = 22;

  @override
  IMImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IMImage(
      fields[0] as dynamic,
      fields[1] as String,
      fields[2] as int,
      fields[3] as String,
      fields[4] as int,
      fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, IMImage obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.size)
      ..writeByte(3)
      ..write(obj.uri)
      ..writeByte(4)
      ..write(obj.width)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IMImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
