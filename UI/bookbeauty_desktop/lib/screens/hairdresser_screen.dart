import 'package:bookbeauty_desktop/models/user.dart';
import 'package:bookbeauty_desktop/providers/user_provider.dart';
import 'package:bookbeauty_desktop/screens/addhairdresser_screen.dart';
import 'package:flutter/material.dart';

class HairdresserScreen extends StatefulWidget {
  const HairdresserScreen({super.key});

  @override
  _HairdresserScreenState createState() => _HairdresserScreenState();
}

class _HairdresserScreenState extends State<HairdresserScreen> {
  UserProvider provider = UserProvider();
  List<User> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      var u = await provider.getHairdressers();
      setState(() {
        users = u;
      });
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _deleteUser(int id) async {
    try {
      await provider.deleteUserRoles(id);
      await provider.delete(id);
      _fetchUsers();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.95, // Stretch table width
                    child: DataTable(
                      columnSpacing: 20.0, // Adjust spacing between columns
                      columns: const [
                        DataColumn(label: Text('Ime')),
                        DataColumn(label: Text('Prezime')),
                        DataColumn(label: Text('Korisnicko ime')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Broj telefona')),
                        DataColumn(label: Text('Adresa')),
                        DataColumn(label: Text('Izbrisi')),
                      ],
                      rows: users.map((hairdresser) {
                        return DataRow(cells: [
                          DataCell(Text(hairdresser.firstName ?? 'N/A')),
                          DataCell(Text(hairdresser.lastName ?? 'N/A')),
                          DataCell(Text(hairdresser.username ?? 'N/A')),
                          DataCell(Text(hairdresser.email ?? 'N/A')),
                          DataCell(Text(hairdresser.phone ?? 'N/A')),
                          DataCell(Text(hairdresser.address ?? 'N/A')),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteUser(hairdresser.userId!);
                              print('Delete ${hairdresser.firstName}');
                            },
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHairdresserScreen(),
            ),
          );

          if (result == true) {
            _fetchUsers();
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Bottom-right corner
    );
  }
}
