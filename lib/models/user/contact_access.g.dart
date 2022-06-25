// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_access.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactAccessAdapter extends TypeAdapter<ContactAccess> {
  @override
  final int typeId = 7;

  @override
  ContactAccess read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactAccess(
      fields[1] as Level,
    );
  }

  @override
  void write(BinaryWriter writer, ContactAccess obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.level);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactAccessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
