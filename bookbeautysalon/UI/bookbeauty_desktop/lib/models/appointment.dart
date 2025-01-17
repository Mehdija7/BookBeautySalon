import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Appointment {
  int? appointmentId;
  DateTime? dateTime;
  int? userId;
  int? hairdresserId;
  int? serviceId;

  Appointment(
      {this.appointmentId,
      this.dateTime,
      this.userId,
      this.hairdresserId,
      this.serviceId});

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
