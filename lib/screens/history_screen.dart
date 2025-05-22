import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:omvad/models/workout_session.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<DateTime, List<WorkoutSession>> workoutMap = {};
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _loadWorkouts() {
    final box = Hive.box<WorkoutSession>('history');
    for (var session in box.values) {
      final day =
          DateTime(session.date.year, session.date.month, session.date.day);
      workoutMap.putIfAbsent(day, () => []).add(session);
    }
  }

  List<WorkoutSession> _getSessionsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return workoutMap[key] ?? [];
  }

  int getWorkoutsThisWeek() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return workoutMap.entries
        .where((e) => e.key.isAfter(monday.subtract(const Duration(days: 1))))
        .fold<int>(0, (sum, e) => sum + e.value.length);
  }

  String getTopWorkoutType() {
    final counts = <String, int>{};
    for (var list in workoutMap.values) {
      for (var session in list) {
        counts[session.workoutType] = (counts[session.workoutType] ?? 0) + 1;
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.isEmpty ? 'None' : sorted.first.key;
  }

  @override
  Widget build(BuildContext context) {
    final selectedSessions = _getSessionsForDay(selectedDay);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildStats(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildCalendar(),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Workouts on ${DateFormat.yMMMd().format(selectedDay)}",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: selectedSessions.isEmpty
                ? const Center(
                    child: Text('No workouts for selected day',
                        style: TextStyle(color: Colors.white54)))
                : ListView.builder(
                    itemCount: selectedSessions.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final session = selectedSessions[index];
                      return _buildWorkoutCard(session);
                    },
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: (selected, focused) {
        setState(() {
          selectedDay = selected;
          focusedDay = focused;
        });
      },
      eventLoader: _getSessionsForDay,
      calendarStyle: CalendarStyle(
        todayDecoration:
            BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
        selectedDecoration:
            BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        weekendTextStyle: const TextStyle(color: Colors.redAccent),
        defaultTextStyle: const TextStyle(color: Colors.white),
        outsideDaysVisible: false,
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(color: Colors.white),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.grey),
        weekendStyle: TextStyle(color: Colors.redAccent),
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutSession session) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.workoutType,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(session.date),
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: session.exercises
                  .map((e) => Chip(
                        label: Text(e),
                        backgroundColor: Colors.green.shade300,
                        labelStyle: const TextStyle(color: Colors.black),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _statBox("This Week", getWorkoutsThisWeek().toString(),
                Icons.calendar_today),
            const SizedBox(width: 8),
            _statBox("Top Workout", getTopWorkoutType(), Icons.fitness_center),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String label, String value, IconData icon) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent, size: 28),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.white60)),
                Text(value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
