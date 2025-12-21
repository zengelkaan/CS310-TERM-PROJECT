import 'package:flutter/foundation.dart';
import '../services/mock_data_service.dart';
import '../models/pet_model.dart';
import 'dart:async';

class PetProviderMock with ChangeNotifier {
  List<PetModel> _pets = [];
  List<PetModel> _userPets = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PetModel> get pets => _pets;
  List<PetModel> get userPets => _userPets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PetProviderMock() {
    loadPets();
  }

  void loadPets({String? purpose, String? kind, bool? available}) {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _pets = MockDataService.getMockPets();
      
      // Apply filters
      if (purpose != null) {
        _pets = _pets.where((pet) => pet.purpose == purpose || pet.purpose == 'Both').toList();
      }
      if (kind != null) {
        _pets = _pets.where((pet) => pet.kind == kind).toList();
      }
      if (available != null) {
        _pets = _pets.where((pet) => pet.available == available).toList();
      }

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    });
  }

  void loadUserPets(String userId) {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      _userPets = MockDataService.getMockPets()
          .where((pet) => pet.ownerId == userId)
          .toList();
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    });
  }

  Future<bool> createPet(PetModel pet) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    
    // Add new pet to the list
    final newPet = PetModel(
      id: 'pet${_pets.length + 1}',
      ownerId: pet.ownerId,
      name: pet.name,
      kind: pet.kind,
      breed: pet.breed,
      gender: pet.gender,
      age: pet.age,
      ageInMonths: pet.ageInMonths,
      photos: pet.photos,
      about: pet.about,
      purpose: pet.purpose,
      available: pet.available,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: pet.status,
    );

    _pets.add(newPet);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> updatePet(PetModel pet) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _pets.indexWhere((p) => p.id == pet.id);
    if (index != -1) {
      _pets[index] = pet;
      _isLoading = false;
      notifyListeners();
      return true;
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> deletePet(String petId) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    
    _pets.removeWhere((pet) => pet.id == petId);
    _userPets.removeWhere((pet) => pet.id == petId);
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

