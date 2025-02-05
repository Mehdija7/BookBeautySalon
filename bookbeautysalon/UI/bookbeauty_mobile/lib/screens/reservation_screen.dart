import 'dart:convert';
import 'package:book_beauty/models/appointment.dart';
import 'package:book_beauty/models/service.dart';
import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/providers/appointment_provider.dart';
import 'package:book_beauty/providers/auth_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/time_widget.dart';

final formater = DateFormat('dd/MM/yyyy');

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key, required this.service});

  final Service service;

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? _selectedDate;
  int? _selectedHairdresser;
  final TextEditingController _noteController = TextEditingController();
  final UserProvider userProvider = UserProvider();
  final AppointmentProvider appointmentProvider = AppointmentProvider();
  List<User> _hairdressers = [];
  List<TimeOfDay> _availableAppointments = [];
  TimeOfDay? _selectedTime;
  bool _isDateValid = true;
  bool _isHairdresserValid = true;
  bool _isTimeValid = true;

  @override
  void initState() {
    super.initState();
    _fetchHairdressers();
  }

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

  _fetchHairdressers() async {
    var result = await userProvider.getHairdressers();
    setState(() {
      _hairdressers = result;
    });
    print(
        '++++++++++++++++++++++++ HAIRDRESSERS ++++++++++++++++++++++++++++++++++++');
    print(result);
  }

  _fetchAvailableAppointments() async {
    if (_selectedDate != null) {
      Appointment appointment = Appointment(
        dateTime: _selectedDate,
        userId: UserProvider.globalUserId,
        serviceId: widget.service.serviceId,
        hairdresserId: _selectedHairdresser,
        note: _noteController.text,
      );

      print('******************  SELECTED DATE *************************');
      print(_selectedDate);
      print(appointment.dateTime);

      var result =
          await appointmentProvider.getAvailableAppointments(appointment);
      print(
          '+++++++++++++++++++++++++  RESULTS TTIMEEEEE +++++++++++++++++++++++++++++++++');
      setState(() {
        _availableAppointments = result;
      });
    } else {
      return;
    }
  }

  void _presentDatePicker() async {
    if (_selectedHairdresser == null) {
      _showHairdresserAlert();
      return;
    }
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
            primary: Color(0xFF93BBBB),
          ),
        ),
        child: child!,
      ),
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _presentTimePicker() async {
    print(
        " *******************     METHOD PRESENT TIME PICKER                 **************************************** ");
    await _fetchAvailableAppointments();
    if (_availableAppointments.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Greška'),
              content: const Text(
                  'Za odabrani datum nema slobodnih termina. Pokušajte promijeniti frizera ili datum.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('ok'),
                ),
              ],
            );
          });
    } else {
      TimeOfDay? pickedTime = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Odaberite vrijeme'),
            children: _availableAppointments.map((TimeOfDay time) {
              return SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, time);
                },
                child: Text(time.format(context)),
              );
            }).toList(),
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedTime = pickedTime;
        });
      }
    }
  }

  void _showHairdresserAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Greška'),
          content: const Text(
              'Potrebno je odabrati frizera prije nego se odabere datum.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF73878E),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              _buildHairdresserDropdown(),
              const SizedBox(height: 20),
              _buildDateSection(),
              const SizedBox(height: 20),
              _buildTimeSection(),
              const SizedBox(height: 20),
              _buildReserveButton(),
            ],
          ),
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
              hintText: 'Ovdje upišite zahtjeve', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        ),
        if (!_isDateValid && _selectedDate == null)
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(
              'Polje datum je obavezno.',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Vrijeme: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(_selectedTime == null
                ? 'Niste odabrali vrijeme'
                : _selectedTime!.format(context)),
            IconButton(
              onPressed: _presentTimePicker,
              icon: const Icon(Icons.access_time),
              color: const Color(0xFF93BBBB),
            ),
          ],
        ),
        if (!_isTimeValid && _selectedTime == null)
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(
              'Polje vrijeme je obavezno.',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
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
        DropdownButton<int?>(
          value: _selectedHairdresser,
          isExpanded: true,
          hint: const Text('Odaberite frizera'),
          items: _hairdressers.map((User hairdresser) {
            return DropdownMenuItem<int>(
              value: hairdresser.userId,
              child: Text('${hairdresser.firstName} ${hairdresser.lastName}'),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedHairdresser = newValue;
              _isHairdresserValid = newValue != null;
            });
          },
        ),
        if (!_isHairdresserValid)
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(
              'Polje frizer je obavezno.',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget _buildReserveButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 233, 222, 222),
          fixedSize: const Size(150, 60),
        ),
        onPressed: () {
          reserve();
        },
        child: const Text('Rezerviši',
            style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
      ),
    );
  }

  void reserve() async {
    setState(() {
      _isDateValid = _selectedDate != null;
      _isTimeValid = _selectedTime != null;
      _isHairdresserValid = _selectedHairdresser != null;
    });

    if (!_isDateValid || !_isTimeValid || !_isHairdresserValid) {
      return;
    }

    DateTime date = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm").format(date);

    var userid = UserProvider.getUserId;

    String d = DateTime.parse(formattedDate).toIso8601String();
    print('&&&&&&&&&&&&&&&&&&&&& USER ID &&&&&&&&&&&&&&&&&&&&&&&&&');
    print(userid);

    Appointment appointment = Appointment(
      dateTime: DateTime.parse(d),
      userId: userid,
      serviceId: widget.service.serviceId,
      note:
          _noteController.text.isEmpty ? 'bez napomene' : _noteController.text,
      hairdresserId: _selectedHairdresser,
    );
    print('&&& appointment &&&&');
    print(appointment);
    print(appointment.dateTime);
    print(appointment.userId);
    print(appointment.serviceId);
    print(appointment.note);
    print(appointment.hairdresserId);
    var response = await appointmentProvider.insert(appointment);

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uspješno ste rezervirali termin.'),
          backgroundColor: Colors.green,
        ),
      );
      clearData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Neuspješno rezerviranje termina.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void clearData() {
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
      _selectedHairdresser = null;
      _noteController.clear();
      _availableAppointments.clear();

      _isDateValid = true;
      _isTimeValid = true;
      _isHairdresserValid = true;
    });
  }
}
