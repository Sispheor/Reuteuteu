// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PoolAdapter extends TypeAdapter<Pool> {
  @override
  final int typeId = 2;

  @override
  Pool read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pool(
      fields[0] as String,
      fields[1] as double,
    )..dayOffList = (fields[2] as HiveList?)?.castHiveList();
  }

  @override
  void write(BinaryWriter writer, Pool obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.maxDays)
      ..writeByte(2)
      ..write(obj.dayOffList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoolAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
