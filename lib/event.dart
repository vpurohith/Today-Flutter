import 'package:hive/hive.dart';
part 'event.g.dart';

@HiveType(typeId: 0)
class Event extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String color;

  @HiveField(3)
  int? realColor;

  Event({
    required this.title,
    required this.color,
    required this.realColor,
  });
}
