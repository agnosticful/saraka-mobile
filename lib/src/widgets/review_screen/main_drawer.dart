import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class MainDrawer extends StatefulWidget {
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  AuthenticationBloc _authenticationBloc;

  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final authenticationBloc = Provider.of<AuthenticationBloc>(context);

      setState(() {
        _authenticationBloc = authenticationBloc;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _authenticationBloc == null
              ? DrawerHeader(child: Container())
              : StreamBuilder<User>(
                  stream: _authenticationBloc.user,
                  builder: (context, snapshot) => UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: SarakaColors.lightRed,
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: snapshot.hasData
                              ? NetworkImage(
                                  snapshot.requireData.imageUrl.toString())
                              : AssetImage('assets/default_images/user.png'),
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
            onTap: _onTap,
          ),
        ],
      ),
    );
  }

  void _onTap() {
    final authenticationBloc = Provider.of<AuthenticationBloc>(context);

    authenticationBloc.signOut();
  }
}
