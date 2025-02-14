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
    try {
      var appointments =
          await _appointmentProvider.getAppointmentsByUser(widget.userId);
      setState(() {
        _appointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading appointments: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      backgroundColor: const Color(0xFFF1F1F1), // Lighter background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainTitle(title: 'Termini'),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context)
                            .primaryColor, // Change to app's primary color
                      ),
                    )
                  : _appointments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_busy,
                                  size: 50, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                "Nemate zakazanih termina.",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _appointments.length,
                          itemBuilder: (context, index) {
                            final appointment = _appointments[index];
                            String date = DateFormat('yyyy-MM-dd')
                                .format(appointment.dateTime!);
                            String time = DateFormat('HH:mm')
                                .format(appointment.dateTime!);
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
      ),
    );
  }
}
