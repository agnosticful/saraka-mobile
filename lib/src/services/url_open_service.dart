import 'package:url_launcher/url_launcher.dart';
import '../bloc_factories/common_link_bloc_factory.dart';

class UrlOpenService implements UrlOpenable {
  @override
  Future<void> openUrl(Uri url) async {
    final urlString = url.toString();

    if (await canLaunch(urlString)) {
      await launch(urlString);
    } else {
      throw UrlOpenFailureException(url);
    }
  }
}
