// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_access.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonAccessAdapter extends TypeAdapter<PersonAccess> {
  @override
  final int typeId = 5;

  @override
  PersonAccess read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonAccess(
      fields[1] as NameAccess?,
      fields[2] as ContactAccess?,
      fields[3] as ContactAccess?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonAccess obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.mobile)
      ..writeByte(3)
      ..write(obj.telegram);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAccessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
