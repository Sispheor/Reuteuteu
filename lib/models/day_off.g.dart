// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_off.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayOffAdapter extends TypeAdapter<DayOff> {
  @override
  final int typeId = 1;

  @override
  DayOff read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayOff(
      fields[0] as String,
      fields[1] as DateTime,
      fields[2] as DateTime,
      fields[3] as bool,
      color: fields[4] == null ? Colors.green : fields[4] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, DayOff obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dateStart)
      ..writeByte(2)
      ..write(obj.dateEnd)
      ..writeByte(3)
      ..write(obj.isHalfDay)
      ..writeByte(4)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayOffAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
