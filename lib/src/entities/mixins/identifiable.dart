mixin Identifiable<ClassType, IdType> {
  IdType get id;

  @override
  operator ==(Object other) =>
      other is Identifiable<ClassType, IdType> && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
