enum Role {
  regular("Regular"),
  moderator("Moderator"),
  administrator("Administrator");

  final String name;

  const Role(this.name);

  static Role? fromName(String name) {
    try {
      return Role.values.firstWhere(
        (it) => it.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
