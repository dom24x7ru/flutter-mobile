// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      fields[0] as dynamic,
      fields[1] as String,
      fields[2] as bool,
      fields[3] as Role,
    )
      ..houseId = fields[4] as int?
      ..person = fields[5] as Person?
      ..residents = (fields[6] as List).cast<Resident>();
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.mobile)
      ..writeByte(2)
      ..write(obj.banned)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.houseId)
      ..writeByte(5)
      ..write(obj.person)
      ..writeByte(6)
      ..write(obj.residents)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
