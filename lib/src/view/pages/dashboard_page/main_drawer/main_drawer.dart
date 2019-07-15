import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import './privacy_policy_item.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationBloc>(
      builder: (context, authenticationBloc, _) => Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(child: Container()),
                PrivacyPolicyItem(),
                ListTile(
                  leading: Icon(
                    Feather.getIconData('log-out'),
                    color: SarakaColor.lightBlack,
                  ),
                  title: Text(
                    'Log out',
                    style: SarakaTextStyle.body,
                  ),
                  onTap: () => authenticationBloc.signOut(),
                ),
              ],
            ),
          ),
    );
  }
}
