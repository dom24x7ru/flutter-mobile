// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IMMessageAdapter extends TypeAdapter<IMMessage> {
  @override
  final int typeId = 17;

  @override
  IMMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IMMessage(
      fields[0] as dynamic,
      fields[1] as String,
      fields[2] as int,
      fields[3] as int?,
      fields[4] as IMPerson?,
      fields[5] as IMChannel?,
      fields[6] as IMMessageBody?,
      fields[7] as IMMessageExtra?,
    );
  }

  @override
  void write(BinaryWriter writer, IMMessage obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.guid)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.imPerson)
      ..writeByte(5)
      ..write(obj.channel)
      ..writeByte(6)
      ..write(obj.body)
      ..writeByte(7)
      ..write(obj.extra)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IMMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
