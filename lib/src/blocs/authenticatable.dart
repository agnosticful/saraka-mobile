import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart' show User;
export 'package:saraka/entities.dart' show User;

mixin Authenticatable {
  ValueObservable<User> get user;
}
