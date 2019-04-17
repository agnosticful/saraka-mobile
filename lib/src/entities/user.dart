import './mixins/identifiable.dart';

abstract class User with Identifiable<User, String> {
  String get name;

  String get email;

  Uri get imageUrl;

  bool get isIntroductionFinished;
}
