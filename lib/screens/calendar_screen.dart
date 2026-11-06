import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/storage_service.dart';
import '../widgets/sidebar.dart';
import '../widgets/task_card.dart';
import '../widgets/task_dialog.dart';
import '../widgets/week_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarPage currentPage = CalendarPage.calendar;
  List<CalendarTask> tasks = [];
  bool loading = true;
  DateTime weekStart = _monday(DateTime.now());

  static DateTime _monday(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loaded = await StorageService.loadTasks();

    if (!mounted) return;

    setState(() {
      tasks = loaded;
      loading = false;
    });
  }

  Future<void> _save() => StorageService.saveTasks(tasks);

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<CalendarTask> _todayTasks() {
    return tasks.where((task) => _sameDay(task.date, DateTime.now())).toList()
      ..sort(
        (a, b) => (a.startTime.hour * 60 + a.startTime.minute)
            .compareTo(b.startTime.hour * 60 + b.startTime.minute),
      );
  }

  Future<void> _openTask({
    CalendarTask? task,
    DateTime? initialDate,
  }) async {
    final result = await showDialog<CalendarTask>(
      context: context,
      barrierDismissible: false,
      builder: (_) => TaskDialog(
        task: task,
        initialDate: initialDate,
      ),
    );

    if (result == null) return;

    setState(() {
      final index = tasks.indexWhere((item) => item.id == result.id);

      if (index == -1) {
        tasks.add(result);
      } else {
        tasks[index] = result;
      }
    });

    await _save();
  }

  Future<void> _deleteTask(CalendarTask task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa công việc?'),
        content: Text('Bạn có chắc muốn xóa "${task.title}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      tasks.removeWhere((item) => item.id == task.id);
    });

    await _save();
  }

  Future<void> _toggleTask(CalendarTask task) async {
    setState(() {
      task.completed = !task.completed;
    });

    await _save();
  }

  void _goToday() {
    setState(() {
      weekStart = _monday(DateTime.now());
    });
  }

  String _monthYear(DateTime date) {
    const months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          CalendarSidebar(
            currentPage: currentPage,
            onPageChanged: (page) {
              setState(() => currentPage = page);
            },
          ),
          Expanded(child: _pageContent()),
        ],
      ),
      floatingActionButton: currentPage == CalendarPage.settings
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openTask(
                initialDate: DateTime.now(),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Thêm công việc'),
            ),
    );
  }

  Widget _pageContent() {
    switch (currentPage) {
      case CalendarPage.calendar:
        return _calendarPage();
      case CalendarPage.today:
        return _todayPage();
      case CalendarPage.tasks:
        return _tasksPage();
      case CalendarPage.settings:
        return _settingsPage();
    }
  }

  Widget _header(String title, String subtitle) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF858C9B), fontSize: 13),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFEEF3FF),
            foregroundColor: const Color(0xFF4C70DC),
            elevation: 0,
          ),
          onPressed: _goToday,
          icon: const Icon(Icons.today_outlined),
          label: const Text('Hôm nay'),
        ),
      ],
    );
  }

  Widget _calendarPage() {
    final lastDay = weekStart.add(const Duration(days: 6));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header('Lịch tuần', _monthYear(weekStart)),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11), border: Border.all(color: const Color(0xFFE4E7EE))),
                  child: IconButton(
                  tooltip: 'Tuần trước',
                  onPressed: () {
                    setState(() {
                      weekStart = weekStart.subtract(
                        const Duration(days: 7),
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_left, size: 19),
                  ),
                ),
                const SizedBox(width: 7),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11), border: Border.all(color: const Color(0xFFE4E7EE))),
                  child: IconButton(
                  tooltip: 'Tuần sau',
                  onPressed: () {
                    setState(() {
                      weekStart = weekStart.add(
                        const Duration(days: 7),
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_right, size: 19),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${weekStart.day}/${weekStart.month}'
                  ' - ${lastDay.day}/${lastDay.month}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _summaryCard(Icons.event_note_rounded, '${tasks.length}', 'Tổng công việc', const Color(0xFF5B8DEF)),
                const SizedBox(width: 10),
                _summaryCard(Icons.check_circle_outline_rounded, '${tasks.where((t) => t.completed).length}', 'Đã hoàn thành', const Color(0xFF36A269)),
                const SizedBox(width: 10),
                _summaryCard(Icons.pending_actions_rounded, '${tasks.where((t) => !t.completed).length}', 'Chưa hoàn thành', const Color(0xFFF2A93B)),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: WeekCalendar(
                weekStart: weekStart,
                tasks: tasks,
                onEmptyCellDoubleTap: (date) {
                  _openTask(initialDate: date);
                },
                onTaskTap: (task) {
                  _openTask(task: task);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7EAF1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 9),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Color(0xFF858C9B), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _todayPage() {
    final list = _todayTasks();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(
              'Hôm nay',
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            ),
            const SizedBox(height: 22),
            if (list.isEmpty)
              _empty(
                'Hôm nay chưa có công việc',
                'Bấm “Thêm công việc” để tạo lịch.',
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    final task = list[index];

                    return TaskCard(
                      task: task,
                      onEdit: () => _openTask(task: task),
                      onDelete: () => _deleteTask(task),
                      onCompleted: (_) => _toggleTask(task),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _tasksPage() {
    final list = [...tasks]
      ..sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) return dateCompare;

        return (a.startTime.hour * 60 + a.startTime.minute)
            .compareTo(b.startTime.hour * 60 + b.startTime.minute);
      });

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(
              'Công việc',
              '${tasks.length} công việc',
            ),
            const SizedBox(height: 20),
            if (list.isEmpty)
              _empty(
                'Chưa có công việc',
                'Tạo công việc đầu tiên của bạn.',
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    final task = list[index];

                    return TaskCard(
                      task: task,
                      onEdit: () => _openTask(task: task),
                      onDelete: () => _deleteTask(task),
                      onCompleted: (_) => _toggleTask(task),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _settingsPage() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(
              'Cài đặt',
              'Thiết lập ứng dụng',
            ),
            const SizedBox(height: 25),
            Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE2E5EC),
                ),
                boxShadow: const [BoxShadow(color: Color(0x081E2A44), blurRadius: 18, offset: Offset(0, 6))],
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.storage_outlined),
                    title: Text('Lưu trữ cục bộ'),
                    subtitle: Text(
                      'Công việc được lưu trên trình duyệt bằng SharedPreferences.',
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_sweep_outlined,
                      color: Colors.red,
                    ),
                    title: const Text('Xóa toàn bộ công việc'),
                    subtitle: const Text(
                      'Tất cả dữ liệu lịch sẽ bị xóa.',
                    ),
                    trailing: OutlinedButton(
                      onPressed: _clearAll,
                      child: const Text('Xóa'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa tất cả công việc?'),
        content: const Text(
          'Thao tác này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa tất cả'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => tasks.clear());
    await StorageService.clearTasks();
  }

  Widget _empty(String title, String subtitle) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_available_outlined,
              size: 65,
              color: Colors.black26,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
