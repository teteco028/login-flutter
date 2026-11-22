import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/task.dart';
import 'login_screen.dart';
import 'task_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    required this.userName,
    super.key,
  });

  final String userName;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateUtils.dateOnly(DateTime.now());
  final Map<DateTime, List<Task>> _tasksByDay = {};

  List<Task> _tasksForDay(DateTime day) {
    return _tasksByDay[DateUtils.dateOnly(day)] ?? const <Task>[];
  }

  Future<void> _openTasks(DateTime day) async {
    final normalizedDay = DateUtils.dateOnly(day);
    final tasks = _tasksByDay.putIfAbsent(normalizedDay, () => <Task>[]);
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => TaskScreen(
          selectedDate: normalizedDay,
          tasks: tasks,
          onTasksChanged: () {
            if (mounted) setState(() {});
          },
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  String get _greetingName {
    final name = widget.userName.trim();
    return name.isEmpty ? 'por aqui' : name.split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedCount = _tasksByDay.values
        .expand((tasks) => tasks)
        .where((task) => task.completed)
        .length;
    final pendingCount = _tasksByDay.values
        .expand((tasks) => tasks)
        .where((task) => !task.completed)
        .length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
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
                            colors: [Color(0xFF35E0C1), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: Color(0xFF090B14),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'neon daily',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Sair',
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Olá, $_greetingName 👋',
                    style: const TextStyle(
                      color: Color(0xFF35E0C1),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Um dia de cada vez.',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Escolha uma data para ver e cuidar das suas tarefas.',
                    style: TextStyle(color: Color(0xFF9BA2B7), fontSize: 14),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      _SummaryCard(
                        label: 'Pendentes',
                        count: pendingCount,
                        color: const Color(0xFF8B5CF6),
                        icon: Icons.bolt_rounded,
                      ),
                      const SizedBox(width: 12),
                      _SummaryCard(
                        label: 'Concluídas',
                        count: completedCount,
                        color: const Color(0xFF35E0C1),
                        icon: Icons.check_circle_outline_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141827).withOpacity(0.92),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 26,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: TableCalendar<Task>(
                      firstDay: DateTime.utc(2000, 1, 1),
                      lastDay: DateTime.utc(2100, 12, 31),
                      locale: 'pt_BR',
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      eventLoader: _tasksForDay,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarFormat: CalendarFormat.month,
                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                        leftChevronIcon: Icon(
                          Icons.chevron_left_rounded,
                          color: Color(0xFFADB3C7),
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFFADB3C7),
                        ),
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          color: Color(0xFF8E95AD),
                          fontWeight: FontWeight.w600,
                        ),
                        weekendStyle: TextStyle(
                          color: Color(0xFF8E95AD),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        defaultTextStyle: const TextStyle(color: Colors.white),
                        weekendTextStyle:
                            const TextStyle(color: Color(0xFFADB3C7)),
                        todayDecoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6).withOpacity(0.28),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: Color(0xFF35E0C1),
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: const TextStyle(
                          color: Color(0xFF090B14),
                          fontWeight: FontWeight.w800,
                        ),
                        markerDecoration: const BoxDecoration(
                          color: Color(0xFF35E0C1),
                          shape: BoxShape.circle,
                        ),
                        markersMaxCount: 3,
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = DateUtils.dateOnly(selectedDay);
                          _focusedDay = focusedDay;
                        });
                        _openTasks(selectedDay);
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.touch_app_rounded,
                          color: Color(0xFF35E0C1),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Toque em uma data para abrir suas tarefas.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFFADB3C7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  final String label;
  final int count;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.19)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFADB3C7),
                      fontSize: 11,
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
}

