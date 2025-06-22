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
      appBar: AppBar(
        title: Text('Add Task'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Logo / Title
            Text(
              'Studify',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 30),

            // Form Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                          prefixIcon: Icon(Icons.title),
                        ),
                        onSaved: (value) => _title = value ?? '',
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter title' : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description),
                        ),
                        onSaved: (value) => _description = value ?? '',
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter description'
                            : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Due Date (YYYY-MM-DD)',
                          prefixIcon: Icon(Icons.date_range),
                        ),
                        onSaved: (value) => _dueDate = value ?? '',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter due date';
                          }
                          final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                          if (!regex.hasMatch(value)) {
                            return 'Enter date as YYYY-MM-DD';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          prefixIcon: Icon(Icons.flag),
                        ),
                        value: _priority,
                        onChanged: (value) => setState(() => _priority = value ?? 'Low'),
                        items: priorities
                            .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p),
                        ))
                            .toList(),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        icon: Icon(Icons.save),
                        label: Text('Save Task'),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
