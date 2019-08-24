import 'package:flutter/material.dart';
import 'package:flutter_bloc_network/models/NetworkState.dart';

typedef StateWidgetBuilder<T> = Widget Function(BuildContext context, T value);

class NetworkStateWidget<T> extends StatelessWidget {
  final NetworkState<T> state;
  final Widget loading;
  final Widget error;
  final bool animateSwitch;
  final Widget uninitialized;
  final StateWidgetBuilder<T> builder;
  final Function initialize;

  const NetworkStateWidget(
    this.state, {
    Key key,
    this.loading,
    @required this.builder,
    this.initialize,
    this.animateSwitch = true,
    this.uninitialized,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is NetworkStateUninitialized && initialize != null) initialize();

    Widget widget = Container();
    if (loading != null &&
        (uninitialized == null || state is NetworkStateLoading)) {
      widget = loading;
    }
    if( uninitialized != null && state is NetworkStateUninitialized ) {
      widget = uninitialized;
    }
    if (state is NetworkStateSucceeded<T>) {
      widget = builder(context, (state as NetworkStateSucceeded<T>).response);
    } else if (state is NetworkStateFailed && error != null) {
      widget = error;
    }
    if( !this.animateSwitch ) {
      return widget;
    }

    return AnimatedSwitcher(
      child: widget,
      duration: Duration(milliseconds: 333),
    );
  }
}
