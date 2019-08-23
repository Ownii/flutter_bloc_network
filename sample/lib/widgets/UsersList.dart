import 'package:flutter/material.dart';
import 'package:flutter_bloc_network_sample/models/User.dart';

class UsersList extends StatelessWidget {
  final List<User> users;

  const UsersList({Key key, this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        var user = this.users[index];
        return ListTile(
          title: Text(user.username),
          subtitle: Text(user.age.toString() + " years old"),
        );
      },
    );
  }
}
