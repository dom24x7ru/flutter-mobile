// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 4;

  @override
  Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Person(
      fields[0] as dynamic,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String?,
    )
      ..birthday = fields[4] as DateTime?
      ..sex = fields[5] as String?
      ..biography = fields[6] as String?
      ..telegram = fields[7] as String?
      ..mobile = fields[8] as String?
      ..deleted = fields[9] as bool
      ..access = fields[10] as PersonAccess?
      ..extra = fields[11] as ResidentExtra?;
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer
      ..writeByte(12)
      ..writeByte(1)
      ..write(obj.surname)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.midname)
      ..writeByte(4)
      ..write(obj.birthday)
      ..writeByte(5)
      ..write(obj.sex)
      ..writeByte(6)
      ..write(obj.biography)
      ..writeByte(7)
      ..write(obj.telegram)
      ..writeByte(8)
      ..write(obj.mobile)
      ..writeByte(9)
      ..write(obj.deleted)
      ..writeByte(10)
      ..write(obj.access)
      ..writeByte(11)
      ..write(obj.extra)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
