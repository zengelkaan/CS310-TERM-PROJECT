import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class MessageProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<ConversationModel> _conversations = [];
  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ConversationModel> get conversations => _conversations;
  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void loadUserConversations(String userId) {
    _firestoreService.getUserConversationsStream(userId).listen(
      (conversations) {
        _conversations = conversations;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Failed to load conversations: ${error.toString()}';
        notifyListeners();
      },
    );
  }

  void loadMessages(String conversationId) {
    _firestoreService.getMessagesStream(conversationId).listen(
      (messages) {
        _messages = messages;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Failed to load messages: ${error.toString()}';
        notifyListeners();
      },
    );
  }

  Future<bool> sendMessage(MessageModel message) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _firestoreService.sendMessage(message);
    _isLoading = false;

    if (result != null) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to send message';
      notifyListeners();
      return false;
    }
  }

  Future<ConversationModel?> getOrCreateConversation(
    String userId1,
    String userId2, {
    String? petId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _firestoreService.getOrCreateConversation(
      userId1,
      userId2,
      petId: petId,
    );

    _isLoading = false;
    notifyListeners();

    if (result != null) {
      return result;
    } else {
      _errorMessage = 'Failed to create conversation';
      notifyListeners();
      return null;
    }
  }

  Future<bool> markMessagesAsRead(String conversationId, String userId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _firestoreService.markMessagesAsRead(
      conversationId,
      userId,
    );

    _isLoading = false;
    notifyListeners();

    return result;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

