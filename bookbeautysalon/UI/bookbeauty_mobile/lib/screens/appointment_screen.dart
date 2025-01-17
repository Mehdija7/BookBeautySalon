import 'package:book_beauty/models/appointment.dart';
import 'package:book_beauty/providers/appointment_provider.dart';
import 'package:book_beauty/widgets/appointment_card.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key, required this.userId});

  final int userId;

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late List<Appointment> _appointments = [];
  final AppointmentProvider _appointmentProvider = AppointmentProvider();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    print(
        "******************************************* FETCHING ****************************");
    try {
      var appointments =
          await _appointmentProvider.getAppointmentsByUser(widget.userId);
      print(
          "******************************************* APPOINTMENTS IN FETCHAPPOINTMENTS METHOD ****************************");
      print(appointments);
      setState(() {
        _appointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      print('Greska prilikom ucitavanja: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 190, 187, 168).withOpacity(0.4),
      child: Column(
        children: [
          const MainTitle(title: 'Termini'),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _appointments.isEmpty
                    ? Center(child: Text("Trenutno nema termina"))
                    : ListView.builder(
                        itemCount: _appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = _appointments[index];
                          String date = DateFormat('yyyy-MM-dd')
                              .format(appointment.dateTime!);
                          String time =
                              DateFormat('HH:mm').format(appointment.dateTime!);
                          bool isNew =
                              appointment.dateTime!.isAfter(DateTime.now());
                          return AppointmentCard(
                            service: appointment.service!.name!,
                            date: date,
                            time: time,
                            isNew: isNew,
                            price: appointment.service!.price!.toString(),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
