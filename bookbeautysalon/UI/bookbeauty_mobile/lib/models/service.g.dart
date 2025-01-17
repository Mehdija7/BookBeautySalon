// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      shortDescription: json['shortDescription'] as String?,
      longDescription: json['longDescription'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      image: json['image'] as String?,
    )..serviceId = (json['serviceId'] as num?)?.toInt();

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'serviceId': instance.serviceId,
      'name': instance.name,
      'price': instance.price,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'duration': instance.duration,
      'image': instance.image,
    };
