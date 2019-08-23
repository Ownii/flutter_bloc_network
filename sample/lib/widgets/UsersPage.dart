import 'package:flutter/material.dart';
import 'package:flutter_bloc_network/widgets/BlocNetworkStateBuilder.dart';
import 'package:flutter_bloc_network_sample/bloc/UserBloc.dart';
import 'package:flutter_bloc_network_sample/models/User.dart';
import 'package:flutter_bloc_network_sample/widgets/UsersList.dart';

class UsersPage extends StatefulWidget {
  UsersPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocNetworkStateBuilder<UserBloc, UserState, UserEvent, List<User>>(
        getValue: (state) => state.users,
        loading: Center(
          child: CircularProgressIndicator(),
        ),
        error: Center(
          child: Text("Something went wrong"),
        ),
        initializeEvent: UserEventLoad(),
        builder: (context, users) => UsersList(users: users),
      ),
    );
  }
}
