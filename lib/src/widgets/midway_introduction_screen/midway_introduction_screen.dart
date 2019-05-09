import 'package:flutter/material.dart';
import './instruction_page.dart';

class MidwayIntroductionScreen extends StatelessWidget {
  MidwayIntroductionScreen({@required String pageName})
      : assert(pageName != null),
        _pageName = pageName;

  final String _pageName;

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.blue,
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: InstructionPage(
          color: Colors.white,
          image: Image.asset(
            "assets/images/introduction2.png",
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.75,
          ),
          content:
              "Parrot speaks those phrases using AI. Listen and repeat up aloud.",
        ),
      );
}
