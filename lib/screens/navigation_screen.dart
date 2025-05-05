import 'package:fitness_tracker/models/user_model.dart';
import 'package:fitness_tracker/screens/home_screen.dart';
import 'package:fitness_tracker/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key, required this.userModel});
  final UserModel userModel;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int bottomNavIndex = 0;

  final List<IconData> mainIcons = const [
    Icons.dashboard,
    Icons.edit_note,
    Icons.track_changes,
    Icons.show_chart,
    Icons.settings,
  ];
  late List<Widget> screens = [
    HomeScreen(userModel: widget.userModel),
    SettingsScreen(),
    SettingsScreen(),
    SettingsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Fitness')),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashSpeedInMilliseconds: 1,
        backgroundColor: theme.primaryColor,
        activeColor: theme.textTheme.bodyLarge!.color,
        inactiveColor: theme.textTheme.bodyMedium!.color,
        icons: mainIcons,
        iconSize: 35,
        activeIndex: bottomNavIndex,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        gapLocation: GapLocation.none,
        onTap: (index) {
          bottomNavIndex = index;
          setState(() {});
        },
      ),
      body: screens[bottomNavIndex],
    );
  }
}
