// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutual_help_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MutualHelpItemAdapter extends TypeAdapter<MutualHelpItem> {
  @override
  final int typeId = 36;

  @override
  MutualHelpItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MutualHelpItem(
      fields[0] as dynamic,
      fields[1] as String,
      fields[2] as String,
      fields[3] as bool,
      fields[4] as MutualHelpCategory,
      fields[5] as Person,
      fields[6] as Flat,
    )..updatedAt = fields[7] as int;
  }

  @override
  void write(BinaryWriter writer, MutualHelpItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.deleted)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.person)
      ..writeByte(6)
      ..write(obj.flat)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MutualHelpItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
