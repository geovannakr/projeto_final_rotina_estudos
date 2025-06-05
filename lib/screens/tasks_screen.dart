import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🔗 Notificador global dos eventos
final ValueNotifier<Map<DateTime, List<String>>> eventNotifier = ValueNotifier({});

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, String>> _exams = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final taskStr = prefs.getString('tasks');
    final examStr = prefs.getString('exams');

    _tasks.clear();
    _exams.clear();
    final Map<DateTime, List<String>> loadedEvents = {};

    if (taskStr != null) {
      _tasks = List<Map<String, dynamic>>.from(json.decode(taskStr));
      for (var task in _tasks) {
        final date = _parseDate(task['dueDate']);
        if (date != null) {
          final normalized = _normalizeDate(date);
          loadedEvents[normalized] = [...(loadedEvents[normalized] ?? []), '${task['title']} (${task['subject']})'];
        }
      }
    }

    if (examStr != null) {
      _exams = List<Map<String, String>>.from(json.decode(examStr));
      for (var exam in _exams) {
        final date = _parseDate(exam['date']);
        if (date != null) {
          final normalized = _normalizeDate(date);
          loadedEvents[normalized] = [...(loadedEvents[normalized] ?? []), '${exam['type']} • ${exam['subject']}'];
        }
      }
    }

    eventNotifier.value = loadedEvents;
    setState(() {});
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', json.encode(_tasks));
    await prefs.setString('exams', json.encode(_exams));
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      final parts = dateStr.split('/');
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (e) {
      return null;
    }
  }

  void _addToEventNotifier(String dateStr, String event) {
    final date = _parseDate(dateStr);
    if (date == null) return;
    final normalized = _normalizeDate(date);
    final existing = eventNotifier.value[normalized] ?? [];
    eventNotifier.value = {
      ...eventNotifier.value,
      normalized: [...existing, event],
    };
  }

  void _removeFromEventNotifier(String dateStr, String event) {
    final date = _parseDate(dateStr);
    if (date == null) return;
    final normalized = _normalizeDate(date);
    final updated = List<String>.from(eventNotifier.value[normalized] ?? [])..remove(event);
    if (updated.isEmpty) {
      final newMap = Map<DateTime, List<String>>.from(eventNotifier.value);
      newMap.remove(normalized);
      eventNotifier.value = newMap;
    } else {
      eventNotifier.value = {
        ...eventNotifier.value,
        normalized: updated,
      };
    }
  }

  void _toggleTaskDone(int index, bool? value) {
    setState(() {
      _tasks[index]['done'] = value ?? false;
    });
    _saveData();
  }

  void _removePastExams() {
    final today = _normalizeDate(DateTime.now());
    setState(() {
      _exams.removeWhere((exam) {
        final date = _parseDate(exam['date']);
        final shouldRemove = date != null && date.isBefore(today);
        if (shouldRemove) {
          _removeFromEventNotifier(exam['date']!, '${exam['type']} • ${exam['subject']}');
        }
        return shouldRemove;
      });
    });
    _saveData();
  }

  void _removeTask(int index) {
    final task = _tasks[index];
    _removeFromEventNotifier(task['dueDate'], '${task['title']} (${task['subject']})');
    setState(() => _tasks.removeAt(index));
    _saveData();
  }

  void _removeExam(int index) {
    final exam = _exams[index];
    _removeFromEventNotifier(exam['date']!, '${exam['type']} • ${exam['subject']}');
    setState(() => _exams.removeAt(index));
    _saveData();
  }

  void _addTaskOrExam() {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final dateController = TextEditingController();
    final isExamController = ValueNotifier<bool>(false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nova Tarefa/Prova'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: 'Título')),
              TextField(controller: subjectController, decoration: InputDecoration(labelText: 'Matéria')),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Data (dd/mm/aaaa)'),
                keyboardType: TextInputType.datetime,
              ),
              ValueListenableBuilder(
                valueListenable: isExamController,
                builder: (_, isExam, __) => CheckboxListTile(
                  title: Text("É uma prova?"),
                  value: isExam,
                  onChanged: (val) => isExamController.value = val ?? false,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String title = titleController.text.trim();
              String subject = subjectController.text.trim();
              String dateStr = dateController.text.trim();
              bool isExam = isExamController.value;

              final date = _parseDate(dateStr);
              if (title.isEmpty || subject.isEmpty || dateStr.isEmpty || date == null) return;

              setState(() {
                if (isExam) {
                  _exams.add({'subject': subject, 'type': title, 'date': dateStr});
                  _addToEventNotifier(dateStr, '$title • $subject');
                } else {
                  _tasks.add({
                    'title': title,
                    'subject': subject,
                    'dueDate': dateStr,
                    'priority': 'Média',
                    'done': false,
                  });
                  _addToEventNotifier(dateStr, '$title ($subject)');
                }
              });

              _saveData();
              Navigator.pop(context);
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas e Provas'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Remover provas passadas',
            onPressed: _removePastExams,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Tarefas', style: Theme.of(context).textTheme.titleLarge),
            ..._tasks.asMap().entries.map((entry) {
              int index = entry.key;
              var task = entry.value;
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _removeTask(index),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  child: CheckboxListTile(
                    title: Text(task['title']),
                    subtitle: Text(
                        '${task['subject']} • Entrega: ${task['dueDate']} • Prioridade: ${task['priority']}'),
                    value: task['done'],
                    onChanged: (value) => _toggleTaskDone(index, value),
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 24),
            Text('Provas', style: Theme.of(context).textTheme.titleLarge),
            ..._exams.asMap().entries.map((entry) {
              int index = entry.key;
              var exam = entry.value;
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _removeExam(index),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.assignment),
                    title: Text('${exam['subject']}'),
                    subtitle: Text('${exam['type']} • Data: ${exam['date']}'),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskOrExam,
        child: Icon(Icons.add),
        tooltip: 'Adicionar tarefa ou prova',
      ),
    );
  }
}