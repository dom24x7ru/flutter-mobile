// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InviteAdapter extends TypeAdapter<Invite> {
  @override
  final int typeId = 29;

  @override
  Invite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Invite(
      fields[0] as dynamic,
      fields[1] as int,
      fields[2] as int,
      fields[3] as String?,
      fields[4] as bool?,
      fields[5] as Person?,
      fields[6] as Flat?,
    );
  }

  @override
  void write(BinaryWriter writer, Invite obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.code)
      ..writeByte(4)
      ..write(obj.used)
      ..writeByte(5)
      ..write(obj.person)
      ..writeByte(6)
      ..write(obj.flat)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InviteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
