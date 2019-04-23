import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SarakaColors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 192,
              height: 192,
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
          ],
        ),
      ),
    );
  }
}
