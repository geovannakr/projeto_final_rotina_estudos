class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  final Map<String, dynamic> _fakeDatabase = {
    'admin@edutrack.com': {
      'nome': 'Admin',
      'email': 'admin@edutrack.com',
      'senha': '123456',
      'notas': {
        'Matemática': 7.5,
        'Física': 8.0,
        'Português': 6.2,
        'História': 9.0,
      }
    },
  };

  Map<String, dynamic>? getUserData(String email) {
    return _fakeDatabase[email];
  }

  void updateUserData(String email, Map<String, dynamic> newData) {
    if (_fakeDatabase.containsKey(email)) {
      _fakeDatabase[email]!.addAll(newData);
    }
  }
}
