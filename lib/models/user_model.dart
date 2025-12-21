import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? profileImageUrl;
  final String? phoneNumber;
  final UserLocation? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? bio;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.phoneNumber,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    this.bio,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      phoneNumber: data['phoneNumber'],
      location: data['location'] != null
          ? UserLocation.fromMap(data['location'])
          : null,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      bio: data['bio'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (location != null) 'location': location!.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (bio != null) 'bio': bio,
    };
  }
}

class UserLocation {
  final String? city;
  final String? address;
  final Coordinates coordinates;

  UserLocation({
    this.city,
    this.address,
    required this.coordinates,
  });

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      city: map['city'],
      address: map['address'],
      coordinates: Coordinates.fromMap(map['coordinates']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (city != null) 'city': city,
      if (address != null) 'address': address,
      'coordinates': coordinates.toMap(),
    };
  }
}

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromMap(Map<String, dynamic> map) {
    return Coordinates(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

