import 'package:flutter/material.dart' show AppBar, IconButton, Scaffold;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import '../swipable_card_stack.dart';
import '../wave_background.dart';
import './back_button.dart';
import './card_stack.dart';
import './finished.dart';
import './progress_indicator.dart';
import './time_estimation.dart';
import './tutorial.dart';

class ReviewScreen extends StatefulWidget {
  ReviewScreen({Key key, this.showTutorial = false}) : super(key: key);

  final bool showTutorial;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _isTutorialShown;

  SwipableCardStackController _swipableCardStackController;

  @override
  void initState() {
    super.initState();

    _isTutorialShown = widget.showTutorial;
    _swipableCardStackController = SwipableCardStackController();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          WaveBackground(color: SarakaColors.darkBlack),
          SafeArea(
            child: Scaffold(
              backgroundColor: Color(0x00000000),
              appBar: AppBar(
                title: Text(
                  'Review',
                  style: SarakaTextStyles.appBarTitle,
                ),
                centerTitle: true,
                backgroundColor: Color(0x00000000),
                elevation: 0,
                leading: Navigator.of(context).canPop()
                    ? IconButton(
                        icon: Icon(Feather.getIconData('x')),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    : null,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Finished(),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BackButton(controller: _swipableCardStackController),
                        SizedBox(width: 16),
                        Expanded(
                          child: ProgressIndicator(),
                        ),
                        SizedBox(width: 16),
                        TimeEstimation(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 80, 16, 80),
            child: CardStack(controller: _swipableCardStackController),
          ),
        ]..addAll(_isTutorialShown
            ? [
                Tutorial(
                  onDismissed: _onTutorialDismissed,
                ),
              ]
            : []),
      );

  void _onTutorialDismissed() {
    setState(() {
      _isTutorialShown = false;
    });
  }
}
