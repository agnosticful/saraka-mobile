import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../../blocs/authentication_bloc.dart';
import './privacy_policy_item.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationBloc>(
      builder: (context, authenticationBloc) => Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                authenticationBloc == null
                    ? DrawerHeader(child: Container())
                    : StreamBuilder<User>(
                        stream: authenticationBloc.user,
                        builder: (context, snapshot) =>
                            UserAccountsDrawerHeader(
                              decoration: BoxDecoration(
                                color: SarakaColors.lightRed,
                              ),
                              currentAccountPicture: CircleAvatar(
                                backgroundImage: snapshot.hasData
                                    ? NetworkImage(snapshot.requireData.imageUrl
                                        .toString())
                                    : AssetImage(
                                        'assets/default_images/user.png'),
                              ),
                              accountName: Text(
                                snapshot.hasData
                                    ? snapshot.requireData.name
                                    : 'Loading...',
                                style: TextStyle(
                                  fontFamily: SarakaFonts.rubik,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              accountEmail: Text(
                                snapshot.hasData
                                    ? snapshot.requireData.email
                                    : 'Loading...',
                                style: TextStyle(
                                  fontFamily: SarakaFonts.rubik,
                                ),
                              ),
                            ),
                      ),
                PrivacyPolicyItem(),
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
