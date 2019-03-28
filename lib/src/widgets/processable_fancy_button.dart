import 'package:flutter/material.dart'
    show CircularProgressIndicator, RaisedButton;
import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

class ProcessableFancyButton extends StatefulWidget {
  ProcessableFancyButton({
    Key key,
    @required this.color,
    this.isProcessing = false,
    @required this.onPressed,
    @required this.child,
  })  : assert(color != null),
        assert(isProcessing != null),
        assert(onPressed != null),
        assert(child != null),
        super(key: key);

  final Color color;

  final bool isProcessing;

  final VoidCallback onPressed;

  final Widget child;

  @override
  _ProcessableFancyButtonState createState() => _ProcessableFancyButtonState();
}

class _ProcessableFancyButtonState extends State<ProcessableFancyButton>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: widget.isProcessing ? 1 : 0,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCirc,
    );
  }

  @override
  void didUpdateWidget(ProcessableFancyButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isProcessing != oldWidget.isProcessing) {
      if (widget.isProcessing) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: SuperellipseShape(borderRadius: BorderRadius.circular(24)),
      onPressed: widget.onPressed,
      color: widget.color,
      elevation: 6,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            FadeTransition(
              opacity: Tween(begin: 1.0, end: 0.0).animate(_animation),
              child: ScaleTransition(
                scale: Tween(begin: 1.0, end: 0.0).animate(_animation),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: (widget.color.computeLuminance() + 0.05) *
                                (widget.color.computeLuminance() + 0.05) >
                            0.3
                        ? SarakaColors.darkBlack
                        : SarakaColors.white,
                    fontSize: 16,
                    fontFamily: SarakaFonts.rubik,
                    fontWeight: FontWeight.w500,
                  ),
                  child: widget.child,
                ),
              ),
            ),
            FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _animation,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(SarakaColors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
