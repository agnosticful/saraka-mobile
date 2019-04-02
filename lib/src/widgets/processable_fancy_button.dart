import 'package:flutter/material.dart'
    show CircularProgressIndicator, RaisedButton;
import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

class ProcessableFancyButton extends StatefulWidget {
  ProcessableFancyButton({
    Key key,
    @required this.color,
    this.isProcessing = false,
    this.isDisabled = false,
    @required this.onPressed,
    @required this.child,
  })  : assert(color != null),
        assert(isProcessing != null),
        assert(isDisabled != null),
        assert(onPressed != null),
        assert(child != null),
        super(key: key);

  final Color color;

  final bool isProcessing;

  final bool isDisabled;

  final VoidCallback onPressed;

  final Widget child;

  @override
  _ProcessableFancyButtonState createState() => _ProcessableFancyButtonState();
}

class _ProcessableFancyButtonState extends State<ProcessableFancyButton>
    with TickerProviderStateMixin {
  AnimationController _processingStateAnimationController;

  AnimationController _disabledStateAnimationController;

  Animation _processingStateAnimation;

  Animation _disabledStateAnimation;

  @override
  void initState() {
    super.initState();

    _processingStateAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: widget.isProcessing ? 1 : 0,
    );

    _disabledStateAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
      value: widget.isDisabled ? 1 : 0,
    );

    _processingStateAnimation = CurvedAnimation(
      parent: _processingStateAnimationController,
      curve: Curves.easeInOutCirc,
    );

    _disabledStateAnimation = CurvedAnimation(
      parent: _disabledStateAnimationController,
      curve: Curves.easeInOutCirc,
    );
  }

  @override
  void didUpdateWidget(ProcessableFancyButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isProcessing != oldWidget.isProcessing) {
      if (widget.isProcessing) {
        _processingStateAnimationController.forward();
      } else {
        _processingStateAnimationController.reverse();
      }
    }

    if (widget.isDisabled != oldWidget.isDisabled) {
      if (widget.isDisabled) {
        _disabledStateAnimationController.forward();
      } else {
        _disabledStateAnimationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _disabledStateAnimation,
      child: widget.child,
      builder: (context, child) => RaisedButton(
            shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
            onPressed: widget.isDisabled ? () {} : widget.onPressed,
            color: ColorTween(begin: widget.color, end: SarakaColors.darkWhite)
                .animate(_disabledStateAnimation)
                .value,
            elevation: Tween(begin: 6.0, end: 0.0)
                .animate(_disabledStateAnimation)
                .value,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FadeTransition(
                    opacity: Tween(begin: 1.0, end: 0.0)
                        .animate(_processingStateAnimation),
                    child: ScaleTransition(
                      scale: Tween(begin: 1.0, end: 0.0)
                          .animate(_processingStateAnimation),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: ColorTween(
                            begin: computeTextColor(widget.color),
                            end: SarakaColors.darkGray,
                          ).animate(_disabledStateAnimation).value,
                          fontSize: 16,
                          fontFamily: SarakaFonts.rubik,
                          fontWeight: FontWeight.w500,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _processingStateAnimation,
                    child: ScaleTransition(
                      scale: _processingStateAnimation,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              const AlwaysStoppedAnimation(SarakaColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  static Color computeTextColor(Color backgroundColor) =>
      (backgroundColor.computeLuminance() + 0.05) *
                  (backgroundColor.computeLuminance() + 0.05) >
              0.3
          ? SarakaColors.darkBlack
          : SarakaColors.white;
}
