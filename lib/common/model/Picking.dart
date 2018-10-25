/**
 * flutter packages pub run build_runner build
 * flutter packages pub run build_runner watch
 */
import 'package:json_annotation/json_annotation.dart';

part 'Picking.g.dart';

@JsonSerializable()
class Picking extends Object {
  String id;
  String orderNum;
  String time;
  String status;
  List<SubProduct> subProducts;
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

}


@JsonSerializable()
class SubProduct {
  var id;
  var sku;
  var name;
  var location;
  var code;
  var img;
  var num;
  var areadyNum;


  SubProduct(this.id,this.sku,this.name,this.location,this.code,this.img,this.num,this.areadyNum);

  factory SubProduct.fromJson(Map<String, dynamic> json) => _$SubProductFromJson(json);

}

