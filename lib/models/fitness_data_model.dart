class FitnessDataModel {
  final int steps;
  final double calories;
  final int activeMinutes;
  final double distanceMeters;

  FitnessDataModel({
    required this.steps,
    required this.calories,
    required this.activeMinutes,
    required this.distanceMeters,
  });

  @override
  String toString() {
    return 'Steps: $steps, Calories: $calories, Active Minutes: $activeMinutes, Distance: $distanceMeters m';
  }

  Map<String, dynamic> toMap() => {
    'steps': steps,
    'calories': calories,
    'activeMinutes': activeMinutes,
    'distance': distanceMeters,
  };

  factory FitnessDataModel.fromMap(Map<String, dynamic> map) {
    return FitnessDataModel(
      steps: map['steps'] ?? 0,
      calories: (map['calories'] ?? 0).toDouble(),
      activeMinutes: map['activeMinutes'] ?? 0,
      distanceMeters: (map['distance'] ?? 0).toDouble(),
    );
  }
  factory FitnessDataModel.empty() {
    return FitnessDataModel(
      steps: 0,
      calories: 0,
      activeMinutes: 0,
      distanceMeters: 0,
    );
  }
}
