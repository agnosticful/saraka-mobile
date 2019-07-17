import 'package:meta/meta.dart';
import '../blocs/common_link_bloc.dart';

class CommonLinkBlocFactory {
  CommonLinkBlocFactory({
    @required UrlOpenable urlOpenable,
    @required Uri privacyPolicyUrl,
  })  : assert(urlOpenable != null),
        assert(privacyPolicyUrl != null),
        _urlOpenable = urlOpenable,
        _privacyPolicyUrl = privacyPolicyUrl;

  final UrlOpenable _urlOpenable;
  final Uri _privacyPolicyUrl;

  CommonLinkBloc create() => _CommonLinkBloc(
        urlOpenable: _urlOpenable,
        privacyPolicyUrl: _privacyPolicyUrl,
      );
}

abstract class UrlOpenable {
  Future<void> openUrl(Uri url);
}

class UrlOpenFailureException implements Exception {
  UrlOpenFailureException(this.url);

  final Uri url;

  String toString() =>
      'UrlOpenFailureException: the URL ($url) cannot be opened';
}

class _CommonLinkBloc implements CommonLinkBloc {
  _CommonLinkBloc({
    @required this.urlOpenable,
    @required this.privacyPolicyUrl,
  })  : assert(urlOpenable != null),
        assert(privacyPolicyUrl != null);

  final UrlOpenable urlOpenable;

  final Uri privacyPolicyUrl;

  @override
  Future<void> openPrivacyPolicy() => urlOpenable.openUrl(privacyPolicyUrl);

  @override
  void initialize() {}

  @override
  void dispose() {}
}
