import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/feeding_point_model.dart';

class FeedingPointProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<FeedingPointModel> _feedingPoints = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FeedingPointModel> get feedingPoints => _feedingPoints;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FeedingPointProvider() {
    loadFeedingPoints();
  }

  void loadFeedingPoints({bool? verified, bool? active}) {
    _firestoreService
        .getFeedingPointsStream(verified: verified, active: active)
        .listen(
      (points) {
        _feedingPoints = points;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Failed to load feeding points: ${error.toString()}';
        notifyListeners();
      },
    );
  }

  Future<bool> createFeedingPoint(FeedingPointModel point) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _firestoreService.createFeedingPoint(point);
    _isLoading = false;

    if (result != null) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to create feeding point';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateFeedingPoint(FeedingPointModel point) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _firestoreService.updateFeedingPoint(point);
    _isLoading = false;

    if (result) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to update feeding point';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteFeedingPoint(String pointId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _firestoreService.deleteFeedingPoint(pointId);
    _isLoading = false;

    if (result) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to delete feeding point';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

