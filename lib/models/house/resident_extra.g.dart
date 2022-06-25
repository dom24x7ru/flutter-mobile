// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_extra.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResidentExtraAdapter extends TypeAdapter<ResidentExtra> {
  @override
  final int typeId = 11;

  @override
  ResidentExtra read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResidentExtra(
      fields[1] as String,
    )..tenant = fields[2] as Tenant?;
  }

  @override
  void write(BinaryWriter writer, ResidentExtra obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.tenant);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResidentExtraAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
