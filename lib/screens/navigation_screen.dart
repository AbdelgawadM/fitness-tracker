import 'package:fitness_tracker/auth/services/auth_service.dart';
import 'package:fitness_tracker/auth/services/googke_fit.dart';
import 'package:fitness_tracker/models/fitness_data_model.dart';
import 'package:fitness_tracker/models/user_model.dart';
import 'package:fitness_tracker/screens/goal_screen.dart';
import 'package:fitness_tracker/screens/home_screen.dart';
import 'package:fitness_tracker/screens/progress_screen.dart';
import 'package:fitness_tracker/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key, required this.userModel});
  final UserModel userModel;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final RxInt bottomNavIndex = 0.obs;
  final RxBool isLoading = true.obs;

  final Rx<FitnessDataModel?> fitnessModel = Rx<FitnessDataModel?>(null);
  final Rx<FitnessDataModel?> fitnessGoal = Rx<FitnessDataModel?>(null);

  Future<void> _loadFitnessData() async {
    isLoading.value = true;
    try {
      final token = await AuthService().getAccessToken();
      if (token != null) {
        final model = await fetchFitnessData(token);
        fitnessModel.value = model;
        print('Today steps: ${model.steps}');
      } else {
        print('Failed to get access token');
      }
    } catch (e) {
      print('Error loading fitness data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getGoals() async {
    final goal = await getGoals();
    fitnessGoal.value = goal;
  }

  Future<void> _refreshData() async {
    await _loadFitnessData();
    await _getGoals();
  }

  final List<IconData> mainIcons = const [
    Icons.dashboard,
    Icons.edit_note,
    Icons.track_changes,
    Icons.show_chart,
    Icons.settings,
  ];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final currentFitnessModel =
          fitnessModel.value ?? FitnessDataModel.empty();
      final currentFitnessGoal = fitnessGoal.value ?? FitnessDataModel.empty();

      final screens = [
        HomeScreen(
          userModel: widget.userModel,
          fitnessModel: currentFitnessModel,
          fitnessGoal: currentFitnessGoal,
        ),
        GoalScreen(),
        GoalScreen(),
        ProgressScreen(data: currentFitnessModel, goal: currentFitnessGoal),
        SettingsScreen(
          userModel: widget.userModel,
          fitnessGoal: currentFitnessGoal,
          fitnessModel: currentFitnessModel,
        ),
      ];

      return Scaffold(
        appBar: AppBar(
          title: const Text('Fitness'),
          actions: [
            isLoading.value
                ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
                : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshData,
                ),
          ],
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          splashSpeedInMilliseconds: 1,
          backgroundColor: theme.primaryColor,
          activeColor: theme.textTheme.bodyLarge!.color,
          inactiveColor: theme.textTheme.bodyMedium!.color,
          icons: mainIcons,
          iconSize: 35,
          activeIndex: bottomNavIndex.value,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          gapLocation: GapLocation.none,
          onTap: (index) {
            bottomNavIndex.value = index;
          },
        ),
        body: screens[bottomNavIndex.value],
      );
    });
  }
}
