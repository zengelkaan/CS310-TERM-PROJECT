import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/pet_model.dart';

class PetProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<PetModel> _pets = [];
  List<PetModel> _userPets = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PetModel> get pets => _pets;
  List<PetModel> get userPets => _userPets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PetProvider() {
    loadPets();
  }

  void loadPets({String? purpose, String? kind, bool? available}) {
    _firestoreService
        .getPetsStream(purpose: purpose, kind: kind, available: available)
        .listen(
      (pets) {
        _pets = pets;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Failed to load pets: ${error.toString()}';
        notifyListeners();
      },
    );
  }

  void loadUserPets(String userId) {
    _firestoreService.getUserPetsStream(userId).listen(
      (pets) {
        _userPets = pets;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Failed to load user pets: ${error.toString()}';
        notifyListeners();
      },
    );
  }

  Future<bool> createPet(PetModel pet) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _firestoreService.createPet(pet);
    _isLoading = false;

    if (result != null) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to create pet';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePet(PetModel pet) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _firestoreService.updatePet(pet);
    _isLoading = false;

    if (result) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to update pet';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePet(String petId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _firestoreService.deletePet(petId);
    _isLoading = false;

    if (result) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to delete pet';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

