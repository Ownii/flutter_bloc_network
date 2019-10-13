/// Top level NetworkState with [T] as possible value type
abstract class NetworkState<T> {}

/// Starting point for NetworkState if there is no value and no progress
class NetworkStateUninitialized<T> extends NetworkState<T> {}

/// Represents that the value is currently loading
class NetworkStateLoading<T> extends NetworkState<T> {}

/// Value is loaded and available in [response]
class NetworkStateSucceeded<T> extends NetworkState<T> {
  final T response;

  NetworkStateSucceeded(this.response);
}

/// Loading failed and the occured error is available in [error]
class NetworkStateFailed<T> extends NetworkState<T> {
  final dynamic error;

  NetworkStateFailed(this.error);
}
