import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

class UserInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserInfo();
}

class _UserInfo extends State<UserInfo> {
  StreamSubscription _subscription;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final authenticationBloc = Provider.of<AuthenticationBloc>(context);
      _subscription = authenticationBloc.user.listen((user) async {
        await precacheImage(
          NetworkImage(user.imageUrl.toString()),
          context,
        );

        // print('-------------------------------');
        // print(ImageCache().currentSize);
        // print(user.imageUrl.toString());
        // print('-------------------------------');
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription ?? _subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<AuthenticationBloc>(
      builder: (context, authenticationBloc) => authenticationBloc == null
          ? DrawerHeader(child: Container())
          : StreamBuilder<User>(
              stream: authenticationBloc.user,
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
                  )));
}
