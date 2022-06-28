// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FAQCategoryAdapter extends TypeAdapter<FAQCategory> {
  @override
  final int typeId = 31;

  @override
  FAQCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FAQCategory(
      fields[0] as dynamic,
      fields[1] as String,
      fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FAQCategory obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FAQCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
