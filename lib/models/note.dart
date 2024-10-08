import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(3)
  DateTime date;

  Note({required this.name, required this.description, required this.date});
}
