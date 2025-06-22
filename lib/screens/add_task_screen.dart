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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Please enter title' : null,
                onSaved: (val) => _title = val ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (val) => val == null || val.isEmpty
                    ? 'Please enter description'
                    : null,
                onSaved: (val) => _description = val ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Please enter due date' : null,
                onSaved: (val) => _dueDate = val ?? '',
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Priority'),
                value: _priority,
                items: ['Low', 'Medium', 'High']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => _priority = val ?? 'Low'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Save Task'),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();

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
