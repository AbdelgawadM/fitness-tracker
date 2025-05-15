import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/auth/services/auth_service.dart';
import 'package:fitness_tracker/models/user_model.dart';
import 'package:fitness_tracker/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthService _authService = AuthService();

  // Reactive loading state
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          if (isLoading.value) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Signing in...'),
              ],
            );
          }

          return ElevatedButton.icon(
            icon: Image.asset('assets/google_logo.png', height: 24, width: 24),
            label: const Text(
              'Sign in with Google',
              style: TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              isLoading.value = true;
              final user = await _authService.signInWithGoogle();
              if (user != null) {
                final model = UserModel(
                  uid: user.uid,
                  name: user.displayName ?? 'No Name',
                  email: user.email ?? '',
                );
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .set(model.toMap(), SetOptions(merge: true));
                isLoading.value = false;
                Get.off(() => NavigationScreen(userModel: model));
                print("Signed in as: ${user.displayName}");
              } else {
                isLoading.value = false;
                print("Sign-in cancelled or failed");
                Get.snackbar(
                  'Sign-in Failed',
                  'Please try again.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          );
        }),
      ),
    );
  }
}
