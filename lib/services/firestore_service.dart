import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';
import '../models/feeding_point_model.dart';
import '../models/vaccination_model.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== PETS ====================
  
  // Get all pets (real-time stream)
  Stream<List<PetModel>> getPetsStream({
    String? purpose,
    String? kind,
    bool? available,
  }) {
    Query query = _firestore.collection('pets');

    if (purpose != null) {
      query = query.where('purpose', isEqualTo: purpose);
    }
    if (kind != null) {
      query = query.where('kind', isEqualTo: kind);
    }
    if (available != null) {
      query = query.where('available', isEqualTo: available);
    }

    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PetModel.fromFirestore(doc))
            .toList());
  }

  // Get user's pets
  Stream<List<PetModel>> getUserPetsStream(String userId) {
    return _firestore
        .collection('pets')
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PetModel.fromFirestore(doc))
            .toList());
  }

  // Get single pet
  Future<PetModel?> getPet(String petId) async {
    try {
      final doc = await _firestore.collection('pets').doc(petId).get();
      if (doc.exists) {
        return PetModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Create pet
  Future<String?> createPet(PetModel pet) async {
    try {
      final docRef = await _firestore.collection('pets').add(pet.toFirestore());
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  // Update pet
  Future<bool> updatePet(PetModel pet) async {
    try {
      await _firestore
          .collection('pets')
          .doc(pet.id)
          .update(pet.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete pet
  Future<bool> deletePet(String petId) async {
    try {
      await _firestore.collection('pets').doc(petId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== FEEDING POINTS ====================

  // Get all feeding points (real-time stream)
  Stream<List<FeedingPointModel>> getFeedingPointsStream({
    bool? verified,
    bool? active,
  }) {
    Query query = _firestore.collection('feedingPoints');

    if (verified != null) {
      query = query.where('verified', isEqualTo: verified);
    }
    if (active != null) {
      query = query.where('active', isEqualTo: active);
    }

    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FeedingPointModel.fromFirestore(doc))
            .toList());
  }

  // Create feeding point
  Future<String?> createFeedingPoint(FeedingPointModel point) async {
    try {
      final docRef =
          await _firestore.collection('feedingPoints').add(point.toFirestore());
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  // Update feeding point
  Future<bool> updateFeedingPoint(FeedingPointModel point) async {
    try {
      await _firestore
          .collection('feedingPoints')
          .doc(point.id)
          .update(point.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete feeding point
  Future<bool> deleteFeedingPoint(String pointId) async {
    try {
      await _firestore.collection('feedingPoints').doc(pointId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== VACCINATIONS ====================

  // Get pet's vaccinations (real-time stream)
  Stream<List<VaccinationModel>> getPetVaccinationsStream(String petId) {
    return _firestore
        .collection('vaccinations')
        .where('petId', isEqualTo: petId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VaccinationModel.fromFirestore(doc))
            .toList());
  }

  // Get user's vaccinations (all pets)
  Stream<List<VaccinationModel>> getUserVaccinationsStream(String userId) {
    return _firestore
        .collection('vaccinations')
        .where('ownerId', isEqualTo: userId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VaccinationModel.fromFirestore(doc))
            .toList());
  }

  // Create vaccination
  Future<String?> createVaccination(VaccinationModel vaccination) async {
    try {
      final docRef = await _firestore
          .collection('vaccinations')
          .add(vaccination.toFirestore());
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  // Update vaccination
  Future<bool> updateVaccination(VaccinationModel vaccination) async {
    try {
      await _firestore
          .collection('vaccinations')
          .doc(vaccination.id)
          .update(vaccination.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete vaccination
  Future<bool> deleteVaccination(String vaccinationId) async {
    try {
      await _firestore.collection('vaccinations').doc(vaccinationId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== CONVERSATIONS ====================

  // Get user's conversations (real-time stream)
  Stream<List<ConversationModel>> getUserConversationsStream(String userId) {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConversationModel.fromFirestore(doc))
            .toList());
  }

  // Get or create conversation
  Future<ConversationModel?> getOrCreateConversation(
    String userId1,
    String userId2, {
    String? petId,
  }) async {
    try {
      // Try to find existing conversation
      final existing = await _firestore
          .collection('conversations')
          .where('participants', arrayContains: userId1)
          .get();

      for (var doc in existing.docs) {
        final conv = ConversationModel.fromFirestore(doc);
        if (conv.participants.contains(userId2)) {
          return conv;
        }
      }

      // Create new conversation
      final participants = [userId1, userId2]..sort();
      final newConv = ConversationModel(
        id: '', // Will be set by Firestore
        participants: participants,
        petId: petId,
        unreadCount: {userId1: 0, userId2: 0},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final docRef = await _firestore
          .collection('conversations')
          .add(newConv.toFirestore());
      
      return ConversationModel(
        id: docRef.id,
        participants: participants,
        petId: petId,
        unreadCount: {userId1: 0, userId2: 0},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  // ==================== MESSAGES ====================

  // Get conversation messages (real-time stream)
  Stream<List<MessageModel>> getMessagesStream(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .toList());
  }

  // Send message
  Future<String?> sendMessage(MessageModel message) async {
    try {
      // Add message to subcollection
      final docRef = await _firestore
          .collection('conversations')
          .doc(message.conversationId)
          .collection('messages')
          .add(message.toFirestore());

      // Update conversation's last message and updatedAt
      await _firestore
          .collection('conversations')
          .doc(message.conversationId)
          .update({
        'lastMessage': {
          'text': message.text,
          'senderId': message.senderId,
          'timestamp': Timestamp.fromDate(message.timestamp),
        },
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  // Mark messages as read
  Future<bool> markMessagesAsRead(String conversationId, String userId) async {
    try {
      final messages = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .where('senderId', isNotEqualTo: userId)
          .where('read', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in messages.docs) {
        batch.update(doc.reference, {
          'read': true,
          'readAt': Timestamp.fromDate(DateTime.now()),
        });
      }
      await batch.commit();

      // Update unread count
      await _firestore.collection('conversations').doc(conversationId).update({
        'unreadCount.$userId': 0,
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}

