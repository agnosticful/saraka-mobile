import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import './sign_in_button.dart';

class SignedOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: SarakaColors.white,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 192,
                    height: 192,
                    child: Image.asset('assets/images/saraka.png'),
                  ),
                  SizedBox(height: 32),
                  Text(
                    "Saraka",
                    style: SarakaTextStyles.heading.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: SarakaColors.lightRed,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Learn by practice.",
                    style: SarakaTextStyles.body.copyWith(
                      fontSize: 16,
                      color: SarakaColors.lightRed,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 128,
              left: 64,
              right: 64,
              child: SignInButton(),
            ),
          ],
        ));
  }
}
