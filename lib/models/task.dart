import 'package:flutter/material.dart';

class CalendarTask {
  String id;
  String title;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String note;
  int colorValue;
  bool completed;

  CalendarTask({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.note = '',
    this.colorValue = 0xFF5B8DEF,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startHour': startTime.hour,
      'startMinute': startTime.minute,
      'endHour': endTime.hour,
      'endMinute': endTime.minute,
      'note': note,
      'colorValue': colorValue,
      'completed': completed,
    };
  }

  factory CalendarTask.fromJson(Map<String, dynamic> json) {
    return CalendarTask(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: TimeOfDay(
        hour: json['startHour'] as int,
        minute: json['startMinute'] as int,
      ),
      endTime: TimeOfDay(
        hour: json['endHour'] as int,
        minute: json['endMinute'] as int,
      ),
      note: (json['note'] ?? '') as String,
      colorValue: (json['colorValue'] ?? 0xFF5B8DEF) as int,
      completed: (json['completed'] ?? false) as bool,
    );
  }
}
