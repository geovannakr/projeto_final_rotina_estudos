import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkTheme;

  const HomeScreen({
    Key? key,
    this.isDarkTheme = false,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = 'Estudante';

  @override
  void initState() {
    super.initState();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Estudante';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumo do Dia'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.remove('userName');
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('Calendário'),
              onTap: () => Navigator.pushNamed(context, '/calendar'),
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tarefas e Provas'),
              onTap: () => Navigator.pushNamed(context, '/tasks'),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Desempenho'),
              onTap: () => Navigator.pushNamed(context, '/performance'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleLarge,
                children: [
                  TextSpan(text: "Bom dia, "),
                  TextSpan(
                    text: "$userName!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.class_),
                title: Text("Aulas do Dia"),
                subtitle: Text("Matemática - 10h\nHistória - 13h"),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.check_box),
                title: Text("Tarefas Pendentes"),
                subtitle: Text("Estudar capítulo 5 de História\nResolver exercícios de Matemática"),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/tasks'),
                  icon: Icon(Icons.add),
                  label: Text("Adicionar Tarefa"),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/calendar'),
                  icon: Icon(Icons.calendar_today),
                  label: Text("Ver Calendário"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}