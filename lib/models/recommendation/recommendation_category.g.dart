// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendationCategoryAdapter
    extends TypeAdapter<RecommendationCategory> {
  @override
  final int typeId = 38;

  @override
  RecommendationCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendationCategory(
      fields[0] as dynamic,
      fields[1] as String,
      fields[2] as String,
      fields[3] as int,
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecommendationCategory obj) {
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
      other is RecommendationCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
