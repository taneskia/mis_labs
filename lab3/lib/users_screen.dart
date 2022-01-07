import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab3/user.dart';
import 'package:lab3/user_service.dart';

import 'exam.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final GlobalKey<_UsersState> usersStateKey = GlobalKey<_UsersState>();
  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            onPressed: _isButtonDisabled ? null : _addUser,
            icon: const Icon(Icons.add_circle),
            iconSize: 40,
          ),
        ],
      ),
      body: Users(
        key: usersStateKey,
        enableButton: setButtonDisabled,
      ),
    );
  }

  void _addUser() {
    usersStateKey.currentState?.addUser();
  }

  void setButtonDisabled(bool enabled) {
    setState(() {
      _isButtonDisabled = !enabled;
    });
  }
}

class Users extends StatefulWidget {
  final void Function(bool enabled) enableButton;

  const Users({Key? key, required this.enableButton}) : super(key: key);

  @override
  _UsersState createState() => _UsersState(enableButton);
}

class _UsersState extends State<Users> {
  final _textController = TextEditingController();
  String? userName;
  final void Function(bool enabled) enableButton;
  late UserService userService;
  late List<User> users;

  _UsersState(this.enableButton) {
    userService = UserService();
    users = userService.users;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0),
      child: Column(children: [
        Card(
          elevation: 7.0,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Title(
                    color: Colors.black,
                    child: const Text(
                      "Add new user",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: "User name",
                  ),
                  controller: _textController,
                  onChanged: _textChanged,
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _userSelected(users[index].name),
                  child: Card(
                    elevation: 3,
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            users[index].name,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ]),
    );
  }

  void addUser() {
    userService.addUser(userName!);
    setState(() {
      users = userService.users;
      userName = null;
    });
    _textController.clear();
    enableButton(false);
  }

  void _textChanged(String value) {
    setState(() {
      userName = _textController.value.text;
    });
    if (userName != null) {
      enableButton(true);
    } else {
      enableButton(false);
    }
  }

  void _userSelected(String name) {
    Navigator.pop(context, name);
  }
}
