import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/firestore_service_mock.dart';
import '../models/pet_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import 'chat_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final String petId;

  const PetDetailScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SafeArea(
        child: FutureBuilder<PetModel?>(
          future: FirebaseService.isInitialized 
              ? FirestoreService().getPet(petId)
              : FirestoreServiceMock().getPet(petId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Pet not found'));
            }

            final pet = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: pet.photos.isNotEmpty
                            ? Image.network(
                                pet.photos.first,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.pets, size: 100),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.pets, size: 100),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Breed', value: pet.breed),
                  _InfoRow(label: 'Gender', value: pet.gender),
                  _InfoRow(label: 'Age', value: pet.age),
                  _InfoRow(label: 'Kind', value: pet.kind),
                  _InfoRow(label: 'Purpose', value: pet.purpose),
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'About This Pet',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pet.about,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<UserModel?>(
                    future: FirebaseService.isInitialized
                        ? authService.getUserData(pet.ownerId)
                        : (firestoreService as FirestoreServiceMock).getUserData(pet.ownerId),
                    builder: (context, ownerSnapshot) {
                      if (!ownerSnapshot.hasData || ownerSnapshot.data == null) {
                        return const SizedBox.shrink();
                      }

                      final owner = ownerSnapshot.data;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Owner :',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: owner.profileImageUrl != null
                                    ? NetworkImage(owner.profileImageUrl!)
                                    : null,
                                child: owner.profileImageUrl == null
                                    ? const Icon(Icons.person, size: 18)
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                owner.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              OutlinedButton.icon(
                                onPressed: () async {
                                  final currentUser = authService.currentUser;
                                  if (currentUser == null) return;

                                  ConversationModel? conversation;
                                  if (FirebaseService.isInitialized) {
                                    conversation = await FirestoreService().getOrCreateConversation(
                                      currentUser.uid,
                                      owner.uid,
                                      petId: pet.id,
                                    );
                                  }

                                  if (conversation != null && context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          conversationId: conversation.id,
                                          otherUserId: owner.uid,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                                label: const Text('Message'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(0, 36),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '$label :',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 12),
      ],
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

