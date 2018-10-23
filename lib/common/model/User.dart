import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User extends Object {
  User(
      this.id,
      this.name,
      );
  int id;
  String name;
  /// A necessary factory constructor for creating a new User instance
  /// from a map. We pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // 命名构造函数
  User.empty();

}
