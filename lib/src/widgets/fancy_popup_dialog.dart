import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

Future<T> showFancyPopupDialog<T>({
  @required BuildContext context,
  @required RoutePageBuilder pageBuilder,
}) {
  assert(context != null);
  assert(pageBuilder != null);

  return Navigator.of(context)
      .push<T>(_FancyPopupDialogRoute<T>(pageBuilder: pageBuilder));
}

class _FancyPopupDialogRoute<T> extends PopupRoute<T> {
  _FancyPopupDialogRoute({
    @required RoutePageBuilder pageBuilder,
    RouteSettings settings,
  })  : assert(pageBuilder != null),
        _pageBuilder = pageBuilder,
        super(settings: settings);

  final RoutePageBuilder _pageBuilder;

  @override
  final bool barrierDismissible = true;

  @override
  final String barrierLabel = 'Close';

  @override
  final Color barrierColor = SarakaColors.darkBlack.withOpacity(0.666);

  @override
  final Duration transitionDuration = const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      child: _pageBuilder(context, animation, secondaryAnimation),
      scopesRoute: true,
      explicitChildNodes: true,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
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
