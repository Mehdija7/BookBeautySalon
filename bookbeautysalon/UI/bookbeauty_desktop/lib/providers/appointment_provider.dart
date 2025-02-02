import 'dart:convert';

import 'package:bookbeauty_desktop/models/appointment.dart';
import 'package:http/http.dart' as http;
import 'base_provider.dart';
import '../utils.dart';

class AppointmentProvider extends BaseProvider<Appointment> {
  AppointmentProvider() : super("Appointment");

  @override
  Appointment fromJson(data) {
    return Appointment.fromJson(data);
  }

  Future<List<Appointment>> fetchAppointments() async {
    var uri = Uri.parse('${BaseProvider.baseUrl}Appointment/getAppointments');
    print("************ URI ********** $uri");

    var headers = createHeaders();
    print('*****   URI HEADERS    ******** $headers');

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => Appointment.fromJson(data)).toList();
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load appointments');
    }
  }
}
