// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Alarm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alarm _$AlarmFromJson(Map<String, dynamic> json) {
  return Alarm(
      json['name'] as String, json['type'] as String, json['msg'] as String);
}

Map<String, dynamic> _$AlarmToJson(Alarm instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'msg': instance.msg
    };
