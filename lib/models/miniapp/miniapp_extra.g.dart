// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'miniapp_extra.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MiniAppExtraAdapter extends TypeAdapter<MiniAppExtra> {
  @override
  final int typeId = 27;

  @override
  MiniAppExtra read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MiniAppExtra(
      fields[1] as String,
      fields[2] as String,
      fields[3] as String?,
      (fields[4] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, MiniAppExtra obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.more);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MiniAppExtraAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
