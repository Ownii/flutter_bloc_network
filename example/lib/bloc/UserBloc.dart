import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_network/models/NetworkState.dart';
import 'package:flutter_bloc_network_sample/models/User.dart';
import 'package:flutter_bloc_network_sample/services/UserService.dart';

class UserState {
  final NetworkState<List<User>> users;
  final NetworkState createUser;

  UserState({this.users, this.createUser});

  UserState copyWith({
    NetworkState<List<User>> users,
    NetworkState<void> createUser,
  }) {
    return new UserState(
      users: users ?? this.users,
      createUser: createUser ?? this.createUser,
    );
  }
}

class UserEvent {}

class UserEventLoad extends UserEvent {}

class UserEventCreate extends UserEvent {
  final String username;
  final int age;

  UserEventCreate(this.username, this.age);
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService;

  UserBloc(this._userService);

  @override
  UserState get initialState => UserState(
        users: NetworkStateUninitialized(),
        createUser: NetworkStateUninitialized(),
      );

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserEventLoad) {
      yield state.copyWith(
        users: NetworkStateLoading(),
      );
      try {
        var users = await _userService.loadUsers();
        yield state.copyWith(
          users: NetworkStateSucceeded(users),
        );
      } catch (e) {
        yield state.copyWith(
          users: NetworkStateFailed(e),
        );
      }
    }

    if (event is UserEventCreate) {
      yield state.copyWith(
        createUser: NetworkStateLoading(),
      );
      try {
        await _userService.createUser(event.username, event.age);
        yield state.copyWith(
          createUser: NetworkStateSucceeded(null),
        );
        yield state.copyWith(
          createUser: NetworkStateUninitialized(),
        );
        add(UserEventLoad());
      } catch (e) {
        yield state.copyWith(
          createUser: NetworkStateFailed(e),
        );
      }
    }
  }
}
