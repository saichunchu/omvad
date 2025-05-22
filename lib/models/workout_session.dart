import 'package:hive/hive.dart';

part 'workout_session.g.dart'; // This must match filename exactly!

@HiveType(typeId: 0)
class WorkoutSession extends HiveObject {
  @HiveField(0)
  final String workoutType;

  @HiveField(1)
  final List<String> exercises;

  @HiveField(2)
  final DateTime date;

  WorkoutSession({
    required this.workoutType,
    required this.exercises,
    required this.date,
  });
}
