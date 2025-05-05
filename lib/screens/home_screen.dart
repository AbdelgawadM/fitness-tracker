import 'package:fitness_tracker/models/user_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'HELLO ${userModel.name}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text('secondary', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
