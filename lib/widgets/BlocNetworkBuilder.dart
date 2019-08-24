import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_network/models/NetworkState.dart';
import 'package:flutter_bloc_network/widgets/NetworkStateWidget.dart';

typedef StateValueGetter<S, T> = NetworkState<T> Function(S state);

class BlocNetworkBuilder<B extends Bloc<E, S>, S, E, T>
    extends StatelessWidget {
  final Widget loading;
  final Widget uninitialized;
  final bool animateSwitch;
  final StateWidgetBuilder<T> builder;
  final E initializeEvent;
  final StateValueGetter<S, T> getValue;
  final Widget error;
  final Function(BuildContext, T) onSucceeded;
  final Function(BuildContext, dynamic) onFailed;

  const BlocNetworkBuilder(
      {Key key,
      this.loading,
      @required this.builder,
      this.initializeEvent,
      this.animateSwitch = true,
      @required this.getValue,
      this.uninitialized,
      this.error,
      this.onSucceeded,
      this.onFailed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var blocBuilder = BlocBuilder<B, S>(
      builder: (context, state) => NetworkStateWidget<T>(
        getValue(state),
        loading: this.loading,
        builder: this.builder,
        initialize: () {
          BlocProvider.of<B>(context)..dispatch(initializeEvent);
        },
        animateSwitch: this.animateSwitch,
        uninitialized: this.uninitialized,
        error: this.error,
      ),
    );

    if (this.onSucceeded != null || this.onFailed != null) {
      return BlocListener<B, S>(
        listener: (BuildContext context, S state) {
          if (getValue(state) is NetworkStateSucceeded &&
              this.onSucceeded != null) {
            this.onSucceeded(context,
                (getValue(state) as NetworkStateSucceeded<T>).response);
          } else if (getValue(state) is NetworkStateFailed &&
              this.onFailed != null) {
            this.onFailed(
                context, (getValue(state) as NetworkStateFailed).error);
          }
        },
        condition: (prevState, curState) =>
            getValue(prevState) != getValue(curState) &&
            (getValue(curState) is NetworkStateSucceeded ||
                getValue(curState) is NetworkStateFailed),
        child: blocBuilder,
      );
    }
    return blocBuilder;
  }
}
