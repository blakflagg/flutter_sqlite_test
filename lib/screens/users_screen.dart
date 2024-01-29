import 'package:flutter/material.dart';
import '../services/database_helper.dart';

import '../models/user_model.dart';

class UsersScreen extends StatelessWidget {
  static const routeName = '/usersScreen';
  final _userNameTextController = TextEditingController();

  UsersScreen({super.key});

  void _printUsers() async {
    List<User>? list = await DatabaseHelper.getAllUsers();
    if (list == null) {
      print('No Users');
      return;
    }

    for (var user in list) {
      print("ID: ${user.id} user name: ${user.user_name}");
    }
  }

  void _printJoinedNotes() async {
    await DatabaseHelper.getNotesJoin(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _userNameTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      ),
                      label: Text('User Name'),
                    ),
                  ),
                ))
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    int count = await DatabaseHelper.getUserCount();
                    print(count);
                    var user = User(
                        user_name: _userNameTextController.value.text,
                        id: ++count);
                    await DatabaseHelper.addUser(user);
                  },
                  child: const Text('Add User'),
                ),
                ElevatedButton(
                  onPressed: _printUsers,
                  child: const Text('Print Users'),
                ),
                ElevatedButton(
                  onPressed: _printJoinedNotes,
                  child: const Text('Print Joined Notes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
