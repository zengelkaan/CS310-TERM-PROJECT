import 'package:cloud_firestore/cloud_firestore.dart';

class VaccinationModel {
  final String id;
  final String petId;
  final String ownerId;
  final String title;
  final DateTime date;
  final bool completed;
  final bool reminderSent;
  final DateTime createdAt;
  final DateTime updatedAt;

  VaccinationModel({
    required this.id,
    required this.petId,
    required this.ownerId,
    required this.title,
    required this.date,
    required this.completed,
    required this.reminderSent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VaccinationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VaccinationModel(
      id: doc.id,
      petId: data['petId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      title: data['title'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      completed: data['completed'] ?? false,
      reminderSent: data['reminderSent'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'petId': petId,
      'ownerId': ownerId,
      'title': title,
      'date': Timestamp.fromDate(date),
      'completed': completed,
      'reminderSent': reminderSent,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

