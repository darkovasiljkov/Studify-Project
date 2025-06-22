import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference eventsCollection =
  FirebaseFirestore.instance.collection('events');

  final CollectionReference tasksCollection =
  FirebaseFirestore.instance.collection('tasks');

  Future<void> addEvent({
    required String title,
    required DateTime date,
    required TimeOfDay time,
  }) async {
    await eventsCollection.add({
      'title': title,
      'date': Timestamp.fromDate(date),
      'time': '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getEvents() {
    return eventsCollection.orderBy('date').snapshots();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String dueDate,
    required String priority,
  }) async {
    await tasksCollection.add({
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getTasks() {
    return tasksCollection.orderBy('created_at', descending: true).snapshots();
  }

  Future<void> deleteTask(String taskId) async {
    await tasksCollection.doc(taskId).delete();
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    await tasksCollection.doc(taskId).update(data);
  }
}

