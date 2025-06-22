import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Replace with your app's constants/colors/styles or create your own
class AppConstants {
  static const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const primaryColor = Colors.indigo;
  static const accentColor = Colors.orangeAccent;
  static const textColor = Colors.black87;
  static const defaultPadding = 16.0;
  static const bodyStyle = TextStyle(fontSize: 16);
}

// Simple Event model
class Event {
  final String title;
  final DateTime date;
  final String time;

  Event({required this.title, required this.date, required this.time});

  @override
  String toString() => title;
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Map of date key (YYYY-MM-DD) -> List<Event>
  Map<String, List<Event>> _events = {};

  // Format DateTime to 'YYYY-MM-DD' string for consistent keying
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Get events for a specific day from the _events map
  List<Event> _getEventsForDay(DateTime day) {
    final key = _formatDateKey(day);
    final events = _events[key] ?? [];
    print('Events for $key: ${events.length} found');
    return events;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEventsFromFirestore();
  }

  void _loadEventsFromFirestore() {
    FirebaseFirestore.instance.collection('events').snapshots().listen((snapshot) {
      final Map<String, List<Event>> events = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final title = data['title'] ?? 'No title';
        final Timestamp timestamp = data['date'];
        final time = data['time'] ?? '';

        // Convert Firestore Timestamp to local DateTime to avoid timezone issues
        final dateTime = timestamp.toDate().toLocal();

        final dateKey = _formatDateKey(dateTime);

        print('Loaded event: "$title" on $dateKey at $time');

        final event = Event(title: title, date: dateTime, time: time);

        if (events[dateKey] == null) {
          events[dateKey] = [event];
        } else {
          events[dateKey]!.add(event);
        }
      }

      setState(() {
        _events = events;
      });

      print('All events keys loaded: ${events.keys}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsForSelectedDay = _getEventsForDay(_selectedDay!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar', style: AppConstants.headingStyle),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TableCalendar<Event>(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForDay,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: AppConstants.accentColor,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(color: AppConstants.textColor),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: eventsForSelectedDay.isEmpty
                  ? Center(child: Text('No events on this day.'))
                  : ListView.builder(
                itemCount: eventsForSelectedDay.length,
                itemBuilder: (context, index) {
                  final event = eventsForSelectedDay[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.event, color: AppConstants.primaryColor),
                      title: Text(event.title, style: AppConstants.bodyStyle),
                      subtitle: Text(event.time),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
