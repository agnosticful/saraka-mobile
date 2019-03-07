mixin Identifiable<Klass, IdType> {
  IdType get id;

  @override
  operator ==(Object other) =>
      other is Identifiable<Klass, IdType> && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
