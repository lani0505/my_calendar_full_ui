import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDialog extends StatefulWidget {
  final CalendarTask? task;
  final DateTime? initialDate;

  const TaskDialog({
    super.key,
    this.task,
    this.initialDate,
  });

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late final TextEditingController titleController;
  late final TextEditingController noteController;

  late DateTime selectedDate;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late int colorValue;

  final List<int> colors = const [
    0xFF5B8DEF,
    0xFFEF6C8F,
    0xFF36A269,
    0xFFF2A93B,
    0xFF9B72CF,
  ];

  @override
  void initState() {
    super.initState();

    final task = widget.task;
    final initial = widget.initialDate ?? DateTime.now();

    titleController = TextEditingController(text: task?.title ?? '');
    noteController = TextEditingController(text: task?.note ?? '');

    selectedDate = task?.date ??
        DateTime(initial.year, initial.month, initial.day);

    startTime = task?.startTime ??
        TimeOfDay(hour: initial.hour.clamp(7, 22), minute: 0);

    endTime = task?.endTime ??
        TimeOfDay(hour: (startTime.hour + 1).clamp(1, 23), minute: 0);

    colorValue = task?.colorValue ?? colors.first;
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  int _minutes(TimeOfDay t) => t.hour * 60 + t.minute;

  String _time(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}';

  Future<void> _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _chooseTime(bool start) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: start ? startTime : endTime,
    );

    if (picked == null) return;

    setState(() {
      if (start) {
        startTime = picked;
        if (_minutes(endTime) <= _minutes(startTime)) {
          endTime = TimeOfDay(
            hour: (startTime.hour + 1) % 24,
            minute: startTime.minute,
          );
        }
      } else {
        endTime = picked;
      }
    });
  }

  void _save() {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên công việc.')),
      );
      return;
    }

    if (_minutes(endTime) <= _minutes(startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giờ kết thúc phải sau giờ bắt đầu.'),
        ),
      );
      return;
    }

    final result = CalendarTask(
      id: widget.task?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      date: selectedDate,
      startTime: startTime,
      endTime: endTime,
      note: noteController.text.trim(),
      colorValue: colorValue,
      completed: widget.task?.completed ?? false,
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.task != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text(editing ? 'Chỉnh sửa công việc' : 'Thêm công việc'),
      content: SizedBox(
        width: 510,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Tên công việc *',
                  prefixIcon: Icon(Icons.edit_note),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              _picker(
                Icons.calendar_today_outlined,
                'Ngày',
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                _chooseDate,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _picker(
                      Icons.schedule,
                      'Bắt đầu',
                      _time(startTime),
                      () => _chooseTime(true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _picker(
                      Icons.schedule_outlined,
                      'Kết thúc',
                      _time(endTime),
                      () => _chooseTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Màu công việc',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 9),
              Row(
                children: colors.map((value) {
                  final selected = value == colorValue;

                  return GestureDetector(
                    onTap: () => setState(() => colorValue = value),
                    child: Container(
                      width: 35,
                      height: 35,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Color(value),
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(
                                color: Colors.black87,
                                width: 3,
                              )
                            : null,
                      ),
                      child: selected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save_outlined),
          label: Text(editing ? 'Lưu thay đổi' : 'Thêm'),
        ),
      ],
    );
  }

  Widget _picker(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        child: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
