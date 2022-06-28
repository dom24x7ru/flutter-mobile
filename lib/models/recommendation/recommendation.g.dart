// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendationAdapter extends TypeAdapter<Recommendation> {
  @override
  final int typeId = 37;

  @override
  Recommendation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recommendation(
      fields[0] as dynamic,
      fields[1] as String,
      fields[2] as String,
      fields[3] as bool,
      fields[4] as RecommendationExtra,
      fields[5] as RecommendationCategory,
      fields[6] as Person,
      fields[7] as Flat,
      fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Recommendation obj) {
    writer
      ..writeByte(9)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.deleted)
      ..writeByte(4)
      ..write(obj.extra)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.person)
      ..writeByte(7)
      ..write(obj.flat)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
