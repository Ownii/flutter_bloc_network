# flutter_bloc_network

This package helps to manage network states used with flutter_bloc

## Getting Started


### Adding dependency
```yml
dependencies:
  flutter_bloc_network:
    git:
      url: git://github.com/Ownii/flutter_bloc_network.git
```
      
## Usage

### Bloc

In state
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

```dart

```

### Widget      

```dart
BlocNetworkStateBuilder<MyBloc, MyState, MyEvent, MyObject>(
  getValue: (state) => state.myObject,
  loading: MyLoadingWidget(),
  initializeEvent: LoadMyObjectEvent(),
  error: MyErrorWidget(),
  builder: (BuildContext context, MyObject value) => MyWidget(value);
)
```

properties
```dart
  Widget loading; // This widget gets shown if the state is NetworkStateLoading
  bool loadingUninitialized; // Show the Loading widget if state is NetworkStateUninitialized
  bool animateSwitch; // Use AnimatedSwitcher on top
  StateWidgetBuilder<T> builder; // Builder gets called if state is NetworkStateSucceded
  E initializeEvent; // this event gets dispatched if state is NetworkStateUninitialized
  StateValueGetter<S, T> getValue; // get the actual value from the BlocState
  Widget error; // This widget gets shown if the state is NetworkStateFailed
  Function(BuildContext, T) onSucceeded; // This function gets called if the state changed to NetworkStateSucceeded
  Function(BuildContext, dynamic) onFailed; // This function gets called if the state changed to NetworkStateFailed
```