import 'package:cloud_firestore/cloud_firestore.dart';

class FeedingPoint {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
  final String buttonText;
  final double? latitude;
  final double? longitude;
  final String? createdBy;
  final Timestamp? createdAt;

  FeedingPoint({
    this.id,
    required this.title,
    this.description = '',
    required this.imageUrl,
    this.buttonText = 'Get Directions',
    this.latitude,
    this.longitude,
    this.createdBy,
    this.createdAt,
  });

  // Convert to Firestore Map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'buttonText': buttonText,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore document
  factory FeedingPoint.fromFirestore(DocumentSnapshot doc) {
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

  // CopyWith method for updates
  FeedingPoint copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? buttonText,
    double? latitude,
    double? longitude,
    String? createdBy,
    Timestamp? createdAt,
  }) {
    return FeedingPoint(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      buttonText: buttonText ?? this.buttonText,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
