abstract class UrlLaunchable {
  Future<void> launchUrl(Uri url);
}

class UrlLaunchFailureException implements Exception {
  UrlLaunchFailureException(this.url);

  final Uri url;

  String toString() =>
      'UrlLaunchFailureException: the URL ($url) cannot be opened';
}
