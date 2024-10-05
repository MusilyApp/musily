class AuthMethods {
  final Future<void> Function({
    required String email,
    required String password,
  }) login;
  final Future<void> Function() logout;
  final Future<void> Function({
    required String name,
    required String email,
    required String password,
  }) createAccout;
  final Future<void> Function({
    String? name,
    String? email,
    String? password,
  }) updateUser;

  AuthMethods({
    required this.login,
    required this.logout,
    required this.createAccout,
    required this.updateUser,
  });
}
