import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final CalendarTask task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onCompleted;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onCompleted,
  });

  String _time(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(task.colorValue);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE6E9F0)),
        boxShadow: const [BoxShadow(color: Color(0x081E2A44), blurRadius: 16, offset: Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 58,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 13),
          Checkbox(
            value: task.completed,
            onChanged: onCompleted,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${task.date.day}/${task.date.month}/${task.date.year}'
                  '  •  ${_time(task.startTime)} - ${_time(task.endTime)}',
                  style: const TextStyle(color: Colors.black54),
                ),
                if (task.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.note,
                    style: const TextStyle(color: Colors.black45),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: 'Sửa',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Xóa',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
