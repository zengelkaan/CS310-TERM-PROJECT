import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../services/auth_service.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        final messageProvider = Provider.of<MessageProvider>(context, listen: false);
        messageProvider.loadUserConversations(currentUser.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.currentUser;

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Messages',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: currentUser == null
                    ? const Center(child: Text('Please login'))
                    : Consumer<MessageProvider>(
                        builder: (context, messageProvider, child) {
                          if (messageProvider.isLoading &&
                              messageProvider.conversations.isEmpty) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (messageProvider.conversations.isEmpty) {
                            return const Center(
                              child: Text('No conversations yet'),
                            );
                          }

                          return ListView.separated(
                            itemCount: messageProvider.conversations.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final conversation =
                                  messageProvider.conversations[index];
                              final otherUserId = conversation.participants
                                  .firstWhere((id) => id != currentUser.uid);
                              
                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person_outline),
                                ),
                                title: Text('User $otherUserId'),
                                subtitle: conversation.lastMessage != null
                                    ? Text(conversation.lastMessage!.text)
                                    : const Text('No messages'),
                                trailing: conversation.unreadCount[currentUser.uid] != null &&
                                        conversation.unreadCount[currentUser.uid]! > 0
                                    ? CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.red,
                                        child: Text(
                                          '${conversation.unreadCount[currentUser.uid]}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    : const Icon(Icons.chat_bubble_outline),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        conversationId: conversation.id,
                                        otherUserId: otherUserId,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {},
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
      ],
    );
  }
}

