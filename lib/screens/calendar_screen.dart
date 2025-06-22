import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';

// Your Event model
class Event {
  final String title;
  final DateTime date;
  final String time;

  Event({required this.title, required this.date, required this.time});
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Map of Date -> List of Events
  Map<DateTime, List<Event>> _events = {};

  List<Event> _getEventsForDay(DateTime day) {
    // Normalize date (remove time part)
    final date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEventsFromFirestore();
  }

  void _loadEventsFromFirestore() {
    FirebaseFirestore.instance
        .collection('events')
        .snapshots()
        .listen((snapshot) {
      final Map<DateTime, List<Event>> events = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Extract data from Firestore document
        final title = data['title'] ?? 'No title';
        final Timestamp timestamp = data['date'];
        final time = data['time'] ?? '';

        final dateTime = timestamp.toDate();
        final dateKey = DateTime(dateTime.year, dateTime.month, dateTime.day);

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
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
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
                  color: AppConstants.accentColor,
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

          // Show list of events for the selected day
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
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.event, color: AppConstants.primaryColor),
                      title: Text(
                        event.title,
                        style: AppConstants.bodyStyle,
                      ),
                      subtitle: Text(event.time),
                      // You can add onTap to go to event details screen if you want
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
