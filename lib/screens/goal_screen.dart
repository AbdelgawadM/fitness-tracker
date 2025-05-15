import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/models/fitness_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final _formKey = GlobalKey<FormState>();

  final stepsController = TextEditingController();
  final caloriesController = TextEditingController();
  final minutesController = TextEditingController();
  final distanceController = TextEditingController();

  final Rxn<FitnessDataModel> savedGoal = Rxn<FitnessDataModel>();

  Future<void> _saveGoals() async {
    if (_formKey.currentState!.validate()) {
      final model = FitnessDataModel(
        steps: int.parse(stepsController.text),
        calories: double.parse(caloriesController.text),
        activeMinutes: int.parse(minutesController.text),
        distanceMeters: double.parse(distanceController.text),
      );

      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fitnessGoals': model.toMap(),
      }, SetOptions(merge: true));

      savedGoal.value = model;

      Get.snackbar(
        "Success",
        "Goals saved successfully!",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _fetchGoals() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists && doc.data()!.containsKey('fitnessGoals')) {
      savedGoal.value = FitnessDataModel.fromMap(doc.data()!['fitnessGoals']);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "🏁 Ready to push your limits today?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildGoalField("Steps Goal", stepsController),
              _buildGoalField("Calories Goal (kcal)", caloriesController),
              _buildGoalField("Active Minutes Goal", minutesController),
              _buildGoalField("Distance Goal (meters)", distanceController),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _saveGoals,
                icon: const Icon(Icons.check),
                label: const Text("Save Goals"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),

              /// Grid shown reactively after saving or fetching
              Obx(() {
                if (savedGoal.value == null) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🎯 Your Current Goals",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildGoalsGrid(savedGoal.value!),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (val) {
          if (val == null || val.isEmpty) return "Enter your $label";
          if (double.tryParse(val) == null) return "Must be a number";
          if (double.parse(val) < 0) return "Cannot be negative";
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildGoalsGrid(FitnessDataModel model) {
    final List<Map<String, String>> goalItems = [
      {'label': 'Steps', 'value': model.steps.toString()},
      {'label': 'Calories (kcal)', 'value': model.calories.toStringAsFixed(0)},
      {'label': 'Minutes', 'value': model.activeMinutes.toString()},
      {
        'label': 'Distance (m)',
        'value': model.distanceMeters.toStringAsFixed(0),
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children:
          goalItems
              .map(
                (item) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item['value']!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['label']!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
