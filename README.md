# flutter_bloc_network

This package helps to manage network states used with [flutter_bloc](https://pub.dev/packages/flutter_bloc) by wrapping the loaded content into a NetworkState

## Sample

Check out the [sample project](./sample) that shows how to load users async and show the different NetworkStates

## Getting Started

### Adding dependency

**Github**
```yml
dependencies:
  flutter_bloc_network:
    git:
      url: git://github.com/Ownii/flutter_bloc_network.git
      ref: v1.0
```

**pub.dev** dependency cooming soon...

## Basic Usage

### Bloc

In your initial state
```dart
  NetworkState<MyObject> myObject = NetworkStateUninitialized();
```

In Bloc -> mapEventToState
```dart
  yield currentState.copyWith({
    myObject: NetworkStateLoading();
  });
  try {
    MyObject result = await doNetworkStuff();
    yield currentState.copyWith({
      myObject: NetworkStateSucceeded(result);
    });
  } catch(e) {
    yield currentState.copyWith({
      myObject: NetworkStateFailed(e);
    });
  }
```

### Widget      

```dart
BlocNetworBuilder<MyBloc, MyState, MyEvent, MyObject>(
  getValue: (state) => state.myObject,
  loading: MyLoadingWidget(),
  initializeEvent: LoadMyObjectEvent(),
  error: MyErrorWidget(),
  builder: (BuildContext context, MyObject value) => MyWidget(value);
)
```

properties
```dart
Widget loading;                           // This widget gets shown if the state is NetworkStateLoading
Widget uninitialized;                     // this widget gets shown if state is NetworkStateUninitialized, if its not set the loading widget gets shown
bool animateSwitch;                       // Use AnimatedSwitcher on top
StateWidgetBuilder<T> builder;            // Builder gets called if state is NetworkStateSucceded
E initializeEvent;                          // this event gets dispatched if state is NetworkStateUninitialized
StateValueGetter<S, T> getValue;          // get the actual value from the BlocState
Widget error;                             // This widget gets shown if the state is NetworkStateFailed
Function(BuildContext, T) onSucceeded;    // This function gets called if the state changed to NetworkStateSucceeded
Function(BuildContext, dynamic) onFailed; // This function gets called if the state changed to NetworkStateFailed
```

## Usage with custom bloc or without bloc

You can use the **NetworkStateWidget** to use **NetworkState** without BlocBuilder. So you can use your own BlocBuilder or use it in different situations where you dont want a BlocBuilder.

### NetworkStateWidget

```dart
NetworkStateWidget<MyObject>(
  state: myNetworkStateObject,
  loading: MyLoadingWidget(),
  error: MyErrorWidget(),
  builder: (BuildContext context, MyObject value) => MyWidget(value),
  initialize: () {
    myService.startLoadingMyObject();
  }
)
```

```dart
NetworkState<T> state;          // the NetworkState object
Widget loading;                 // This widget gets shown if the state is
Widget error;                   // This widget gets shown if the state is NetworkStateFailed
bool animateSwitch;             // Use AnimatedSwitcher on top
Widget uninitialized;           // this widget gets shown if state is NetworkStateUninitialized, if its not set the loading widget gets shownStateWidgetBuilder<T> builder;  // Builder gets called if state is NetworkStateSucceded
Function initialize;            // this function gets called if state is NetworkStateUninitialized
```

## NetworkState without data

If you wanna represent a NetworkCall that has no response/data you can simply pass void as generic type and pass null for your NetworkStateSucceeded

Keep in mind to not use the passed value in your builder or onSucceeded Listener.

Check the [sample project](./sample) to see the usage.

In your initial state
```dart
NetworkState<void> callWithoutResponse = NetworkStateUninitialized();
```

In Bloc -> mapEventToState
```dart
yield currentState.copyWith(
  callWithoutResponse: NetworkStateLoading(),
);
try {
  await _userService.createUser(event.username, event.age);
  yield currentState.copyWith(
    callWithoutResponse: NetworkStateSucceeded(null),
  );
} catch(e) {
  yield currentState.copyWith(
    callWithoutResponse: NetworkStateFailed(e),
  );
}
```

in your widget
```dart
BlocNetworkBuilder<MyBloc, MyState, MyEvent, void>(
  getValue: (state) => state.callWithoutResponse,
  builder: (context, value) => MySucceededWidget(), // dont use value (its null)
  loading: MyLoadingWidget(),
  error: MyErrorWidget(),
  initializeEvent: DoMyNetworkCallEvent(),
)
```
