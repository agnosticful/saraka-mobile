import 'package:meta/meta.dart';
import 'package:saraka/entities.dart';

class CardConfirmDeletionRouteArguments {
  CardConfirmDeletionRouteArguments({@required this.card})
      : assert(card != null);

  final Card card;
}
