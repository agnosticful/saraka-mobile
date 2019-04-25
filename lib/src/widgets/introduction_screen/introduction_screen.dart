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
  Widget build(BuildContext context) => Container(
        color: SarakaColors.white,
        child: IntroductionSlider(
          onActivePageChanged: _onActivePageChanged,
          children: [
            SlidePage(
              color: SarakaColors.white,
              headline: "Add a phrase",
              description:
                  "Parrot accepts any phrase or word that you want to be able to speak fluently.",
              image: Image.asset(
                "assets/images/introduction1.png",
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.width * 0.75,
              ),
            ),
            SlidePage(
              color: SarakaColors.white,
              headline: "Copy phrases",
              description:
                  "Parrot speaks those phrases fluently (backed on AI technology). Listen and copy aloud it.",
              image: Image.asset(
                "assets/images/introduction2.png",
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.width * 0.75,
              ),
            ),
            SlidePage(
              color: SarakaColors.white,
              headline: "Swipe to mark",
              description:
                  "If you confident to pronounce it correctly, swipe a card to right, otherwise to left.",
              image: Image.asset(
                "assets/images/introduction3.png",
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.width * 0.75,
              ),
            ),
            SlidePage(
              color: SarakaColors.white,
              headline: "Repeat as a review",
              description:
                  "Your most effective timing to review will be calculated by a psycological study. You will review your pronunciation repeatedly.",
              image: Image.asset(
                "assets/images/introduction4.png",
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.width * 0.75,
              ),
            ),
            SlidePage(
              color: SarakaColors.white,
              headline: "Get fluent",
              description:
                  "You will repeatedly practice to pronounce phrases and will be getting used to speak it fluently.",
              image: Image.asset(
                "assets/images/introduction5.png",
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.width * 0.75,
              ),
            ),
            AddFirstCardPage(isActive: _activeIndex == 3),
          ],
        ),
      );

  void _onActivePageChanged(int activePageIndex) {
    setState(() {
      _activeIndex = activePageIndex;
    });
  }
}
