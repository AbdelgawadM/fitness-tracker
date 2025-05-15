import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  // final String gender;
  // final String dob;
  // final int height;
  // final int weight;
  // final String activityLevel;
  // final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    // required this.gender,
    // required this.dob,
    // required this.height,
    // required this.weight,
    // required this.activityLevel,
    // this.createdAt,
  });

  // 🔄 Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      // 'gender': gender,
      // 'dob': dob,
      // 'height': height,
      // 'weight': weight,
      // 'activity_level': activityLevel,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // 🔁 Convert from Firestore snapshot
  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'],
      email: map['email'],
      // gender: map['gender'],
      // dob: map['dob'],
      // height: map['height'],
      // weight: map['weight'],
      // activityLevel: map['activity_level'],
      // createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
