import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import './user_info.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationBloc>(
      builder: (context, authenticationBloc) => Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserInfo(),
                ListTile(
                  leading: Icon(
                    Feather.getIconData('log-out'),
                    color: SarakaColors.lightBlack,
                  ),
                  title: Text(
                    'Log out',
                    style: TextStyle(
                      color: SarakaColors.lightBlack,
                      fontFamily: SarakaFonts.rubik,
                    ),
                  ),
                  onTap: () => authenticationBloc.signOut(),
                ),
              ],
            ),
          ),
    );
  }
}
