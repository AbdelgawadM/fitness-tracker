import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'goal_screen.dart';
import 'progress_screen.dart';
import '../models/user_model.dart';
import '../models/fitness_data_model.dart';

class SettingsScreen extends StatelessWidget {
  final UserModel userModel;
  final FitnessDataModel fitnessModel;
  final FitnessDataModel fitnessGoal;

  const SettingsScreen({
    super.key,
    required this.userModel,
    required this.fitnessModel,
    required this.fitnessGoal,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${userModel.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Text(
              'Account Info',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: Text(userModel.name),
                subtitle: Text(userModel.email),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Quick Access',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            _quickButton(
              context,
              icon: Icons.fitness_center,
              label: 'Log Workout',
              onTap: () {
                Get.snackbar('Feature', 'Log Workout tapped!');
              },
            ),
            const SizedBox(height: 16),
            _quickButton(
              context,
              icon: Icons.flag,
              label: 'View Goals',
              onTap: () {
                Get.to(() => GoalScreen());
              },
            ),
            const SizedBox(height: 16),
            _quickButton(
              context,
              icon: Icons.show_chart,
              label: 'See Progress',
              onTap: () {
                Get.to(
                  () => ProgressScreen(data: fitnessModel, goal: fitnessGoal),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final color = Theme.of(context).primaryColor;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            Icon(icon, size: 26, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
