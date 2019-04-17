import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import './add_first_card_page.dart';
import './slide_page.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) => IntroductionSlider(
        onActivePageChanged: _onActivePageChanged,
        children: [
          SlidePage(
            color: SarakaColors.lightBlack,
            headline: "Best Way to Be Fluent",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            image: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: SarakaColors.white,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.75 / 2,
                ),
              ),
            ),
          ),
          SlidePage(
            color: SarakaColors.darkRed,
            headline: "Not Study, Just Get Used",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            image: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: SarakaColors.white,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.75 / 2,
                ),
              ),
            ),
          ),
          SlidePage(
            color: SarakaColors.darkGreen,
            headline: "Listen, Speak, Repeat!",
            description:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            image: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: SarakaColors.white,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.75 / 2,
                ),
              ),
            ),
          ),
          AddFirstCardPage(isActive: _activeIndex == 3),
        ],
      );

  void _onActivePageChanged(int activePageIndex) {
    setState(() {
      _activeIndex = activePageIndex;
    });
  }
}
