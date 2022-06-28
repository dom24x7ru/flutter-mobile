// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FAQItemAdapter extends TypeAdapter<FAQItem> {
  @override
  final int typeId = 32;

  @override
  FAQItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FAQItem(
      fields[0] as dynamic,
      fields[1] as String,
      fields[2] as String,
      fields[3] as FAQCategory,
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FAQItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FAQItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
