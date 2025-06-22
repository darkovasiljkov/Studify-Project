import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      await _firestoreService.addEvent(
        title: _titleController.text,
        date: _selectedDate!,
        time: _selectedTime!,
      );
      Navigator.pop(context); // back to previous screen
    } catch (e) {
      print('Failed to add event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add event')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Event')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(_selectedDate == null
                  ? 'Select Date'
                  : _selectedDate!.toLocal().toString().split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text(_selectedTime == null
                  ? 'Select Time'
                  : _selectedTime!.format(context)),
              trailing: Icon(Icons.access_time),
              onTap: _pickTime,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Save Event'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            )
          ],
        ),
      ),
    );
  }
}
