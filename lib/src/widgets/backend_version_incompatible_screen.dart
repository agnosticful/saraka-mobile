import 'package:flutter/material.dart';
import 'package:saraka/constants.dart';

class BackendVersionIncompatibleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: SarakaColors.white),
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 128,
                height: 128,
                child: Image.asset('assets/images/play-store.png'),
              ),
              SizedBox(height: 32),
              Text(
                "A new version is ready!",
                style: SarakaTextStyles.heading.copyWith(
                  color: SarakaColors.lightRed,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                "This update is necessary.\nPlease install it from the app store.",
                style: SarakaTextStyles.multilineBody2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
