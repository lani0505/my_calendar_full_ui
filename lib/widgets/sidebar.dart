import 'package:flutter/material.dart';

enum CalendarPage { calendar, today, tasks, settings }

class CalendarSidebar extends StatelessWidget {
  final CalendarPage currentPage;
  final ValueChanged<CalendarPage> onPageChanged;

  const CalendarSidebar({
    super.key,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE9ECF3)),),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6D8DFF), Color(0xFF8C6CFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x226D8DFF),
                          blurRadius: 14,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 11),
                  const Expanded(
                    child: Text(
                      'My Calendar',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              const Padding(
                padding: EdgeInsets.only(left: 12, bottom: 9),
                child: Text(
                  'MENU',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.3,
                    color: Color(0xFF9AA1B2),
                  ),
                ),
              ),
              _item(Icons.calendar_view_week_rounded, 'Lịch tuần', CalendarPage.calendar),
              _item(Icons.today_rounded, 'Hôm nay', CalendarPage.today),
              _item(Icons.task_alt_rounded, 'Công việc', CalendarPage.tasks),
              _item(Icons.settings_outlined, 'Cài đặt', CalendarPage.settings),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEEF0F5)),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Color(0xFFEAF0FF),
                      child: Icon(Icons.cloud_done_outlined, color: Color(0xFF5B8DEF), size: 18),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Đã lưu', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                          SizedBox(height: 2),
                          Text('Dữ liệu trên thiết bị', style: TextStyle(fontSize: 11, color: Colors.black45)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(IconData icon, String title, CalendarPage page) {
    final selected = currentPage == page;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onPageChanged(page),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEEF3FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: selected ? const Color(0xFF5578E8) : const Color(0xFF777F91)),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? const Color(0xFF4269DC) : const Color(0xFF454B59),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
