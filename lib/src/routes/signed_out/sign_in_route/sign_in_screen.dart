import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/widgets.dart';
import './sign_in_button.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        child: Stack(
          children: [
            FlareActor(
              "assets/flare/Mountain.flr",
              alignment: Alignment.center,
              fit: BoxFit.cover,
              animation: "rotate",
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 128, horizontal: 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SignInButton(),
                ],
              ),
            ),
          ],
        ),
      );
}
