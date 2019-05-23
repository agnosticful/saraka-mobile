import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../behaviors/logger_user_state_settable.dart';
import '../behaviors/sign_in_out_loggable.dart';
import '../behaviors/signable.dart';
import '../behaviors/user_data_gettable.dart';
import '../entities/authentication_session.dart';
import '../entities/user.dart';

abstract class AuthenticationBloc {
  AuthenticationSession get session;

  ValueObservable<User> get user;

  ValueObservable<bool> get isSigningIn;

  void restoreSession();

  void signIn();

  void signOut();
}

class _AuthenticationBloc implements AuthenticationBloc {
  _AuthenticationBloc({
    @required this.loggerUserStateSettable,
    @required this.signable,
    @required this.signInOutLoggable,
    @required this.userDataGettable,
  })  : assert(loggerUserStateSettable != null),
        assert(signable != null),
        assert(signInOutLoggable != null),
        assert(userDataGettable != null);

  final LoggerUserStateSettable loggerUserStateSettable;

  final Signable signable;

  final SignInOutLoggable signInOutLoggable;

  final UserDataGettable userDataGettable;

  @override
  AuthenticationSession session;

  @override
  final BehaviorSubject<User> user = BehaviorSubject();

  @override
  final BehaviorSubject<bool> isSigningIn = BehaviorSubject.seeded(false);

  @override
  void restoreSession() async {
    isSigningIn.add(true);

    session = await signable.restoreSession();

    if (session == null) {
      user.add(null);

      isSigningIn.add(false);
    } else {
      final userData = await userDataGettable.getUserData(session: session);
      final u = _User(
        id: session.userId,
        name: session.name,
        email: session.email,
        imageUrl: session.imageUrl,
        isIntroductionFinished: userData.isIntroductionFinished,
      );

      user.add(u);

      loggerUserStateSettable.setUserState(user: u);
      signInOutLoggable.logSignIn();

      isSigningIn.add(false);
    }
  }

  @override
  void signIn() async {
    isSigningIn.add(true);

    try {
      session = await signable.signIn();

      final userData = await userDataGettable.getUserData(session: session);
      final u = _User(
        id: session.userId,
        name: session.name,
        email: session.email,
        imageUrl: session.imageUrl,
        isIntroductionFinished: userData.isIntroductionFinished,
      );

      user.add(u);

      loggerUserStateSettable.setUserState(user: u);
      signInOutLoggable.logSignIn();
    } finally {
      isSigningIn.add(false);
    }
  }

  @override
  void signOut() async {
    assert(session != null);

    user.add(null);

    signable.signOut(session: session);

    signInOutLoggable.logSignOut();

    session = null;
  }
}

class _User extends User {
  _User({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.imageUrl,
    @required this.isIntroductionFinished,
  })  : assert(id != null),
        assert(name != null),
        assert(email != null),
        assert(imageUrl != null),
        assert(isIntroductionFinished != null);

  final String id;

  final String name;

  final String email;

  final Uri imageUrl;

  final bool isIntroductionFinished;
}

class AuthenticationBlocFactory {
  AuthenticationBlocFactory({
    @required LoggerUserStateSettable loggerUserStateSettable,
    @required Signable signable,
    @required SignInOutLoggable signInOutLoggable,
    @required UserDataGettable userDataGettable,
  })  : assert(loggerUserStateSettable != null),
        assert(signable != null),
        assert(signInOutLoggable != null),
        assert(userDataGettable != null),
        _loggerUserStateSettable = loggerUserStateSettable,
        _signable = signable,
        _signInOutLoggable = signInOutLoggable,
        _userDataGettable = userDataGettable;

  final LoggerUserStateSettable _loggerUserStateSettable;

  final Signable _signable;

  final SignInOutLoggable _signInOutLoggable;

  final UserDataGettable _userDataGettable;

  AuthenticationBloc create() => _AuthenticationBloc(
        loggerUserStateSettable: _loggerUserStateSettable,
        signable: _signable,
        signInOutLoggable: _signInOutLoggable,
        userDataGettable: _userDataGettable,
      );
}
