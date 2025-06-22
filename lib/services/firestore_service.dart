import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class FirestoreService {
  final CollectionReference eventsCollection =
  FirebaseFirestore.instance.collection('events');

  final CollectionReference tasksCollection =
  FirebaseFirestore.instance.collection('tasks');

  final CollectionReference locationsCollection =
  FirebaseFirestore.instance.collection('locations');


  Future<void> addEvent({
    required String title,
    required DateTime date,
    required String time,  // <-- change TimeOfDay to String here
  }) async {
    await eventsCollection.add({
      'title': title,
      'date': Timestamp.fromDate(date),
      'time': time,
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

  Future<DocumentReference> addLocation(LatLng latLng, String name) {
    return locationsCollection.add({
      'name': name,
      'latitude': latLng.latitude,
      'longitude': latLng.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getLocationsStream() {
    return locationsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'],
        'latLng': LatLng(doc['latitude'], doc['longitude']),
      };
    }).toList());
  }

  Future<void> deleteLocation(String id) async {
    await locationsCollection.doc(id).delete();
  }
}

