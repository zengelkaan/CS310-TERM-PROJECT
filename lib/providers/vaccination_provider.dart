import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/vaccination_model.dart';

class VaccinationProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<VaccinationModel> _vaccinations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<VaccinationModel> get vaccinations => _vaccinations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void loadPetVaccinations(String petId) {
    _firestoreService.getPetVaccinationsStream(petId).listen(
      (vaccinations) {
        _vaccinations = vaccinations;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Failed to load vaccinations: ${error.toString()}';
        notifyListeners();
      },
    );
  }

  void loadUserVaccinations(String userId) {
    _firestoreService.getUserVaccinationsStream(userId).listen(
      (vaccinations) {
        _vaccinations = vaccinations;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Failed to load vaccinations: ${error.toString()}';
        notifyListeners();
      },
    );
  }

  Future<bool> createVaccination(VaccinationModel vaccination) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _firestoreService.createVaccination(vaccination);
    _isLoading = false;

    if (result != null) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to create vaccination';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateVaccination(VaccinationModel vaccination) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _firestoreService.updateVaccination(vaccination);
    _isLoading = false;

    if (result) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to update vaccination';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteVaccination(String vaccinationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _firestoreService.deleteVaccination(vaccinationId);
    _isLoading = false;

    if (result) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to delete vaccination';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

