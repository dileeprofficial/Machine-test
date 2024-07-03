// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searchHistory.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchHistoryAdapter extends TypeAdapter<SearchHistory> {
  @override
  final int typeId = 0;

  @override
  SearchHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchHistory(
      startLocation: fields[0] as String,
      endLocation: fields[1] as String,
      searchDate: fields[2] as DateTime,
      startLatitude: fields[3] as double,
      startLongitude: fields[4] as double,
      endLatitude: fields[5] as double,
      endLongitude: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SearchHistory obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.startLocation)
      ..writeByte(1)
      ..write(obj.endLocation)
      ..writeByte(2)
      ..write(obj.searchDate)
      ..writeByte(3)
      ..write(obj.startLatitude)
      ..writeByte(4)
      ..write(obj.startLongitude)
      ..writeByte(5)
      ..write(obj.endLatitude)
      ..writeByte(6)
      ..write(obj.endLongitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
