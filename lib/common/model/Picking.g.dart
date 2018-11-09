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
      json['jhBarCode'] as String,
      (json['subProducts'] as List)
          ?.map((e) =>
              e == null ? null : SubProduct.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$PickingToJson(Picking instance) => <String, dynamic>{
      'id': instance.id,
      'orderNum': instance.orderNum,
      'time': instance.time,
      'status': instance.status,
      'jhBarCode': instance.jhBarCode,
      'subProducts': instance.subProducts
    };

SubProduct _$SubProductFromJson(Map<String, dynamic> json) {
  return SubProduct(json['id'], json['sku'], json['name'], json['location'],
      json['code'], json['img'], json['num'], json['areadyNum']);
}

Map<String, dynamic> _$SubProductToJson(SubProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'location': instance.location,
      'code': instance.code,
      'img': instance.img,
      'num': instance.num,
      'areadyNum': instance.areadyNum
    };
