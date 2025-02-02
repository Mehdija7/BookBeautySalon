// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      appointmentId: (json['appointmentId'] as num?)?.toInt(),
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      userId: (json['userId'] as num?)?.toInt(),
      hairdresserId: (json['hairdresserId'] as num?)?.toInt(),
      serviceId: (json['serviceId'] as num?)?.toInt(),
      service: json['service'] == null
          ? null
          : Service.fromJson(json['service'] as Map<String, dynamic>),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'appointmentId': instance.appointmentId,
      'dateTime': instance.dateTime?.toIso8601String(),
      'userId': instance.userId,
      'hairdresserId': instance.hairdresserId,
      'serviceId': instance.serviceId,
      'service': instance.service,
      'note': instance.note,
    };
