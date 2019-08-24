import 'package:flutter_bloc_network_sample/models/User.dart';

class UserService {

  List<User> users = [
    User("Paul", 28),
    User("Anna", 26),
  ];

  Future<List<User>> loadUsers() async {
    await Future.delayed(Duration(seconds: 5));
    return users;
  }

  Future<void> createUser(String username, int age) async {
    var user = User(username, age);
    await Future.delayed(Duration(seconds: 5));
    users.add(user);
  }
}