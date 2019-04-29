import 'package:url_launcher/url_launcher.dart';
import 'package:saraka/blocs.dart';

class UrlLauncher implements UrlLaunchable {
  @override
  Future<void> launchUrl(Uri url) async {
    final urlString = url.toString();

    if (await canLaunch(urlString)) {
      await launch(urlString);
    } else {
      throw UrlLaunchFailureException(url);
    }
  }
}
