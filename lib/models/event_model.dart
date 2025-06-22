import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  final String title;
  final DateTime date;
  final TimeOfDay time;

  Event({
    required this.title,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date),
      'time': '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    final timeParts = map['time'].split(':');
    return Event(
      title: map['title'],
      date: (map['date'] as Timestamp).toDate(),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
    );
  }
}
