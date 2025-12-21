import '../models/pet_model.dart';
import '../models/user_model.dart';
import '../models/feeding_point_model.dart';
import '../models/vaccination_model.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockDataService {
  static List<PetModel> getMockPets() {
    return [
      PetModel(
        id: 'pet1',
        ownerId: 'user1',
        name: 'Bal',
        kind: 'Cat',
        breed: 'Persian',
        gender: 'Female',
        age: '2 years',
        ageInMonths: 24,
        photos: [],
        about: 'Bal is a beautiful Persian cat. She is very friendly and loves to cuddle.',
        purpose: 'Both',
        available: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        status: 'active',
      ),
      PetModel(
        id: 'pet2',
        ownerId: 'user1',
        name: 'Şimanski',
        kind: 'Cat',
        breed: 'British Shorthair',
        gender: 'Male',
        age: '3 years',
        ageInMonths: 36,
        photos: [],
        about: 'Şimanski is a calm and gentle British Shorthair.',
        purpose: 'Dating',
        available: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
        status: 'active',
      ),
      PetModel(
        id: 'pet3',
        ownerId: 'user1',
        name: 'Limon',
        kind: 'Cat',
        breed: 'Siamese',
        gender: 'Female',
        age: '1 year',
        ageInMonths: 12,
        photos: [],
        about: 'Limon is a playful Siamese kitten.',
        purpose: 'Adoption',
        available: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
        status: 'active',
      ),
      PetModel(
        id: 'pet4',
        ownerId: 'user2',
        name: 'Max',
        kind: 'Dog',
        breed: 'Golden Retriever',
        gender: 'Male',
        age: '3 years',
        ageInMonths: 36,
        photos: [],
        about: 'Max is a healthy 3-year-old Golden Retriever looking for his first mate.',
        purpose: 'Dating',
        available: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
        status: 'active',
      ),
      PetModel(
        id: 'pet5',
        ownerId: 'user6',
        name: 'Luna',
        kind: 'Cat',
        breed: 'Siamese',
        gender: 'Female',
        age: '2 years',
        ageInMonths: 24,
        photos: [],
        about: 'Luna is a beautiful Siamese cat with striking blue eyes.',
        purpose: 'Both',
        available: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
        status: 'active',
      ),
      PetModel(
        id: 'pet6',
        ownerId: 'user5',
        name: 'Coco',
        kind: 'Rabbit',
        breed: 'Holland Lop',
        gender: 'Female',
        age: '1 year',
        ageInMonths: 12,
        photos: [],
        about: 'Coco is a cute Holland Lop rabbit.',
        purpose: 'Adoption',
        available: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
        status: 'active',
      ),
    ];
  }

  static List<FeedingPointModel> getMockFeedingPoints() {
    return [
      FeedingPointModel(
        id: 'fp1',
        creatorId: 'user5',
        title: 'Dormitory',
        description: 'Feeding point near the university dormitory entrance',
        location: FeedingLocation(
          address: 'Sabanci University Dormitory, Orhanli, Tuzla, Istanbul',
          coordinates: Coordinates(latitude: 40.8931, longitude: 29.3762),
        ),
        verified: true,
        rating: 4.5,
        ratingsCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
        active: true,
      ),
      FeedingPointModel(
        id: 'fp2',
        creatorId: 'user5',
        title: 'Faculty of Engineering',
        description: 'Feeding station at the engineering building entrance',
        location: FeedingLocation(
          address: 'Sabanci University Faculty of Engineering, Orhanli, Tuzla, Istanbul',
          coordinates: Coordinates(latitude: 40.8950, longitude: 29.3780),
        ),
        verified: true,
        rating: 4.2,
        ratingsCount: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 50)),
        updatedAt: DateTime.now(),
        active: true,
      ),
      FeedingPointModel(
        id: 'fp3',
        creatorId: 'user3',
        title: 'Library Entrance',
        description: 'Small feeding area near the library',
        location: FeedingLocation(
          address: 'Sabanci University Library, Orhanli, Tuzla, Istanbul',
          coordinates: Coordinates(latitude: 40.8920, longitude: 29.3770),
        ),
        verified: false,
        rating: 4.0,
        ratingsCount: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 40)),
        updatedAt: DateTime.now(),
        active: true,
      ),
    ];
  }

  static List<VaccinationModel> getMockVaccinations() {
    return [
      VaccinationModel(
        id: 'vacc1',
        petId: 'pet1',
        ownerId: 'user1',
        title: 'Rabies',
        date: DateTime.now().add(const Duration(days: 30)),
        completed: false,
        reminderSent: false,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      VaccinationModel(
        id: 'vacc2',
        petId: 'pet1',
        ownerId: 'user1',
        title: 'FVRCP',
        date: DateTime.now().add(const Duration(days: 7)),
        completed: false,
        reminderSent: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      VaccinationModel(
        id: 'vacc3',
        petId: 'pet2',
        ownerId: 'user1',
        title: 'Rabies',
        date: DateTime.now().subtract(const Duration(days: 15)),
        completed: true,
        reminderSent: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }
}

