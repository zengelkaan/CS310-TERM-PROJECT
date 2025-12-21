import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class FeedingPointModel {
  final String id;
  final String creatorId;
  final String title;
  final String? description;
  final FeedingLocation location;
  final String? imageUrl;
  final bool verified;
  final double? rating;
  final int ratingsCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool active;

  FeedingPointModel({
    required this.id,
    required this.creatorId,
    required this.title,
    this.description,
    required this.location,
    this.imageUrl,
    required this.verified,
    this.rating,
    required this.ratingsCount,
    required this.createdAt,
    required this.updatedAt,
    required this.active,
  });

  factory FeedingPointModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeedingPointModel(
      id: doc.id,
      creatorId: data['creatorId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      location: FeedingLocation.fromMap(data['location']),
      imageUrl: data['imageUrl'],
      verified: data['verified'] ?? false,
      rating: data['rating'] != null ? (data['rating'] as num).toDouble() : null,
      ratingsCount: data['ratingsCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      active: data['active'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'creatorId': creatorId,
      'title': title,
      if (description != null) 'description': description,
      'location': location.toMap(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      'verified': verified,
      if (rating != null) 'rating': rating,
      'ratingsCount': ratingsCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'active': active,
    };
  }
}

class FeedingLocation {
  final String address;
  final Coordinates coordinates;

  FeedingLocation({
    required this.address,
    required this.coordinates,
  });

  factory FeedingLocation.fromMap(Map<String, dynamic> map) {
    return FeedingLocation(
      address: map['address'] ?? '',
      coordinates: Coordinates.fromMap(map['coordinates']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'coordinates': coordinates.toMap(),
    };
  }
}

