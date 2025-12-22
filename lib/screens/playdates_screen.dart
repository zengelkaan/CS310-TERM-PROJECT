import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/custom_bottom_nav.dart';

class PlaydatesScreen extends StatelessWidget {
  const PlaydatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back icon
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              ),
              const SizedBox(height: 8),
              
              // Title with heart icon
              Row(
                children: const [
                  Icon(Icons.favorite, color: Colors.redAccent, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Playdates',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Find playmates for your pets',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              
              // Real-time list from Firestore - pets available for playdates
              Expanded(
                child: authProvider.isAuthenticated
                    ? StreamBuilder<List<Pet>>(
                        stream: context.read<PetProvider>().streamAllPets(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                                  const SizedBox(height: 16),
                                  Text('Error: ${snapshot.error}'),
                                ],
                              ),
                            );
                          }

                          final allPets = snapshot.data ?? [];
                          // Filter out current user's pets for playdates
                          final pets = allPets
                              .where((pet) => pet.createdBy != authProvider.userId)
                              .toList();

                          if (pets.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No pets available for playdates',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Check back later!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: pets.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final pet = pets[index];
                              return _PlaydatePetCard(
                                pet: pet,
                                currentUserId: authProvider.userId,
                                currentUserName: authProvider.userName,
                              );
                            },
                          );
                        },
                      )
                    : const Center(child: Text('Please login to see playdates')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaydatePetCard extends StatefulWidget {
  final Pet pet;
  final String currentUserId;
  final String currentUserName;

  const _PlaydatePetCard({
    required this.pet,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<_PlaydatePetCard> createState() => _PlaydatePetCardState();
}

class _PlaydatePetCardState extends State<_PlaydatePetCard> {
  bool _isLoadingChat = false;

  Future<void> _startChatWithOwner() async {
    if (widget.pet.createdBy == null || widget.pet.createdBy!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Owner information not available'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoadingChat = true);

    try {
      // Get owner info from Firestore
      final ownerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.pet.createdBy)
          .get();

      String ownerName = 'Pet Owner';
      if (ownerDoc.exists) {
        final data = ownerDoc.data();
        ownerName = data?['name'] ?? 'Pet Owner';
      }

      if (!mounted) return;

      // Create or get existing chat with owner
      final chatProvider = context.read<ChatProvider>();
      final chatId = await chatProvider.getOrCreateChat(
        currentUserId: widget.currentUserId,
        currentUserName: widget.currentUserName,
        otherUserId: widget.pet.createdBy!,
        otherUserName: ownerName,
      );

      if (!mounted) return;

      if (chatId != null) {
        Navigator.pushNamed(
          context,
          '/chat',
          arguments: {
            'chatId': chatId,
            'otherName': ownerName,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to start chat'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoadingChat = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Pet image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              widget.pet.imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey[300],
                child: const Icon(Icons.pets, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.pet.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.pink[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite, color: Colors.redAccent, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Playdate',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.pink[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.pet.type} • ${widget.pet.breed}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${widget.pet.gender} • ${widget.pet.age}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/pet_detail',
                            arguments: widget.pet,
                          );
                        },
                        icon: const Icon(Icons.info_outline, size: 18),
                        label: const Text('Details'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoadingChat ? null : _startChatWithOwner,
                        icon: _isLoadingChat
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ),
                              )
                            : const Icon(Icons.chat_bubble_outline, size: 18),
                        label: Text(_isLoadingChat ? 'Loading...' : 'Message'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
