import 'package:meta/meta.dart';

abstract class CommonLinkBloc {
  factory CommonLinkBloc({
    @required UrlLaunchable urlLaunchable,
    @required Uri privacyPolicyUrl,
  }) =>
      _CommonLinkBloc(
        urlLaunchable: urlLaunchable,
        privacyPolicyUrl: privacyPolicyUrl,
      );

  Future<void> launchPrivacyPolicy();
}

class _CommonLinkBloc implements CommonLinkBloc {
  _CommonLinkBloc({
    @required this.urlLaunchable,
    @required this.privacyPolicyUrl,
  })  : assert(urlLaunchable != null),
        assert(privacyPolicyUrl != null);

  final UrlLaunchable urlLaunchable;

  final Uri privacyPolicyUrl;

  @override
  Future<void> launchPrivacyPolicy() =>
      urlLaunchable.launchUrl(privacyPolicyUrl);
}

mixin UrlLaunchable {
  Future<void> launchUrl(Uri url);
}

class UrlLaunchFailureException implements Exception {
  UrlLaunchFailureException(this.url);

  final Uri url;

  String toString() =>
      'UrlLaunchFailureException: the URL ($url) cannot be opened';
}
