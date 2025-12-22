import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String? id;
  final String text;
  final String senderId;
  final String senderName;
  final Timestamp? createdAt;

  ChatMessage({
    this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    this.createdAt,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? 'User',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class Chat {
  final String? id;
  final List<String> participants;
  final List<String> participantNames;
  final String? lastMessage;
  final Timestamp? lastMessageAt;
  final Timestamp? createdAt;

  Chat({
    this.id,
    required this.participants,
    required this.participantNames,
    this.lastMessage,
    this.lastMessageAt,
    this.createdAt,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      participantNames: List<String>.from(data['participantNames'] ?? []),
      lastMessage: data['lastMessage'],
      lastMessageAt: data['lastMessageAt'] as Timestamp?,
      createdAt: data['createdAt'] as Timestamp?,
    );
  }
}

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Stream user's chats (no composite index needed)
  Stream<List<Chat>> streamUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          final chats = snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList();
          // Sort client-side
          chats.sort((a, b) {
            final aTime = a.lastMessageAt?.millisecondsSinceEpoch ?? 0;
            final bTime = b.lastMessageAt?.millisecondsSinceEpoch ?? 0;
            return bTime.compareTo(aTime);
          });
          return chats;
        });
  }

  // Stream messages for a chat
  Stream<List<ChatMessage>> streamMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
        });
  }

  // Create or get existing chat between two users
  Future<String?> getOrCreateChat({
    required String currentUserId,
    required String currentUserName,
    required String otherUserId,
    required String otherUserName,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check if chat already exists
      final existingChats = await _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .get();

      for (var doc in existingChats.docs) {
        final participants = List<String>.from(doc['participants'] ?? []);
        if (participants.contains(otherUserId)) {
          _isLoading = false;
          notifyListeners();
          return doc.id;
        }
      }

      // Create new chat
      final chatRef = await _firestore.collection('chats').add({
        'participants': [currentUserId, otherUserId],
        'participantNames': [currentUserName, otherUserName],
        'lastMessage': null,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      _isLoading = false;
      notifyListeners();
      return chatRef.id;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to create chat: $e';
      notifyListeners();
      return null;
    }
  }

  // Send message
  Future<bool> sendMessage({
    required String chatId,
    required String text,
    required String senderId,
    required String senderName,
  }) async {
    try {
      // Add message to subcollection
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'text': text,
        'senderId': senderId,
        'senderName': senderName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update chat's last message
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      _errorMessage = 'Failed to send message: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete chat
  Future<bool> deleteChat(String chatId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Delete all messages first
      final messages = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      for (var doc in messages.docs) {
        await doc.reference.delete();
      }

      // Delete chat document
      await _firestore.collection('chats').doc(chatId).delete();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to delete chat: $e';
      notifyListeners();
      return false;
    }
  }
}

