abstract class Card {
  String get id;

  String get text;

  @override
  operator ==(Object other) => other is Card && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
