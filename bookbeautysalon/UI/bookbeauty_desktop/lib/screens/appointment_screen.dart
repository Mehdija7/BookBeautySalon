import 'package:bookbeauty_desktop/models/appointment.dart';
import 'package:bookbeauty_desktop/models/event.dart';
import 'package:bookbeauty_desktop/models/user.dart';
import 'package:bookbeauty_desktop/providers/appointment_provider.dart';
import 'package:bookbeauty_desktop/providers/user_provider.dart';
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
  UserProvider userProvider = UserProvider();

  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    appointmentProvider = context.read<AppointmentProvider>();
    selectedEvents = {};
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      var result = await appointmentProvider.fetchAppointments();
      setState(() {
        allAppointments = result;
        _filterAppointments();
      });
    } catch (e) {
      print("Error fetching appointments: $e");
    }
  }



    void _filterAppointments() async{
  selectedEvents = {};
  var helpList = allAppointments.where((i) =>
      (i.dateTime!.year == selectedDay.year) &&
      (i.dateTime!.month == selectedDay.month) &&
      (i.dateTime!.day == selectedDay.day)).toList();


  helpList.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

  for (var appointment in helpList) {
    DateTime appointmentDate = DateTime(
      appointment.dateTime!.year,
      appointment.dateTime!.month,
      appointment.dateTime!.day,
    );
    User u = await userProvider.getById(appointment.hairdresserId!);
    String formattedDate = DateFormat('HH:mm').format(appointment.dateTime!);
    Event event = Event(title: '${appointment.service!.name} at $formattedDate |note: ${appointment.note} |hairdresser: ${u.firstName} ${u.lastName} ');

    selectedEvents.putIfAbsent(appointmentDate, () => []).add(event);
  }

  setState(() {});
  }

  List<Event> _getEventsfromDay(DateTime date) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    return selectedEvents[normalizedDate] ?? [];
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
            TableCalendar<Event>(
              focusedDay: selectedDay,
              firstDay: DateTime(2020),
              lastDay: DateTime(2050),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat newFormat) {
                setState(() {
                  format = newFormat;
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
       calendarStyle: const CalendarStyle(
  isTodayHighlighted: true,

  selectedDecoration: BoxDecoration(
    color: Colors.blueGrey,
    shape: BoxShape.circle,
  ),
  selectedTextStyle: TextStyle(color: Colors.white),

  todayDecoration: BoxDecoration(
    color: Color.fromARGB(255, 105, 108, 110),
    shape: BoxShape.circle,
  ),

  defaultDecoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Color.fromARGB(255, 179, 209, 216),
  ),

  weekendDecoration: BoxDecoration(
    color: Color.fromARGB(255, 230, 230, 230),
    shape: BoxShape.circle,
  ),

  outsideDecoration: BoxDecoration(
    color: Colors.transparent,
    shape: BoxShape.circle,
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
                  margin: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 15),
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
