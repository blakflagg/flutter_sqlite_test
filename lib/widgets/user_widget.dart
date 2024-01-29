import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserWidget extends StatelessWidget {
  final User user;
  const UserWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("User: ${user.user_name}"),
    );
  }
}
