import 'package:rxdart/rxdart.dart';
import '../entities/user.dart';
export '../entities/user.dart';

mixin Authenticatable {
  ValueObservable<User> get user;
}
