// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'miniapp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MiniAppAdapter extends TypeAdapter<MiniApp> {
  @override
  final int typeId = 26;

  @override
  MiniApp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MiniApp(
      fields[0] as dynamic,
      fields[1] as MiniAppType,
      fields[2] as String,
      fields[3] as bool,
      fields[4] as MiniAppExtra,
    );
  }

  @override
  void write(BinaryWriter writer, MiniApp obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.published)
      ..writeByte(4)
      ..write(obj.extra)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MiniAppAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
