import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/custom_bottom_nav.dart';

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Pet? pet = ModalRoute.of(context)?.settings.arguments as Pet?;

    if (pet == null) {
       return const Scaffold(body: Center(child: Text("No pet details found")));
    }

    return Scaffold(
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    child: Image.asset(
                      pet.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 100),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                pet.name,
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // info rows
              _InfoRow(label: 'Breed', value: pet.breed),
              _InfoRow(label: 'Gender', value: pet.gender),
              _InfoRow(label: 'Age', value: pet.age),
              const SizedBox(height: 16),

              // About card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
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
                        '${pet.name} is a healthy ${pet.age} ${pet.breed} looking '
                            'for a home. Friendly, energetic, and ready '
                            'to be loved!',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Owner :',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage:
                    AssetImage('assets/images/owner_emily.jpg'), // Placeholder
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Emily Clark',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/chat'); // Go to individual chat
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
              const SizedBox(height: 24),
            ],
          ),
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

