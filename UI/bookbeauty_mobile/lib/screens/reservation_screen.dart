import 'package:book_beauty/widgets/buy_button.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:book_beauty/widgets/time_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/team_grid_item.dart';
import 'teamdetail_screen.dart';
import 'package:intl/intl.dart';

final formater = DateFormat('dd/MM/yyyy');

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key, required this.service});

  final String service;

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  bool _decideWhichDayToEnable(DateTime day) {
    DateTime event = DateTime(2024, 3, 26);
    DateTime event2 = DateTime(2024, 3, 28);
    if (day.isAtSameMomentAs(event) ||
        day.isAtSameMomentAs(event2) ||
        day.isAtSameMomentAs(DateTime.now())) {
      return false;
    }
    if (day.weekday == 7) {
      return false;
    }
    return true;
  }

  DateTime? _selectedDate;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final firstdate = DateTime(now.year, now.month, now.day);
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
          colorScheme: ColorScheme.light(
            primary: Color.fromARGB(255, 147, 187, 189),
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
    void selectingPerson(String name) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) =>
              TeamDetailScreen(name: name, image: 'assets/images/sisanje.webp'),
        ),
      );
    }

    TextEditingController textEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const MainTitle(title: 'Rezervacija'),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 10, top: 25),
            child: Row(children: [
              const Text(
                'Usluga: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                ),
                width: 180,
                child: Text(
                  widget.service,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 75, 73, 73)),
                ),
              ),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Napomena:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: textEditingController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Ovdje upisite zahtjeve',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Termin: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(_selectedDate == null
                    ? 'Niste odabrali datum'
                    : formater.format(_selectedDate!)),
                IconButton(
                  onPressed: () {
                    _presentDatePicker();
                  },
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimeWidget(
                isDateSelected: _selectedDate == null ? false : true,
              ),
              TimeWidget(
                isDateSelected: _selectedDate == null ? false : true,
              ),
              TimeWidget(
                isDateSelected: _selectedDate == null ? false : true,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Frizer:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: [
                TeamGridItem(
                    name: 'Ajla',
                    image: 'assets/images/sisanje.webp',
                    onSelectPerson: selectingPerson),
                TeamGridItem(
                    name: 'Ajla Ajlic',
                    image: 'assets/images/sisanje.webp',
                    onSelectPerson: selectingPerson),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(
                  const Size(150, 60),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 31, 30, 30),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 245, 245, 245)),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return const Color.fromARGB(185, 48, 49, 49)
                          .withOpacity(0.04);
                    }
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed)) {
                      return const Color.fromARGB(214, 126, 129, 131)
                          .withOpacity(0.12);
                    }
                    return null;
                  },
                ),
              ),
              onPressed: () {},
              child: const Text(
                'Rezerviši',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
