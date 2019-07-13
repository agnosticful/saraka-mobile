import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

abstract class FancyPopupDialogRoute<T> extends PopupRoute<T> {
  FancyPopupDialogRoute({RouteSettings settings}) : super(settings: settings);

  @override
  final bool barrierDismissible = true;

  @override
  final String barrierLabel = 'Close';

  @override
  final Color barrierColor = SarakaColor.darkBlack.withOpacity(0.666);

  @override
  final Duration transitionDuration = const Duration(milliseconds: 300);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      // should be Padding?
      Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 0.125),
            end: Offset(0, 0),
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.elasticInOut,
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: child),
              ),
            ),
          ),
        ),
      );
}
