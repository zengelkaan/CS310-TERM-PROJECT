import 'package:cloud_firestore/cloud_firestore.dart';

class PetModel {
  final String id;
  final String ownerId;
  final String name;
  final String kind;
  final String breed;
  final String gender;
  final String age;
  final int? ageInMonths;
  final List<String> photos;
  final String about;
  final String purpose; // "Adoption", "Dating", "Both"
  final bool available;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status; // "active", "adopted", "pending"

  PetModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.kind,
    required this.breed,
    required this.gender,
    required this.age,
    this.ageInMonths,
    required this.photos,
    required this.about,
    required this.purpose,
    required this.available,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory PetModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PetModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      kind: data['kind'] ?? '',
      breed: data['breed'] ?? '',
      gender: data['gender'] ?? '',
      age: data['age'] ?? '',
      ageInMonths: data['ageInMonths'],
      photos: List<String>.from(data['photos'] ?? []),
      about: data['about'] ?? '',
      purpose: data['purpose'] ?? 'Adoption',
      available: data['available'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      status: data['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'name': name,
      'kind': kind,
      'breed': breed,
      'gender': gender,
      'age': age,
      if (ageInMonths != null) 'ageInMonths': ageInMonths,
      'photos': photos,
      'about': about,
      'purpose': purpose,
      'available': available,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'status': status,
    };
  }
}

