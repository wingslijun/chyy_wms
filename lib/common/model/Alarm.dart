import 'package:json_annotation/json_annotation.dart';

part 'Alarm.g.dart';
@JsonSerializable()
class Alarm extends Object {
  Alarm(
      this.name,
      this.type,
      this.msg
      );
  String name;
  String type;
  String msg;
  /// A necessary factory constructor for creating a new User instance
  /// from a map. We pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);
  // 命名构造函数
  Alarm.empty();

}
