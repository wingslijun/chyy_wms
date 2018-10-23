
import 'package:json_annotation/json_annotation.dart';

part 'Picking.g.dart';

@JsonSerializable()
class Picking extends Object {
  String id;
  String orderNum;
  String time;
  String status;
  List<SubProducts> subProducts;
  Picking(
    this.id,
    this.orderNum,
    this.time,
    this.status,
    this.subProducts
  );

  /// A necessary factory constructor for creating a new User instance
  /// from a map. We pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory Picking.fromJson(Map<String, dynamic> json) => _$PickingFromJson(json);

  Picking.empty();
}


@JsonSerializable()
class SubProducts {
  var id;
  var name;
  var location;
  var code;
  var img;
  var num;


  SubProducts();

  factory SubProducts.fromJson(Map<String, dynamic> json) => _$SubProductsFromJson(json);
}

