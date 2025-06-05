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
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;

        return AlertDialog(
          backgroundColor: bgColor,
          title: Text('Adicionar Nota', style: TextStyle(color: textColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: materiaController,
                decoration: InputDecoration(
                  labelText: 'Matéria',
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textColor),
              ),
              TextField(
                controller: notaController,
                decoration: InputDecoration(
                  labelText: 'Nota',
                  labelStyle: TextStyle(color: textColor),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: textColor),
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
              child: const Text('Salvar'),
            ),
          ],
        );
      },
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

    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF2F2F2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Desempenho'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Média por matéria',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            ...desempenho.map((perf) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: perf.average < 7 ? Colors.red : Colors.transparent,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        perf.subject,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      Text(
                        perf.average.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 16,
                          color: perf.average < 7
                              ? Colors.red
                              : (isDark ? Colors.greenAccent : Colors.green),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            Text(
              'Alertas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            if (baixoDesempenho.isEmpty)
              Text(
                'Nenhum alerta de baixo desempenho',
                style: TextStyle(color: Colors.green.shade700),
              )
            else
              ...baixoDesempenho.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '⚠ Baixo desempenho em ${e.subject} (média: ${e.average.toStringAsFixed(1)})',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarNota,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
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