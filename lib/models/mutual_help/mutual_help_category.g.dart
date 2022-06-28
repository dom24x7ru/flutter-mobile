// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutual_help_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MutualHelpCategoryAdapter extends TypeAdapter<MutualHelpCategory> {
  @override
  final int typeId = 35;

  @override
  MutualHelpCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MutualHelpCategory(
      fields[0] as dynamic,
      fields[1] as String,
      fields[2] as String,
      fields[3] as int,
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MutualHelpCategory obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.img)
      ..writeByte(3)
      ..write(obj.sort)
      ..writeByte(4)
      ..write(obj.count)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MutualHelpCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
