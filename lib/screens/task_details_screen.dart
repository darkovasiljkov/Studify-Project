import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${task.description}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text('Due Date: ${task.dueDate}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text('Priority: ${task.priority}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
