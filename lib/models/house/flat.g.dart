// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlatAdapter extends TypeAdapter<Flat> {
  @override
  final int typeId = 13;

  @override
  Flat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Flat(
      fields[0] as dynamic,
      fields[1] as int,
      fields[2] as int?,
      fields[3] as int?,
    )
      ..rooms = fields[4] as int?
      ..square = fields[5] as double
      ..type = fields[6] as FlatType?
      ..residents = (fields[7] as List).cast<Resident>()
      ..updatedAt = fields[8] as int?;
  }

  @override
  void write(BinaryWriter writer, Flat obj) {
    writer
      ..writeByte(9)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.floor)
      ..writeByte(3)
      ..write(obj.section)
      ..writeByte(4)
      ..write(obj.rooms)
      ..writeByte(5)
      ..write(obj.square)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.residents)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
