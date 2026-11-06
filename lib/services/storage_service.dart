import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _key = 'my_calendar_tasks';

  static Future<List<CalendarTask>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((item) => CalendarTask.fromJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveTasks(List<CalendarTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final data = tasks.map((task) => task.toJson()).toList();
    await prefs.setString(_key, jsonEncode(data));
  }

  static Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
