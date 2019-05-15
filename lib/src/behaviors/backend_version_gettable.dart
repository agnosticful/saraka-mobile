abstract class BackendVersionGettable {
  Future<int> getBackendVersion();
}

class BackendVersionGetException implements Exception {
  BackendVersionGetException(this.data);

  final Map<dynamic, dynamic> data;

  String toString() => 'BackendVersionGetException: data is\n$data';
}
