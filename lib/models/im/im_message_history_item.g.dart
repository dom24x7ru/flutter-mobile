// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_message_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IMMessageHistoryItemAdapter extends TypeAdapter<IMMessageHistoryItem> {
  @override
  final int typeId = 20;

  @override
  IMMessageHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IMMessageHistoryItem(
      fields[1] as int,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, IMMessageHistoryItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IMMessageHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
