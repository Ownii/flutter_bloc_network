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
      yield currentState.copyWith(
        users: NetworkStateLoading(),
      );
      try {
        var users = await _userService.loadUsers();
        yield currentState.copyWith(
          users: NetworkStateSucceeded(users),
        );
      } catch (e) {
        yield currentState.copyWith(
          users: NetworkStateFailed(e),
        );
      }
    }

    if (event is UserEventCreate) {
      yield currentState.copyWith(
        createUser: NetworkStateLoading(),
      );
      try {
        await _userService.createUser(event.username, event.age);
        yield currentState.copyWith(
          createUser: NetworkStateSucceeded(null),
        );
        yield currentState.copyWith(
          createUser: NetworkStateUninitialized(),
        );
        dispatch(UserEventLoad());
      } catch (e) {
        yield currentState.copyWith(
          createUser: NetworkStateFailed(e),
        );
      }
    }
  }
}
