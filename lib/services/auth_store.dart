import '../models/local_user.dart';

/// Guarda contas somente durante a execução atual do aplicativo.
class AuthStore {
  AuthStore._();

  static final List<LocalUser> _users = [];

  static bool register({
    required String name,
    required String email,
    required String password,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    if (_users.any((user) => user.email == normalizedEmail)) {
      return false;
    }

    _users.add(
      LocalUser(
        name: name.trim(),
        email: normalizedEmail,
        password: password,
      ),
    );
    return true;
  }

  static LocalUser? authenticate({
    required String email,
    required String password,
  }) {
    final normalizedEmail = email.trim().toLowerCase();
    for (final user in _users) {
      if (user.email == normalizedEmail && user.password == password) {
        return user;
      }
    }
    return null;
  }
}
