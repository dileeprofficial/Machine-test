import 'package:hive/hive.dart';
part 'searchHistory.g.dart';

@HiveType(typeId: 0)
class SearchHistory extends HiveObject {
  @HiveField(0)
  String startLocation;

  @HiveField(1)
  String endLocation;

  @HiveField(2)
  DateTime searchDate;

  @HiveField(3)
  double startLatitude;

  @HiveField(4)
  double startLongitude;

  @HiveField(5)
  double endLatitude;

  @HiveField(6)
  double endLongitude;

  SearchHistory({
    required this.startLocation,
    required this.endLocation,
    required this.searchDate,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
  });
}
