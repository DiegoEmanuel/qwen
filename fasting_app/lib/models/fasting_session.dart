class FastingSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int targetDurationHours;
  final bool isCompleted;

  FastingSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.targetDurationHours,
    required this.isCompleted,
  });

  Duration get elapsedDuration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  Duration get remainingDuration {
    if (isCompleted || endTime != null) {
      return Duration.zero;
    }
    final target = Duration(hours: targetDurationHours);
    final elapsed = elapsedDuration;
    return elapsed > target ? Duration.zero : target - elapsed;
  }

  double get progressPercentage {
    final target = Duration(hours: targetDurationHours).inMinutes;
    final elapsed = elapsedDuration.inMinutes;
    return (elapsed / target).clamp(0.0, 1.0);
  }

  FastingSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? targetDurationHours,
    bool? isCompleted,
  }) {
    return FastingSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      targetDurationHours: targetDurationHours ?? this.targetDurationHours,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'targetDurationHours': targetDurationHours,
      'isCompleted': isCompleted,
    };
  }

  factory FastingSession.fromJson(Map<String, dynamic> json) {
    return FastingSession(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      targetDurationHours: json['targetDurationHours'],
      isCompleted: json['isCompleted'],
    );
  }
}
