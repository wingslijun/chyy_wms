// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Picking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Picking _$PickingFromJson(Map<String, dynamic> json) {
  return Picking(
      json['id'] as String,
      json['orderNum'] as String,
      json['time'] as String,
      json['status'] as String,
      (json['subProducts'] as List)
          ?.map((e) => e == null
              ? null
              : SubProducts.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$PickingToJson(Picking instance) => <String, dynamic>{
      'id': instance.id,
      'orderNum': instance.orderNum,
      'time': instance.time,
      'status': instance.status,
      'subProducts': instance.subProducts
    };

SubProducts _$SubProductsFromJson(Map<String, dynamic> json) {
  return SubProducts()
    ..id = json['id']
    ..name = json['name']
    ..location = json['location']
    ..code = json['code']
    ..img = json['img']
    ..num = json['num'];
}

Map<String, dynamic> _$SubProductsToJson(SubProducts instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'code': instance.code,
      'img': instance.img,
      'num': instance.num
    };
