import 'package:book_beauty/models/appointment.dart';
import 'package:book_beauty/models/service.dart';
import 'package:book_beauty/providers/appointment_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/widgets/buy_button.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:book_beauty/widgets/time_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/team_grid_item.dart';
import 'package:intl/intl.dart';

final formater = DateFormat('dd/MM/yyyy');

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key, required this.service});

  final Service service;

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? _selectedDate;
  String? _selectedHairdresser;
  final TextEditingController _noteController = TextEditingController();
  AppointmentProvider appointmentProvider = AppointmentProvider();
  UserProvider userProvider = UserProvider();

  final List<String> _hairdressers = [
    'Sara',
    'Faris',
    'Hana',
  ];

  bool _decideWhichDayToEnable(DateTime day) {
    DateTime event = DateTime(2024, 4, 26);
    DateTime event2 = DateTime(2024, 4, 28);
    if (day.isAtSameMomentAs(event) || day.isAtSameMomentAs(event2)) {
      return false;
    }
    if (day.weekday == 7) {
      return false;
    }
    return true;
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final firstdate = DateTime(now.year, now.month, now.day + 1);
    final pickedDate = await showDatePicker(
      helpText: 'Odaberi datum',
      cancelText: 'Odustani',
      confirmText: 'Odaberi',
      context: context,
      initialDate: firstdate,
      firstDate: firstdate,
      lastDate: lastDate,
      selectableDayPredicate: _decideWhichDayToEnable,
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF93BBBB), // Dusty blue color
          ),
        ),
        child: child!,
      ),
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF73878E), // Dusty blue/gray theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MainTitle(title: 'Rezervacija'),
            const SizedBox(height: 20),
            _buildServiceRow(),
            const SizedBox(height: 20),
            _buildNotesSection(_noteController),
            const SizedBox(height: 20),
            _buildDateSection(),
            const SizedBox(height: 20),
            _buildTimeSelection(),
            const SizedBox(height: 20),
            _buildHairdresserDropdown(),
            const Spacer(),
            _buildReserveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRow() {
    return Row(
      children: [
        const Text(
          'Usluga: ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[300],
          ),
          width: 180,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            widget.service.name!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Color(0xFF4B4949)),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Napomena:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Ovdje upišite zahtjeve',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Termin: ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(_selectedDate == null
            ? 'Niste odabrali datum'
            : formater.format(_selectedDate!)),
        IconButton(
          onPressed: _presentDatePicker,
          icon: const Icon(Icons.calendar_today),
          color: const Color(0xFF93BBBB),
        ),
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TimeWidget(isDateSelected: _selectedDate != null),
        TimeWidget(isDateSelected: _selectedDate != null),
        TimeWidget(isDateSelected: _selectedDate != null),
      ],
    );
  }

  Widget _buildHairdresserDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frizer:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: _selectedHairdresser,
          isExpanded: true,
          hint: const Text('Odaberite frizera'),
          items: _hairdressers.map((String hairdresser) {
            return DropdownMenuItem<String>(
              value: hairdresser,
              child: Text(hairdresser),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedHairdresser = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildReserveButton() {
    return Center(
      child: TextButton(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all<Color>(const Color(0xFF4F4F4F)),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          fixedSize: WidgetStateProperty.all(const Size(150, 60)),
        ),
        onPressed: () {
          reserve();
        },
        child: const Text('Rezerviši', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  void reserve() async {
    Appointment appointment = Appointment(
      dateTime: _selectedDate,
      userId: 1,
      serviceId: widget.service.serviceId,
      note: _noteController.text,
    );
  }
}
