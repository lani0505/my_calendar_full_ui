import 'package:flutter/material.dart';
import '../models/task.dart';

class WeekCalendar extends StatelessWidget {
  final DateTime weekStart;
  final List<CalendarTask> tasks;
  final ValueChanged<DateTime> onEmptyCellDoubleTap;
  final ValueChanged<CalendarTask> onTaskTap;

  const WeekCalendar({
    super.key,
    required this.weekStart,
    required this.tasks,
    required this.onEmptyCellDoubleTap,
    required this.onTaskTap,
  });

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _time(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  List<CalendarTask> _forDay(DateTime day) {
    final result = tasks.where((t) => _sameDay(t.date, day)).toList();
    result.sort((a, b) => (a.startTime.hour * 60 + a.startTime.minute)
        .compareTo(b.startTime.hour * 60 + b.startTime.minute));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (index) => weekStart.add(Duration(days: index)));
    const names = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x0C1E2A44), blurRadius: 20, offset: Offset(0, 7)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 76,
            color: const Color(0xFFFBFCFE),
            child: Row(
              children: [
                const SizedBox(width: 70, child: Center(child: Icon(Icons.schedule_rounded, size: 18, color: Color(0xFF9AA1B2)))),
                ...List.generate(7, (index) {
                  final day = days[index];
                  final today = _sameDay(day, DateTime.now());
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: today ? const Color(0xFFF0F4FF) : Colors.transparent,
                        border: const Border(left: BorderSide(color: Color(0xFFE9ECF2))),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(names[index], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: today ? const Color(0xFF5877E5) : const Color(0xFF9298A7))),
                            const SizedBox(height: 4),
                            Container(
                              width: 31,
                              height: 31,
                              alignment: Alignment.center,
                              decoration: today ? BoxDecoration(color: const Color(0xFF5B8DEF), shape: BoxShape.circle) : null,
                              child: Text('${day.day}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: today ? Colors.white : const Color(0xFF303542))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(14, (index) {
                    final hour = index + 6;
                    return SizedBox(
                      height: 76,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 70,
                            child: Center(child: Text('$hour:00', style: const TextStyle(fontSize: 11, color: Color(0xFF9AA1B2), fontWeight: FontWeight.w600))),
                          ),
                          ...days.map((day) {
                            final dayTasks = _forDay(day).where((task) => task.startTime.hour == hour).toList();
                            return Expanded(
                              child: InkWell(
                                onDoubleTap: () => onEmptyCellDoubleTap(DateTime(day.year, day.month, day.day, hour)),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    border: Border(left: BorderSide(color: Color(0xFFE9ECF2)), bottom: BorderSide(color: Color(0xFFF0F2F6))),
                                  ),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: dayTasks.map(_task).toList()),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _task(CalendarTask task) {
    final color = Color(task.colorValue);
    return InkWell(
      onTap: () => onTaskTap(task),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: color.withAlpha(28),
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF343947), decoration: task.completed ? TextDecoration.lineThrough : null)),
            const SizedBox(height: 2),
            Text('${_time(task.startTime)} - ${_time(task.endTime)}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}
