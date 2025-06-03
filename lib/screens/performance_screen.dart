import 'package:flutter/material.dart';

class PerformanceScreen extends StatefulWidget {
  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  final Map<String, List<double>> _notasPorMateria = {
    'Matemática': [7.5],
    'Física': [8.0],
    'Português': [6.2],
    'História': [9.0],
  };

  void _adicionarNota() {
    final materiaController = TextEditingController();
    final notaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar Nota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: materiaController,
              decoration: InputDecoration(labelText: 'Matéria'),
            ),
            TextField(
              controller: notaController,
              decoration: InputDecoration(labelText: 'Nota'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              String materia = materiaController.text.trim();
              double? nota = double.tryParse(notaController.text);

              if (materia.isEmpty || nota == null) {
                Navigator.pop(context);
                return;
              }

              setState(() {
                if (_notasPorMateria.containsKey(materia)) {
                  _notasPorMateria[materia]!.add(nota);
                } else {
                  _notasPorMateria[materia] = [nota];
                }
              });

              Navigator.pop(context);
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  double _media(List<double> notas) {
    if (notas.isEmpty) return 0;
    return notas.reduce((a, b) => a + b) / notas.length;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final desempenho = _notasPorMateria.entries.map((entry) {
      return SubjectPerformance(entry.key, _media(entry.value));
    }).toList();

    final baixoDesempenho = desempenho.where((e) => e.average < 7).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Desempenho')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Média por matéria',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 16),
            ...desempenho.map((perf) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${perf.subject}: ${perf.average.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: perf.average < 7
                          ? Colors.red
                          : (isDark ? Colors.white : Colors.black),
                    ),
                  ),
                )),
            SizedBox(height: 20),
            baixoDesempenho.isEmpty
                ? Text(
                    'Nenhum alerta de baixo desempenho',
                    style: TextStyle(
                      color: Colors.green.shade700,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: baixoDesempenho
                        .map(
                          (e) => Text(
                            'Atenção: Desempenho baixo em ${e.subject} (média: ${e.average.toStringAsFixed(1)})',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarNota,
        child: Icon(Icons.add),
        tooltip: 'Adicionar nota',
      ),
    );
  }
}

class SubjectPerformance {
  final String subject;
  final double average;

  SubjectPerformance(this.subject, this.average);
}