import 'dart:convert';
import 'package:book_beauty/models/appointment.dart';
import 'package:book_beauty/models/service.dart';
import 'package:intl/intl.dart';
import 'base_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppointmentProvider extends BaseProvider<Appointment> {
  AppointmentProvider() : super("Appointment");

  @override
  Appointment fromJson(data) {
    return Appointment.fromJson(data);
  }

  Future<List<TimeOfDay>> getAvailableAppointments(
      Appointment appointment) async {
    final url =
        Uri.parse('${BaseProvider.baseUrl}Appointment/availableAppointments');
    var headers = createHeaders();

    print(
        "------------------------------ DATE TIME OF THE APPOINTMENT --------------------------------");
    print(appointment.dateTime);
    var body = jsonEncode({
      'UserId': appointment.userId,
      'HairdresserId': appointment.hairdresserId,
      'DateTime': appointment.dateTime != null
          ? DateFormat("yyyy-MM-ddTHH:mm").format(appointment.dateTime!)
          : null,
      'ServiceId': appointment.serviceId,
      'Note': appointment.note
    });

    print(
        "------------------------------ BODY  --------------------------------");
    print(body);
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<TimeOfDay> availableTimes = data.map<TimeOfDay>((timeString) {
        final parts = timeString.split(":");
        return TimeOfDay(
            hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }).toList();

      return availableTimes;
    } else {
      throw Exception('Failed to load available appointments');
    }
  }

  Future<List<Appointment>> getAppointmentsByUser(int userId) async {
    final url = Uri.parse(
        '${BaseProvider.baseUrl}Appointment/getAppointmentsByUser?userId=$userId');

    var headers = createHeaders();
    final response = await http.get(url, headers: headers);

    if (response!.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      List<Appointment> appointments = jsonResponse.map((json) {
        return Appointment(
          appointmentId: json['appointmentId'],
          dateTime: DateTime.parse(json['dateTime']),
          userId: json['userId'],
          hairdresserId: json['hairdresserId'],
          serviceId: json['serviceId'],
          note: json['note'],
          service: json['service'] != null
              ? Service.fromJson(json['service'])
              : null,
        );
      }).toList();

      print(
          "******************************************* RESULT ****************************");
      print(appointments);
      return appointments;
    } else {
      throw Exception('Error loading appointments');
    }
  }
}
