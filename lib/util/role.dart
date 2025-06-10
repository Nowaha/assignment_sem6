enum Role {
  regular,
  moderator,
  administrator;

  static Role? fromName(String name) {
    try {
      return Role.values.firstWhere((it) => it.name == name);
    } catch (e) {
      return null;
    }
  }
}
