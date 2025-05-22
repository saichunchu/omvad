import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:hive/hive.dart';
import '../models/workout_session.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final String workoutTitle;
  final List<String> exercises;
  final String workoutType;

  const WorkoutDetailScreen({
    super.key,
    required this.workoutTitle,
    required this.exercises,
    required this.workoutType,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  int currentIndex = 0;
  int totalSeconds = 15;
  int secondsLeft = 15;
  Timer? timer;
  bool isRunning = false;

  void startTimer() {
    timer?.cancel();
    setState(() => isRunning = true);
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft <= 1) {
        t.cancel();
        moveToNext();
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void moveToNext() {
    if (currentIndex < widget.exercises.length - 1) {
      setState(() {
        currentIndex++;
        secondsLeft = totalSeconds;
      });
      startTimer();
    } else {
      timer?.cancel();
      _saveToHistory();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text("Workout Complete"),
          content: const Text("You've completed all exercises!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
              child: const Text("Home"),
            )
          ],
        ),
      );
    }
  }

  void _saveToHistory() async {
    final box = Hive.box<WorkoutSession>('history');
    final session = WorkoutSession(
      workoutType: widget.workoutType,
      exercises: widget.exercises,
      date: DateTime.now(),
    );
    await box.add(session);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = widget.exercises[currentIndex];
    final nextExercise = currentIndex < widget.exercises.length - 1
        ? widget.exercises[currentIndex + 1]
        : "None";
    final progress = secondsLeft / totalSeconds;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          widget.workoutType,
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Text(
              'Morning Workout',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentExercise.toLowerCase(),
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              height: 250,
              width: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 125,
                    lineWidth: 20,
                    percent: progress,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Colors.grey.shade300,
                    progressColor: Colors.greenAccent.shade400,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 72,
                          color: Colors.greenAccent,
                        ),
                        Text(
                          '$secondsLeft″',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? pauseTimer : startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    elevation: 4,
                  ),
                  child: Text(isRunning ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: moveToNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    elevation: 2,
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Next:\n$nextExercise',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
