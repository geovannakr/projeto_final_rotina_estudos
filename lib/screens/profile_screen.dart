import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkTheme;
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
    final backgroundColor = isDarkTheme ? Colors.black : Colors.white;
    final textColor = isDarkTheme ? Colors.white : Colors.black;
    final cardColor = isDarkTheme ? const Color(0xFF1A1A1A) : const Color(0xFFF1F1F1);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Perfil', style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Image.asset(
              'assets/logo_brain.png', // coloque sua imagem aqui
              width: 100,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Informações do Usuário",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildInfoTile(
            icon: Icons.person,
            title: name,
            subtitle: 'Nome',
            color: cardColor,
            textColor: textColor,
          ),
          _buildInfoTile(
            icon: Icons.email,
            title: email,
            subtitle: 'Email',
            color: cardColor,
            textColor: textColor,
          ),
          _buildInfoTile(
            icon: Icons.lock,
            title: showPassword ? password : encryptedPassword,
            subtitle: 'Senha',
            color: cardColor,
            textColor: textColor,
            trailing: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility_off : Icons.visibility,
                color: textColor,
              ),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              title: Text(
                'Tema Claro / Escuro',
                style: TextStyle(color: textColor),
              ),
              value: isDarkTheme,
              onChanged: (val) {
                setState(() {
                  isDarkTheme = val;
                });
                widget.onThemeChanged?.call(val);
              },
              activeColor: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            tileColor: Colors.red.shade700,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text(
              'Sair',
              style: TextStyle(color: Colors.white),
            ),
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

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: textColor),
        title: Text(title, style: TextStyle(color: textColor, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: textColor.withOpacity(0.6))),
        trailing: trailing,
      ),
    );
  }
}