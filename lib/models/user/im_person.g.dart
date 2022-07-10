// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'im_person.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IMPersonAdapter extends TypeAdapter<IMPerson> {
  @override
  final int typeId = 21;

  @override
  IMPerson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IMPerson(
      fields[1] as Person,
      fields[2] as Flat?,
      fields[3] as String?,
      fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IMPerson obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.person)
      ..writeByte(2)
      ..write(obj.flat)
      ..writeByte(3)
      ..write(obj.profilePhotoThumbnail)
      ..writeByte(4)
      ..write(obj.profilePhotoResized);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IMPersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
