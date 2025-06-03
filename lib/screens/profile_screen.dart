import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkTheme; // Recebe o estado atual do tema
  final Function(bool)? onThemeChanged;

  const ProfileScreen({
    Key? key,
    this.isDarkTheme = false,
    this.onThemeChanged,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool isDarkTheme;
  bool showPassword = false;

  String name = '';
  String email = '';
  String password = '';

  String get encryptedPassword => List.filled(password.length, '•').join();

  @override
  void initState() {
    super.initState();
    isDarkTheme = widget.isDarkTheme;
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('userName') ?? 'Nome não encontrado';
      email = prefs.getString('userEmail') ?? 'Email não encontrado';
      password = prefs.getString('userPassword') ?? '••••••••';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Informações do Usuário",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(name),
            subtitle: const Text('Nome'),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(email),
            subtitle: const Text('Email'),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(showPassword ? password : encryptedPassword),
            subtitle: const Text('Senha'),
            trailing: IconButton(
              icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            ),
          ),
          const Divider(height: 32),
          SwitchListTile(
  title: const Text('Tema Claro / Escuro'),
  value: isDarkTheme,
  onChanged: (val) {
    setState(() {
      isDarkTheme = val;
    });
    widget.onThemeChanged?.call(val);
  },
),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}