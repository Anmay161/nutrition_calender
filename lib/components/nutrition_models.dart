import 'package:hive/hive.dart';

part 'nutrition_models.g.dart';

@HiveType(typeId: 0)
class ItemData {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool state;

  @HiveField(2)
  double amount;

  ItemData(this.name, this.state, this.amount);
}

@HiveType(typeId: 1)
class EatingTimeData {
  @HiveField(0)
  List<ItemData> breakfast = [];

  @HiveField(1)
  List<ItemData> lunch = [];

  @HiveField(2)
  List<ItemData> dinner = [];

  @HiveField(3)
  List<ItemData> other = [];

  EatingTimeData({
    List<ItemData>? breakfast,
    List<ItemData>? lunch,
    List<ItemData>? dinner,
    List<ItemData>? other,
  }) {
    this.breakfast = breakfast ?? [];
    this.lunch = lunch ?? [];
    this.dinner = dinner ?? [];
    this.other = other ?? [];
  }
}
