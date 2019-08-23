abstract class NetworkState<T> {
}

class NetworkStateUninitialized<T> extends NetworkState<T> {

}

class NetworkStateLoading<T> extends NetworkState<T> {

}

class NetworkStateSucceeded<T> extends NetworkState<T> {
  final T response;

  NetworkStateSucceeded(this.response);
}

class NetworkStateFailed<T> extends NetworkState<T> {
    final dynamic error;

  NetworkStateFailed(this.error);
}
