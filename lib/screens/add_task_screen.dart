import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService firestoreService = FirestoreService();

  String _title = '';
  String _description = '';
  String _dueDate = '';
  String _priority = 'Low';

  final List<String> priorities = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Please enter title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Please enter description' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
                onSaved: (value) => _dueDate = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter due date';
                  final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!regex.hasMatch(value)) return 'Enter date as YYYY-MM-DD';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Priority'),
                value: _priority,
                onChanged: (value) => setState(() => _priority = value ?? 'Low'),
                items: priorities
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save Task'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await firestoreService.addTask(
                      title: _title,
                      description: _description,
                      dueDate: _dueDate,
                      priority: _priority,
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
