abstract class User {
  String id;

  @override
  operator ==(Object other) => other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
