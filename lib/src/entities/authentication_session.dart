abstract class AuthenticationSession {
  String get userId;

  // this is supposed to be moved to UserData
  String get name;

  // this is supposed to be moved to UserData
  String get email;

  // this is supposed to be moved to UserData
  Uri get imageUrl;
}
