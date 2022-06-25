// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResidentAdapter extends TypeAdapter<Resident> {
  @override
  final int typeId = 10;

  @override
  Resident read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Resident(
      fields[0] as int,
      fields[1] as int,
    )
      ..isOwner = fields[2] as bool?
      ..deleted = fields[3] as bool?
      ..flat = fields[4] as Flat?
      ..extra = fields[5] as ResidentExtra?;
  }

  @override
  void write(BinaryWriter writer, Resident obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.personId)
      ..writeByte(2)
      ..write(obj.isOwner)
      ..writeByte(3)
      ..write(obj.deleted)
      ..writeByte(4)
      ..write(obj.flat)
      ..writeByte(5)
      ..write(obj.extra)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResidentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
