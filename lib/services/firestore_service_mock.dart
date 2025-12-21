import '../models/pet_model.dart';
import '../models/user_model.dart';
import '../services/mock_data_service.dart';

class FirestoreServiceMock {
  // Get single pet
  Future<PetModel?> getPet(String petId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final pets = MockDataService.getMockPets();
    try {
      return pets.firstWhere((pet) => pet.id == petId);
    } catch (e) {
      return null;
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Mock user data
    if (uid == 'user1') {
      return UserModel(
        uid: 'user1',
        email: 'mehmet.salcan@example.com',
        name: 'Mehmet Salcan',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
        bio: 'Pet lover and owner of 3 beautiful cats',
      );
    } else if (uid == 'user2') {
      return UserModel(
        uid: 'user2',
        email: 'emir.ozyesil@example.com',
        name: 'Emir Özyeşil',
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        updatedAt: DateTime.now(),
        bio: 'Dog breeder specializing in Golden Retrievers',
      );
    } else if (uid == 'user6') {
      return UserModel(
        uid: 'user6',
        email: 'emily.clark@example.com',
        name: 'Emily Clark',
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now(),
        bio: 'Golden Retriever owner looking for breeding partner',
      );
    }
    
    return UserModel(
      uid: uid,
      email: 'user@example.com',
      name: 'User $uid',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

