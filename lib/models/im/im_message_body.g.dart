// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_message_body.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IMMessageBodyAdapter extends TypeAdapter<IMMessageBody> {
  @override
  final int typeId = 19;

  @override
  IMMessageBody read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IMMessageBody(
      fields[1] as String?,
      fields[2] as IMImage?,
      (fields[3] as List).cast<IMMessageHistoryItem>(),
      fields[4] as IMMessage?,
    );
  }

  @override
  void write(BinaryWriter writer, IMMessageBody obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.history)
      ..writeByte(4)
      ..write(obj.aMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IMMessageBodyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
