import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/auth/screens/login_screen.dart';
import 'package:fitness_tracker/auth/widgets/custom_text_field.dart';
import 'package:fitness_tracker/generated/l10n.dart';
import 'package:fitness_tracker/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class RegistScreen extends StatefulWidget {
  const RegistScreen({super.key});

  @override
  State<RegistScreen> createState() => _RegistScreenState();
}

class _RegistScreenState extends State<RegistScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController activityLevelController = TextEditingController();

  bool isLoading = false;

  void registerUser() async {
    setState(() => isLoading = true);

    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      String uid = userCredential.user!.uid;

      // Create user model
      final userModel = UserModel(
        uid: uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        // gender: genderController.text.trim(),
        // dob: dobController.text.trim(),
        // height: int.tryParse(heightController.text.trim()) ?? 0,
        // weight: int.tryParse(weightController.text.trim()) ?? 0,
        // activityLevel: activityLevelController.text.trim(),
      );

      // Save user to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userModel.toMap());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('✅ Registration successful')));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NavigationScreen(userModel: userModel),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('⚠️ ${e.message}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).register,
                    style: const TextStyle(fontSize: 40),
                  ),
                ],
              ),
              CustomTextField(hint: 'Name', controller: nameController),
              CustomTextField(hint: 'Email', controller: emailController),
              CustomTextField(hint: 'Password', controller: passwordController),
              CustomTextField(hint: 'Gender', controller: genderController),
              CustomTextField(
                hint: 'Date of Birth (YYYY-MM-DD)',
                controller: dobController,
              ),
              CustomTextField(
                hint: 'Height (cm)',
                controller: heightController,
              ),
              CustomTextField(
                hint: 'Weight (kg)',
                controller: weightController,
              ),
              CustomTextField(
                hint: 'Activity Level',
                controller: activityLevelController,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : registerUser,
                child:
                    isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Register'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
