import 'package:flutter_test/flutter_test.dart';
import 'package:cs310_term_project/models/pet.dart';
import 'package:cs310_term_project/models/feeding_point.dart';

void main() {
  group('Pet Model Tests', () {
    test('Pet model creation with valid data', () {
      final pet = Pet(
        id: 'test_pet_1',
        name: 'Max',
        type: 'Dog',
        breed: 'Golden Retriever',
        gender: 'Male',
        age: '3 years',
        about: 'Friendly and energetic dog',
        imagePath: 'assets/images/max.jpg',
        isAvailableForAdoption: true,
        createdBy: 'user_123',
      );

      expect(pet.id, 'test_pet_1');
      expect(pet.name, 'Max');
      expect(pet.type, 'Dog');
      expect(pet.isAvailableForAdoption, true);
      expect(pet.createdBy, 'user_123');
      expect(pet.name.isNotEmpty, isTrue);
    });

    test('Pet adoption status can be toggled by creating a new object', () {
      final pet = Pet(
        id: 'test_pet_2',
        name: 'Buddy',
        type: 'Dog',
        breed: 'Labrador',
        gender: 'Male',
        age: '4 years',
        about: 'Good family dog',
        imagePath: 'assets/images/buddy.jpg',
        isAvailableForAdoption: false,
        createdBy: 'user_101',
      );

      final updatedPet = Pet(
        id: pet.id,
        name: pet.name,
        type: pet.type,
        breed: pet.breed,
        gender: pet.gender,
        age: pet.age,
        about: pet.about,
        imagePath: pet.imagePath,
        isAvailableForAdoption: !pet.isAvailableForAdoption,
        createdBy: pet.createdBy,
      );

      expect(pet.isAvailableForAdoption, isFalse);
      expect(updatedPet.isAvailableForAdoption, isTrue);
    });
  });

  group('FeedingPoint Model Tests', () {
    test('FeedingPoint model creation with valid data', () {
      final feedingPoint = FeedingPoint(
        id: 'fp_1',
        title: 'Campus Feeding Point',
        description: 'Near the library',
        imageUrl: 'assets/images/campus.jpg',
        buttonText: 'View Location',
        latitude: 41.0082,
        longitude: 28.9784,
        createdBy: 'user_202',
      );

      expect(feedingPoint.id, 'fp_1');
      expect(feedingPoint.title, 'Campus Feeding Point');
      expect(feedingPoint.latitude, 41.0082);
      expect(feedingPoint.longitude, 28.9784);
      expect(feedingPoint.title.isNotEmpty, isTrue);
    });

    test('FeedingPoint coordinates are within valid ranges', () {
      final feedingPoint = FeedingPoint(
        id: 'fp_2',
        title: 'Beach Feeding Spot',
        description: 'Near lifeguard station',
        imageUrl: 'assets/images/beach.jpg',
        buttonText: 'Get Directions',
        latitude: 34.0522,
        longitude: -118.2437,
        createdBy: 'user_505',
      );

      expect(feedingPoint.latitude, inInclusiveRange(-90.0, 90.0));
      expect(feedingPoint.longitude, inInclusiveRange(-180.0, 180.0));
    });
  });
}
