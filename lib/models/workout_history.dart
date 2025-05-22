class WorkoutHistory {
  final String workoutTitle;
  final DateTime date;

  WorkoutHistory({required this.workoutTitle, required this.date});

  Map<String, dynamic> toJson() => {
        'workoutTitle': workoutTitle,
        'date': date.toIso8601String(),
      };

  static WorkoutHistory fromJson(Map<String, dynamic> json) {
    return WorkoutHistory(
      workoutTitle: json['workoutTitle'],
      date: DateTime.parse(json['date']),
    );
  }
}
