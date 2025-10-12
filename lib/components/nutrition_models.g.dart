// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemDataAdapter extends TypeAdapter<ItemData> {
  @override
  final int typeId = 0;

  @override
  ItemData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemData(
      fields[0] as String,
      fields[1] as bool,
      fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ItemData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.state)
      ..writeByte(2)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EatingTimeDataAdapter extends TypeAdapter<EatingTimeData> {
  @override
  final int typeId = 1;

  @override
  EatingTimeData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EatingTimeData(
      breakfast: (fields[0] as List?)?.cast<ItemData>(),
      lunch: (fields[1] as List?)?.cast<ItemData>(),
      dinner: (fields[2] as List?)?.cast<ItemData>(),
      other: (fields[3] as List?)?.cast<ItemData>(),
    );
  }

  @override
  void write(BinaryWriter writer, EatingTimeData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.breakfast)
      ..writeByte(1)
      ..write(obj.lunch)
      ..writeByte(2)
      ..write(obj.dinner)
      ..writeByte(3)
      ..write(obj.other);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EatingTimeDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
