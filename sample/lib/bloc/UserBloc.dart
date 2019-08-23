import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_network/models/NetworkState.dart';
import 'package:flutter_bloc_network_sample/models/User.dart';
import 'package:flutter_bloc_network_sample/services/UserService.dart';

class UserState {
  final NetworkState<List<User>> users;

  UserState({this.users});

  UserState copyWith({
    NetworkState<List<User>> users,
  }) {
    return new UserState(
      users: users ?? this.users,
    );
  }
}

class UserEvent {}

class UserEventLoad extends UserEvent {}

class UserBloc extends Bloc<UserEvent, UserState> {

  final UserService _userService;

  UserBloc(this._userService);

  @override
  UserState get initialState => UserState(
        users: NetworkStateUninitialized(),
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
      } catch(e) {
        yield currentState.copyWith(
          users: NetworkStateFailed(e),
        );
      }
    }
  }
}
