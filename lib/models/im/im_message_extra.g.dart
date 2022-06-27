// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_message_extra.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IMMessageExtraAdapter extends TypeAdapter<IMMessageExtra> {
  @override
  final int typeId = 18;

  @override
  IMMessageExtra read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IMMessageExtra(
      (fields[1] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, IMMessageExtra obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.shown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IMMessageExtraAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
