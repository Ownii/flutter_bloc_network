import 'package:flutter/material.dart';
import 'package:flutter_bloc_network/widgets/BlocNetworkBuilder.dart';
import 'package:flutter_bloc_network_sample/bloc/UserBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUserDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  String username = "";
  String age = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add user",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: "Name"),
                    onChanged: (value) {
                      this.username = value;
                    },
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    decoration: InputDecoration(hintText: "Age"),
                    onChanged: (value) {
                      this.age = value;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            BlocNetworkBuilder<UserBloc, UserState, UserEvent, void>(
              getValue: (state) => state.createUser,
              builder: (context, value) => Container(),
              uninitialized: buildActions(context),
              loading: buildLoading(context),
              onSucceeded: (context, value) {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActions(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            onPressed: () {
              BlocProvider.of<UserBloc>(context).dispatch(
                UserEventCreate(
                  this.username,
                  int.parse(this.age),
                ),
              );
            },
            child: Text("ADD"),
          )
        ],
      );

  Widget buildLoading(BuildContext context) => Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
}
