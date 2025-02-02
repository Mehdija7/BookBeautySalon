import 'package:bookbeauty_desktop/models/service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Appointment {
  int? appointmentId;
  DateTime? dateTime;
  int? userId;
  int? hairdresserId;
  int? serviceId;
  Service? service;
  String? note;

  Appointment(
      {this.appointmentId,
      this.dateTime,
      this.userId,
      this.hairdresserId,
      this.serviceId,
      this.service,
      this.note});

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
