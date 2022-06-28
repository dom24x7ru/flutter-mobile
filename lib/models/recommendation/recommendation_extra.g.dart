// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_extra.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendationExtraAdapter extends TypeAdapter<RecommendationExtra> {
  @override
  final int typeId = 39;

  @override
  RecommendationExtra read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendationExtra(
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String?,
      fields[4] as String?,
      fields[5] as String?,
      fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecommendationExtra obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.site)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.instagram)
      ..writeByte(6)
      ..write(obj.telegram);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationExtraAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
