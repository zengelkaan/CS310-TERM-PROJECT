import 'package:flutter_test/flutter_test.dart';
import 'package:cs310_term_project/models/pet.dart';
import 'package:cs310_term_project/models/feeding_point.dart';

void main() {
  group('Pet Model Tests', () {
    test('Pet model creation with valid data', () {
      // Arrange
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

      // Assert
      expect(pet.id, 'test_pet_1');
      expect(pet.name, 'Max');
      expect(pet.type, 'Dog');
      expect(pet.breed, 'Golden Retriever');
      expect(pet.gender, 'Male');
      expect(pet.age, '3 years');
      expect(pet.about, 'Friendly and energetic dog');
      expect(pet.imagePath, 'assets/images/max.jpg');
      expect(pet.isAvailableForAdoption, true);
      expect(pet.createdBy, 'user_123');
    });

    test('Pet model toMap conversion', () {
      // Arrange
      final pet = Pet(
        id: 'test_pet_2',
        name: 'Luna',
        type: 'Cat',
        breed: 'Persian',
        gender: 'Female',
        age: '2 years',
        about: 'Calm and affectionate',
        imagePath: 'assets/images/luna.jpg',
        isAvailableForAdoption: false,
        createdBy: 'user_456',
      );

      // Act
      final petMap = pet.toMap();

      // Assert
      expect(petMap['name'], 'Luna');
      expect(petMap['type'], 'Cat');
      expect(petMap['breed'], 'Persian');
      expect(petMap['gender'], 'Female');
      expect(petMap['age'], '2 years');
      expect(petMap['about'], 'Calm and affectionate');
      expect(petMap['imagePath'], 'assets/images/luna.jpg');
      expect(petMap['isAvailableForAdoption'], false);
      expect(petMap['createdBy'], 'user_456');
    });

    test('Pet model fromMap conversion', () {
      // Arrange
      final petData = {
        'name': 'Coco',
        'type': 'Dog',
        'breed': 'Beagle',
        'gender': 'Female',
        'age': '1 year',
        'about': 'Playful puppy',
        'imagePath': 'assets/images/coco.jpg',
        'isAvailableForAdoption': true,
        'createdBy': 'user_789',
      };

      // Act
      final pet = Pet.fromMap(petData, 'test_pet_3');

      // Assert
      expect(pet.id, 'test_pet_3');
      expect(pet.name, 'Coco');
      expect(pet.type, 'Dog');
      expect(pet.breed, 'Beagle');
      expect(pet.gender, 'Female');
      expect(pet.age, '1 year');
      expect(pet.about, 'Playful puppy');
      expect(pet.imagePath, 'assets/images/coco.jpg');
      expect(pet.isAvailableForAdoption, true);
      expect(pet.createdBy, 'user_789');
    });

    test('Pet adoption status toggle', () {
      // Arrange
      final pet = Pet(
        id: 'test_pet_4',
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

      // Act - Toggle adoption status
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

      // Assert
      expect(pet.isAvailableForAdoption, false);
      expect(updatedPet.isAvailableForAdoption, true);
    });

    test('Pet name should not be empty', () {
      // Arrange
      final pet = Pet(
        id: 'test_pet_5',
        name: 'Rocky',
        type: 'Dog',
        breed: 'Bulldog',
        gender: 'Male',
        age: '5 years',
        about: 'Strong and loyal',
        imagePath: 'assets/images/rocky.jpg',
        isAvailableForAdoption: true,
        createdBy: 'user_606',
      );

      // Assert
      expect(pet.name.isNotEmpty, true);
      expect(pet.name.length, greaterThan(0));
    });
  });

  group('Feeding Point Model Tests', () {
    test('FeedingPoint model creation with valid data', () {
      // Arrange
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

      // Assert
      expect(feedingPoint.id, 'fp_1');
      expect(feedingPoint.title, 'Campus Feeding Point');
      expect(feedingPoint.description, 'Near the library');
      expect(feedingPoint.imageUrl, 'assets/images/campus.jpg');
      expect(feedingPoint.buttonText, 'View Location');
      expect(feedingPoint.latitude, 41.0082);
      expect(feedingPoint.longitude, 28.9784);
      expect(feedingPoint.createdBy, 'user_202');
    });

    test('FeedingPoint model toMap conversion', () {
      // Arrange
      final feedingPoint = FeedingPoint(
        id: 'fp_2',
        title: 'Park Feeding Station',
        description: 'Main park entrance',
        imageUrl: 'assets/images/park.jpg',
        buttonText: 'Navigate',
        latitude: 40.7128,
        longitude: -74.0060,
        createdBy: 'user_303',
      );

      // Act
      final fpMap = feedingPoint.toMap();

      // Assert
      expect(fpMap['title'], 'Park Feeding Station');
      expect(fpMap['description'], 'Main park entrance');
      expect(fpMap['imageUrl'], 'assets/images/park.jpg');
      expect(fpMap['buttonText'], 'Navigate');
      expect(fpMap['latitude'], 40.7128);
      expect(fpMap['longitude'], -74.0060);
      expect(fpMap['createdBy'], 'user_303');
    });

    test('FeedingPoint model fromMap conversion', () {
      // Arrange
      final fpData = {
        'title': 'Downtown Feeding Area',
        'description': 'Behind the mall',
        'imageUrl': 'assets/images/downtown.jpg',
        'buttonText': 'Show Map',
        'latitude': 39.9042,
        'longitude': 116.4074,
        'createdBy': 'user_404',
      };

      // Act
      final feedingPoint = FeedingPoint.fromMap(fpData, 'fp_3');

      // Assert
      expect(feedingPoint.id, 'fp_3');
      expect(feedingPoint.title, 'Downtown Feeding Area');
      expect(feedingPoint.description, 'Behind the mall');
      expect(feedingPoint.imageUrl, 'assets/images/downtown.jpg');
      expect(feedingPoint.buttonText, 'Show Map');
      expect(feedingPoint.latitude, 39.9042);
      expect(feedingPoint.longitude, 116.4074);
      expect(feedingPoint.createdBy, 'user_404');
    });

    test('FeedingPoint location coordinates validation', () {
      // Arrange
      final feedingPoint = FeedingPoint(
        id: 'fp_4',
        title: 'Beach Feeding Spot',
        description: 'Near lifeguard station',
        imageUrl: 'assets/images/beach.jpg',
        buttonText: 'Get Directions',
        latitude: 34.0522,
        longitude: -118.2437,
        createdBy: 'user_505',
      );

      // Assert - Valid latitude range (-90 to 90)
      expect(feedingPoint.latitude, greaterThanOrEqualTo(-90.0));
      expect(feedingPoint.latitude, lessThanOrEqualTo(90.0));

      // Assert - Valid longitude range (-180 to 180)
      expect(feedingPoint.longitude, greaterThanOrEqualTo(-180.0));
      expect(feedingPoint.longitude, lessThanOrEqualTo(180.0));
    });

    test('FeedingPoint title should not be empty', () {
      // Arrange
      final feedingPoint = FeedingPoint(
        id: 'fp_5',
        title: 'Community Center',
        description: 'Main entrance',
        imageUrl: 'assets/images/center.jpg',
        buttonText: 'View',
        latitude: 51.5074,
        longitude: -0.1278,
        createdBy: 'user_707',
      );

      // Assert
      expect(feedingPoint.title.isNotEmpty, true);
      expect(feedingPoint.title.length, greaterThan(0));
    });
  });
}
