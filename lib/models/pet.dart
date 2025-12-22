import 'package:cloud_firestore/cloud_firestore.dart';
import 'vaccination.dart';

class Pet {
  final String? id;
  final String name;
  final String breed;
  final String gender;
  final String age;
  final String imagePath;
  final String type;
  final String? about;
  final bool isAvailableForAdoption;
  final String? createdBy;
  final Timestamp? createdAt;
  List<Vaccination> vaccinations;

  Pet({
    this.id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.age,
    required this.imagePath,
    this.type = 'Unknown',
    this.about,
    this.isAvailableForAdoption = false,
    this.createdBy,
    this.createdAt,
    List<Vaccination>? vaccinations,
  }) : vaccinations = vaccinations ?? [];

  // Convert to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'breed': breed,
      'gender': gender,
      'age': age,
      'imagePath': imagePath,
      'type': type,
      'about': about ?? '$name is a friendly pet looking for love!',
      'isAvailableForAdoption': isAvailableForAdoption,
      'createdBy': createdBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore document
  factory Pet.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Pet(
      id: doc.id,
      name: data['name'] ?? '',
      breed: data['breed'] ?? '',
      gender: data['gender'] ?? '',
      age: data['age'] ?? '',
      imagePath: data['imagePath'] ?? 'assets/images/max.jpg',
      type: data['type'] ?? 'Unknown',
      about: data['about'],
      isAvailableForAdoption: data['isAvailableForAdoption'] ?? false,
      createdBy: data['createdBy'],
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  // CopyWith method for updates
  Pet copyWith({
    String? id,
    String? name,
    String? breed,
    String? gender,
    String? age,
    String? imagePath,
    String? type,
    String? about,
    bool? isAvailableForAdoption,
    String? createdBy,
    Timestamp? createdAt,
    List<Vaccination>? vaccinations,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      imagePath: imagePath ?? this.imagePath,
      type: type ?? this.type,
      about: about ?? this.about,
      isAvailableForAdoption: isAvailableForAdoption ?? this.isAvailableForAdoption,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      vaccinations: vaccinations ?? this.vaccinations,
    );
  }
}
