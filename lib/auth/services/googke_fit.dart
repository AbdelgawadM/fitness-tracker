import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/models/fitness_data_model.dart';
import 'package:http/http.dart' as http;

Future<FitnessDataModel?> getGoals() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (doc.exists && doc.data()!.containsKey('fitnessGoals')) {
    return FitnessDataModel.fromMap(doc['fitnessGoals']);
  } else {
    return null;
  }
}

Future<FitnessDataModel> fetchFitnessData(String accessToken) async {
  final now = DateTime.now();
  final startTime =
      DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
  final endTime = now.millisecondsSinceEpoch;

  final url = Uri.parse(
    "https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate",
  );

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      "aggregateBy": [
        {"dataTypeName": "com.google.step_count.delta"},
        {"dataTypeName": "com.google.calories.expended"},
        {"dataTypeName": "com.google.active_minutes"},
        {"dataTypeName": "com.google.distance.delta"},
      ],
      "bucketByTime": {"durationMillis": 86400000}, // 1 day
      "startTimeMillis": startTime,
      "endTimeMillis": endTime,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    num totalSteps = 0;
    double totalCalories = 0;
    num totalActiveMinutes = 0;
    double totalDistance = 0;

    for (var bucket in data['bucket']) {
      for (var dataset in bucket['dataset']) {
        for (var point in dataset['point']) {
          final type = point['dataTypeName'];
          final value = point['value'][0];

          switch (type) {
            case "com.google.step_count.delta":
              totalSteps += value['intVal'] ?? 0;
              break;
            case "com.google.calories.expended":
              totalCalories += value['fpVal'] ?? 0.0;
              break;
            case "com.google.active_minutes":
              totalActiveMinutes += value['intVal'] ?? 0;
              break;
            case "com.google.distance.delta":
              totalDistance += value['fpVal'] ?? 0.0;
              break;
          }
        }
      }
    }

    return FitnessDataModel(
      steps: totalSteps.toInt(),
      calories: totalCalories,
      activeMinutes: totalActiveMinutes.toInt(),
      distanceMeters: totalDistance,
    );
  } else {
    throw Exception('Failed to fetch fitness data: ${response.body}');
  }
}
