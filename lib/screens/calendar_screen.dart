import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/constants.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar', style: AppConstants.headingStyle),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: ListView(
                children: [
                  _buildTaskCard('Project Submission', 'Due by 3:00 PM'),
                  _buildTaskCard('Team Meeting', 'Starts at 5:00 PM'),
                  _buildTaskCard('Study Session', 'Starts at 7:00 PM'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String title, String time) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(Icons.event, color: AppConstants.primaryColor),
        title: Text(
          title,
          style: AppConstants.bodyStyle,
        ),
        subtitle: Text(
          time,
          style: TextStyle(color: AppConstants.textColor.withOpacity(0.7)),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: AppConstants.textColor),
        onTap: () {
          // Navigate to task details screen
          Navigator.pushNamed(context, AppConstants.taskDetailsRoute);
        },
      ),
    );
  }
}
