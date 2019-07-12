import 'package:flutter/foundation.dart';

class SwipableCardStackController extends ChangeNotifier {
  SwipableCardStackController()
      : _position = 0,
        _headSwipingRate = 0;

  int _position;

  double _headSwipingRate;

  int get position => _position;

  double get headSwipingRate => _headSwipingRate;

  set headSwipingRate(double swipingRate) {
    _headSwipingRate = swipingRate;

    notifyListeners();
  }

  void next() {
    _position += 1;
    _headSwipingRate = 0;

    notifyListeners();
  }

  void previous() {
    assert(_position >= 1);

    _position -= 1;
    _headSwipingRate = 1;

    notifyListeners();
  }
}
