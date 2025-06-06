class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  AuthService._internal();

  String? _loggedInEmail;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@studyflow.com' && password == '123456') {
      _loggedInEmail = email;
      return true;
    }
    return false;
  }

  void logout() {
    _loggedInEmail = null;
  }

  bool isLoggedIn() {
    return _loggedInEmail != null;
  }

  String? getUserEmail() {
    return _loggedInEmail;
  }
}
