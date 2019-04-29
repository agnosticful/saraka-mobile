import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import './sign_in_button.dart';

class SignedOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SarakaColors.white,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 64),
                  SizedBox(
                    width: constraints.maxWidth * .5,
                    height: constraints.maxWidth * .5,
                    child: Image.asset('assets/images/parrot.png'),
                  ),
                  SizedBox(height: 32),
                  Text(
                    "Parrot",
                    style: SarakaTextStyles.heading.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: SarakaColors.lightRed,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Not study, just be used.",
                    style: SarakaTextStyles.body.copyWith(
                      fontSize: 16,
                      color: SarakaColors.lightRed,
                    ),
                  ),
                  SizedBox(height: 64),
                  SignInButton(),
                  SizedBox(height: 16),
                  UrlLaunchableText(
                    "Privacy Policy",
                    url: privacyPolicyUrl,
                    style: SarakaTextStyles.body,
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
