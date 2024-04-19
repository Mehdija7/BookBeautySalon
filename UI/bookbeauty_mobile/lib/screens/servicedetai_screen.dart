import 'package:book_beauty/screens/reservation_screen.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen(
      {super.key, required this.service, required this.image});

  final String service;
  final String image;

  @override
  Widget build(BuildContext context) {
    void goToReservation() {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (ctx) => ReservationScreen(service: service)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(''),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainTitle(title: service),
            const SizedBox(height: 14),
            Hero(
              tag: UniqueKey(),
              child: Image.asset(
                image,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 219, 226, 230),
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5, top: 15, bottom: 20),
                    child: Column(
                      children: [
                        Text(
                          'Ukoliko želite skratiti kosu u potpunitosti ili ipak samo vrhove, a možda probati i nešto drugačije, rezervišite svoj termin i naše drage frizerke će ispuniti vaša očekivanja.',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Prilikom odabira termina u rubrici napomena birate da li ćete šišanjem apartom ili makazicama, vašu dužinu kose i koliko želite da se ošišate i kojeg frizera biste htjeli.',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                              const Size(150, 60),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 31, 30, 30),
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 245, 245, 245)),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return const Color.fromARGB(185, 48, 49, 49)
                                      .withOpacity(0.04);
                                }
                                if (states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed)) {
                                  return const Color.fromARGB(
                                          214, 126, 129, 131)
                                      .withOpacity(0.12);
                                }
                                return null;
                              },
                            ),
                          ),
                          onPressed: goToReservation,
                          child: const Text(
                            'Rezerviši termin',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
