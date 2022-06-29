// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_channel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IMChannelAdapter extends TypeAdapter<IMChannel> {
  @override
  final int typeId = 16;

  @override
  IMChannel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IMChannel(
      fields[0] as dynamic,
      fields[1] as String?,
      fields[2] as bool?,
      fields[3] as bool?,
      fields[4] as IMMessage?,
      fields[5] as int,
      (fields[6] as List).cast<IMPerson>(),
    )..updatedAt = fields[7] as int?;
  }

  @override
  void write(BinaryWriter writer, IMChannel obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.allHouse)
      ..writeByte(3)
      ..write(obj.private)
      ..writeByte(4)
      ..write(obj.lastMessage)
      ..writeByte(5)
      ..write(obj.count)
      ..writeByte(6)
      ..write(obj.persons)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IMChannelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
