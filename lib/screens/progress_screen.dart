import 'package:fitness_tracker/models/fitness_data_model.dart';
import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  final FitnessDataModel data;
  final FitnessDataModel goal;

  const ProgressScreen({super.key, required this.data, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Progress Overview')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Daily Progress',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            _buildProgressBar(
              title: 'Steps',
              current: data.steps.toDouble(),
              goal: goal.steps.toDouble(),
              color: Colors.blue,
            ),
            _buildProgressBar(
              title: 'Calories',
              current: data.calories,
              goal: goal.calories,
              color: Colors.red,
            ),
            _buildProgressBar(
              title: 'Active Minutes',
              current: data.activeMinutes.toDouble(),
              goal: goal.activeMinutes.toDouble(),
              color: Colors.green,
            ),
            _buildProgressBar(
              title: 'Distance (m)',
              current: data.distanceMeters,
              goal: goal.distanceMeters,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar({
    required String title,
    required double current,
    required double goal,
    required Color color,
  }) {
    final percentage = (goal == 0) ? 0.0 : (current / goal).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ${current.toStringAsFixed(0)} / ${goal.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 22,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
