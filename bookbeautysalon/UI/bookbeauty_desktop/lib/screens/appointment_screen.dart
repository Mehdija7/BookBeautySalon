import 'package:bookbeauty_desktop/models/appointment.dart';
import 'package:bookbeauty_desktop/models/event.dart';
import 'package:bookbeauty_desktop/providers/appointment_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  _AppointmentScreen createState() => _AppointmentScreen();
}

class _AppointmentScreen extends State<AppointmentScreen> {
  late AppointmentProvider appointmentProvider;
  late Map<DateTime, List<Event>> selectedEvents;
  late List<Appointment> allAppointments;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    appointmentProvider = context.read<AppointmentProvider>();
    _fetchAppointments();
    selectedEvents = {};
    super.initState();
  }

  Future<void> _fetchAppointments() async {
    try {
      print("Fetching appointments...");
      var result = await appointmentProvider.fetchAppointments();
      List<Appointment> list = result;
      setState(() {
        allAppointments = list;
        _filterAppointments();
      });
    } catch (e) {
      print("Error fetching appointments: $e");
    }
  }

  void _filterAppointments() {
    print("Filtering appointments...");
    selectedEvents = {};
    var helpList = allAppointments
        .where((i) =>
            (i.dateTime!.year == selectedDay.year) &&
            (i.dateTime!.month == selectedDay.month) &&
            (i.dateTime!.day == selectedDay.day))
        .toList();
    for (var appointment in helpList) {
      print(
          "Appointment found: ${appointment.service!.name} on ${appointment.dateTime}");
      DateTime appointmentDate = DateTime(
        appointment.dateTime!.year,
        appointment.dateTime!.month,
        appointment.dateTime!.day,
      );
      String formattedDate = DateFormat('HH:mm').format(appointment.dateTime!);
      Event event =
          Event(title: '${appointment.service!.name} u  $formattedDate');

      if (selectedEvents[appointmentDate] == null) {
        selectedEvents[appointmentDate] = [];
      }

      selectedEvents[appointmentDate]!.add(event);
    }
    setState(() {});

    return;
  }

  List<Event> _getEventsfromDay(DateTime date) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    List<Event> events = selectedEvents[normalizedDate] ?? [];
    return events;
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments calendar"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime(2020),
              lastDay: DateTime(2050),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat format) {
                setState(() {
                  format = format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              daysOfWeekVisible: true,
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                });
                _filterAppointments();
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },
              eventLoader: _getEventsfromDay,
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: const BoxDecoration(
                  color: Colors.blueGrey, 
                  shape: BoxShape.circle, 
                ),
                selectedTextStyle: const TextStyle(color: Colors.white),
                todayDecoration: const BoxDecoration(
                  color: Color.fromARGB(255, 105, 108, 110),
                  shape: BoxShape.circle, 
                ),
                defaultDecoration: const BoxDecoration(
                  shape: BoxShape.circle, 
                  color: Color.fromARGB(
                      255, 179, 209, 216), 
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: const Color.fromARGB(255, 144, 147, 150),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ..._getEventsfromDay(selectedDay).map(
              (Event event) => ListTile(
                title: Card(
                  color: const Color.fromARGB(255, 235, 235, 235),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 44, 43, 43),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
