import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet.dart';

class PetProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final List<Pet> _pets = [];
  List<Pet> _myPets = [];
  List<Pet> _availablePets = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Pet> get pets => _pets;
  List<Pet> get myPets => _myPets;
  List<Pet> get availablePets => _availablePets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Stream for real-time updates of user's pets (no composite index needed)
  Stream<List<Pet>> streamMyPets(String userId) {
    return _firestore
        .collection('pets')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final pets = snapshot.docs.map((doc) => _petFromFirestore(doc)).toList();
          // Sort client-side to avoid composite index
          pets.sort((a, b) {
            final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
            final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
            return bTime.compareTo(aTime); // descending
          });
          return pets;
        });
  }

  // Stream for available pets (for adoption)
  Stream<List<Pet>> streamAvailablePets() {
    return _firestore
        .collection('pets')
        .where('isAvailableForAdoption', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final pets = snapshot.docs.map((doc) => _petFromFirestore(doc)).toList();
          pets.sort((a, b) {
            final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
            final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
            return bTime.compareTo(aTime);
          });
          return pets;
        });
  }

  // Stream all pets
  Stream<List<Pet>> streamAllPets() {
    return _firestore
        .collection('pets')
        .snapshots()
        .map((snapshot) {
          final pets = snapshot.docs.map((doc) => _petFromFirestore(doc)).toList();
          pets.sort((a, b) {
            final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
            final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
            return bTime.compareTo(aTime);
          });
          return pets;
        });
  }

  // Fetch user's pets
  Future<void> fetchMyPets(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('pets')
          .where('createdBy', isEqualTo: userId)
          .get();

      _myPets = snapshot.docs.map((doc) => _petFromFirestore(doc)).toList();
      _myPets.sort((a, b) {
        final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return bTime.compareTo(aTime);
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch pets: $e';
      notifyListeners();
    }
  }

  // Fetch available pets for adoption
  Future<void> fetchAvailablePets() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('pets')
          .where('isAvailableForAdoption', isEqualTo: true)
          .get();

      _availablePets = snapshot.docs.map((doc) => _petFromFirestore(doc)).toList();
      _availablePets.sort((a, b) {
        final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return bTime.compareTo(aTime);
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch available pets: $e';
      notifyListeners();
    }
  }

  // CREATE - Add new pet
  Future<bool> addPet({
    required String userId,
    required String name,
    required String type,
    required String breed,
    required String gender,
    required String age,
    String? about,
    String imagePath = 'assets/images/max.jpg',
    bool isAvailableForAdoption = false,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final docRef = _firestore.collection('pets').doc();
      
      await docRef.set({
        'id': docRef.id,
        'name': name,
        'type': type,
        'breed': breed,
        'gender': gender,
        'age': age,
        'about': about ?? '$name is a friendly pet looking for love!',
        'imagePath': imagePath,
        'isAvailableForAdoption': isAvailableForAdoption,
        'createdBy': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to add pet: $e';
      notifyListeners();
      return false;
    }
  }

  // READ - Get single pet
  Future<Pet?> getPetById(String petId) async {
    try {
      final doc = await _firestore.collection('pets').doc(petId).get();
      if (doc.exists) {
        return _petFromFirestore(doc);
      }
      return null;
    } catch (e) {
      _errorMessage = 'Failed to get pet: $e';
      notifyListeners();
      return null;
    }
  }

  // UPDATE - Update pet
  Future<bool> updatePet({
    required String petId,
    String? name,
    String? type,
    String? breed,
    String? gender,
    String? age,
    String? about,
    String? imagePath,
    bool? isAvailableForAdoption,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final Map<String, dynamic> updates = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updates['name'] = name;
      if (type != null) updates['type'] = type;
      if (breed != null) updates['breed'] = breed;
      if (gender != null) updates['gender'] = gender;
      if (age != null) updates['age'] = age;
      if (about != null) updates['about'] = about;
      if (imagePath != null) updates['imagePath'] = imagePath;
      if (isAvailableForAdoption != null) {
        updates['isAvailableForAdoption'] = isAvailableForAdoption;
      }

      await _firestore.collection('pets').doc(petId).update(updates);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update pet: $e';
      notifyListeners();
      return false;
    }
  }

  // DELETE - Delete pet
  Future<bool> deletePet(String petId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection('pets').doc(petId).delete();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to delete pet: $e';
      notifyListeners();
      return false;
    }
  }

  // Helper method to convert Firestore document to Pet
  Pet _petFromFirestore(DocumentSnapshot doc) {
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
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }
}
