import 'package:bookbeauty_desktop/models/appointment.dart';

import 'base_provider.dart';

class AppointmentProvider extends BaseProvider<Appointment> {
  AppointmentProvider() : super("Appointment");

  @override
  Appointment fromJson(data) {
    return Appointment.fromJson(data);
  }
}
