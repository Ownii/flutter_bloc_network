import 'package:flutter/material.dart';
import 'package:flutter_bloc_network_sample/bloc/UserBloc.dart';
import 'package:flutter_bloc_network_sample/services/UserService.dart';
import 'package:flutter_bloc_network_sample/widgets/UsersPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: UsersPage(title: 'flutter_bloc_network sample'),
      ),
      builder: (context) => UserBloc(UserService()),
    );
  }
}
