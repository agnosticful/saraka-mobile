import 'package:flutter/material.dart';
import 'package:saraka/constants.dart';
import '../disappearable_builder.dart';
import './dot_indicator.dart';

class IntroductionSlider extends StatefulWidget {
  IntroductionSlider(
      {Key key,
      this.onCurrentPageChanged,
      @required this.pageBuilder,
      @required this.pageNames})
      : assert(pageBuilder != null),
        assert(pageNames.length >= 1),
        super(key: key);

  final void Function(String pageName) onCurrentPageChanged;

  final Widget Function(BuildContext, String pageName) pageBuilder;

  final List<String> pageNames;

  @override
  _IntroductionSliderState createState() =>
      _IntroductionSliderState(pageCount: pageNames.length);
}

class _IntroductionSliderState extends State<IntroductionSlider> {
  _IntroductionSliderState({@required int pageCount})
      : assert(pageCount != null),
        _pageCount = pageCount;
  final controller = PageController();

  final _pageCount;

  String _previousPageName;

  String _currentPageName;

  @override
  void initState() {
    super.initState();

    _previousPageName = widget.pageNames.first;
    _currentPageName = _previousPageName;

    controller.addListener(() {
      final currentPageName = widget.pageNames[controller.page.round()];

      if (currentPageName != _previousPageName) {
        setState(() {
          _currentPageName = currentPageName;
        });

        if (widget.onCurrentPageChanged != null) {
          widget.onCurrentPageChanged(currentPageName);
        }

        _previousPageName = currentPageName;
      }
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemBuilder: (context, index) =>
                widget.pageBuilder(context, widget.pageNames[index]),
            itemCount: _pageCount,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: DotIndicator(
                length: widget.pageNames.length,
                activeIndex: widget.pageNames.indexOf(_currentPageName),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 48,
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DisappearableBuilder(
                    isDisappeared: _currentPageName == widget.pageNames.first,
                    child: FlatButton(
                      shape: SuperellipseShape(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      onPressed: () => controller.previousPage(
                            curve: Curves.easeInOutCirc,
                            duration: Duration(milliseconds: 300),
                          ),
                      child: Text(
                        "Previous",
                        style: SarakaTextStyles.buttonLabel,
                      ),
                    ),
                  ),
                  DisappearableBuilder(
                    isDisappeared: _currentPageName == widget.pageNames.last,
                    child: FlatButton(
                      shape: SuperellipseShape(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      onPressed: () => controller.nextPage(
                            curve: Curves.easeInOutCirc,
                            duration: Duration(milliseconds: 300),
                          ),
                      child: Text(
                        "Next",
                        style: SarakaTextStyles.buttonLabel,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
