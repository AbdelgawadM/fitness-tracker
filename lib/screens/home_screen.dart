import 'package:fitness_tracker/models/fitness_data_model.dart';
import 'package:fitness_tracker/models/user_model.dart';
import 'package:fitness_tracker/widgets/info_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.userModel,
    required this.fitnessModel,
    this.fitnessGoal,
  });

  final UserModel userModel;
  final FitnessDataModel? fitnessModel;
  final FitnessDataModel? fitnessGoal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (fitnessModel == null) {
      return const Scaffold(
        body: Center(child: Text("No fitness data available")),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${userModel.name} 👋',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Text(
              'Today\'s ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} Summary 🌡',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            InfoCard(
              title: '👣 Steps',
              value:
                  '${fitnessModel!.steps}${fitnessGoal != null ? ' / ${fitnessGoal!.steps}' : ''}',
            ),
            InfoCard(
              title: '🔥 Calories',
              value:
                  '${fitnessModel!.calories.round()}${fitnessGoal != null ? ' / ${fitnessGoal!.calories}' : ''}',
            ),
            InfoCard(
              title: '⌛ Active Minutes',
              value:
                  '${fitnessModel!.activeMinutes}${fitnessGoal != null ? ' / ${fitnessGoal!.activeMinutes}' : ''}',
            ),
            InfoCard(
              title: '🚶‍♂ Distance (m)',
              value:
                  '${fitnessModel!.distanceMeters.round()}${fitnessGoal != null ? ' / ${fitnessGoal!.distanceMeters.round()}' : ''}',
            ),
          ],
        ),
      ),
    );
  }
}
