import 'package:flutter/material.dart' show AppBar, IconButton, Scaffold;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import '../wave_background.dart';
import './back_button.dart';
import './card_bundle.dart';
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

  @override
  void initState() {
    super.initState();

    _isTutorialShown = widget.showTutorial;
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
              body: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BackButton(),
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
                  Finished(),
                  CardBundle(),
                ],
              ),
            ),
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
