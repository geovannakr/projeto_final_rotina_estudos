import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'tasks_screen.dart'; // Importa para acessar o eventNotifier

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<String> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return eventNotifier.value[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendário')),
      body: ValueListenableBuilder<Map<DateTime, List<String>>>(
        valueListenable: eventNotifier,
        builder: (context, value, _) {
          final eventsForSelectedDay = _getEventsForDay(_selectedDay);

          return Column(
            children: [
              TableCalendar<String>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                eventLoader: _getEventsForDay,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: eventsForSelectedDay.isEmpty
                    ? Center(child: Text('Nenhum evento neste dia.'))
                    : ListView(
                        children: eventsForSelectedDay.map((event) {
                          return ListTile(
                            leading: Icon(Icons.event_note),
                            title: Text(event),
                          );
                        }).toList(),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
