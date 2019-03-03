import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/domains.dart';
import './new_card_floating_action_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: NewCardFloatingActionButton(),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 64, horizontal: 32),
          decoration: BoxDecoration(
            color: SarakaColors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RaisedButton(
                onPressed: () {
                  Provider.of<Authentication>(context).signOut();
                },
                child: Text('aaaa'),
              ),
            ],
          ),
        ),
      );
}
