import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feeding_point.dart';

class FeedingPointProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<FeedingPoint> _feedingPoints = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<FeedingPoint> get feedingPoints => _feedingPoints;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Stream for real-time updates (no composite index needed)
  Stream<List<FeedingPoint>> streamFeedingPoints() {
    return _firestore
        .collection('feeding_points')
        .snapshots()
        .map((snapshot) {
          final points = snapshot.docs.map((doc) => _feedingPointFromFirestore(doc)).toList();
          // Sort client-side
          points.sort((a, b) {
            final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
            final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
            return bTime.compareTo(aTime);
          });
          return points;
        });
  }

  // Stream user's feeding points
  Stream<List<FeedingPoint>> streamMyFeedingPoints(String userId) {
    return _firestore
        .collection('feeding_points')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final points = snapshot.docs.map((doc) => _feedingPointFromFirestore(doc)).toList();
          points.sort((a, b) {
            final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
            final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
            return bTime.compareTo(aTime);
          });
          return points;
        });
  }

  // Fetch all feeding points
  Future<void> fetchFeedingPoints() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('feeding_points')
          .get();

      _feedingPoints = snapshot.docs.map((doc) => _feedingPointFromFirestore(doc)).toList();
      _feedingPoints.sort((a, b) {
        final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return bTime.compareTo(aTime);
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch feeding points: $e';
      notifyListeners();
    }
  }

  // CREATE - Add new feeding point
  Future<bool> addFeedingPoint({
    required String userId,
    required String title,
    String? description,
    String imageUrl = 'assets/images/map.jpg',
    String buttonText = 'Get Directions',
    double? latitude,
    double? longitude,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final docRef = _firestore.collection('feeding_points').doc();
      
      await docRef.set({
        'id': docRef.id,
        'title': title,
        'description': description ?? '',
        'imageUrl': imageUrl,
        'buttonText': buttonText,
        'latitude': latitude,
        'longitude': longitude,
        'createdBy': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to add feeding point: $e';
      notifyListeners();
      return false;
    }
  }

  // READ - Get single feeding point
  Future<FeedingPoint?> getFeedingPointById(String id) async {
    try {
      final doc = await _firestore.collection('feeding_points').doc(id).get();
      if (doc.exists) {
        return _feedingPointFromFirestore(doc);
      }
      return null;
    } catch (e) {
      _errorMessage = 'Failed to get feeding point: $e';
      notifyListeners();
      return null;
    }
  }

  // UPDATE - Update feeding point
  Future<bool> updateFeedingPoint({
    required String id,
    String? title,
    String? description,
    String? imageUrl,
    String? buttonText,
    double? latitude,
    double? longitude,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final Map<String, dynamic> updates = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (imageUrl != null) updates['imageUrl'] = imageUrl;
      if (buttonText != null) updates['buttonText'] = buttonText;
      if (latitude != null) updates['latitude'] = latitude;
      if (longitude != null) updates['longitude'] = longitude;

      await _firestore.collection('feeding_points').doc(id).update(updates);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update feeding point: $e';
      notifyListeners();
      return false;
    }
  }

  // DELETE - Delete feeding point
  Future<bool> deleteFeedingPoint(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection('feeding_points').doc(id).delete();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to delete feeding point: $e';
      notifyListeners();
      return false;
    }
  }

  // Helper method to convert Firestore document to FeedingPoint
  FeedingPoint _feedingPointFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedingPoint(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? 'assets/images/map.jpg',
      buttonText: data['buttonText'] ?? 'Get Directions',
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      createdBy: data['createdBy'],
      createdAt: data['createdAt'] as Timestamp?,
    );
  }
}
