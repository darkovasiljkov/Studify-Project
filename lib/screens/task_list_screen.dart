import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../services/firestore_service.dart';

class TaskListScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  TaskListScreen({Key? key}) : super(key: key);

  Task _taskFromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dueDate: data['dueDate'] ?? '',
      priority: data['priority'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final task = _taskFromDoc(doc);
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/task-details',
                    arguments: task,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Add Task',
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
      ),
    );
  }
}
