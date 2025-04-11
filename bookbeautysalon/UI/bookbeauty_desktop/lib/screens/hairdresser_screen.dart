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
      print(users);
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _deleteUser(int id) async {
    setState(
      () {
        isLoading = true;
      },
    );
    try {
      await provider.deleteUserRoles(id);
      await provider.delete(id);
    } catch (e) {
      print(e);
    }
    _fetchUsers();
  }

  void _showDeleteDialog(int userId, String firstName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm deleting'),
        content:
            Text('Are you sure about deleting hairdresser $firstName?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _deleteUser(userId);
              Navigator.of(ctx).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
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
                    width: MediaQuery.of(context).size.width, 
                    child: DataTable(
                      columnSpacing: 20.0, 
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Lastname')),
                        DataColumn(label: Text('Username')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Telephone number')),
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('Delete')),
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
                              _showDeleteDialog(
                                  hairdresser.userId!, hairdresser.firstName!);
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
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, 
    );
  }
}
