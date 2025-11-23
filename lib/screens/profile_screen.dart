import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/custom_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Dummy My Pets Data
  static List<Pet> myPets = [
    Pet(
      name: 'Bal',
      breed: 'Golden Retriever',
      gender: 'Female',
      age: '2 years',
      imagePath: 'https://images.pexels.com/photos/33053/dog-young-dog-small-dog-maltese.jpg?auto=compress&cs=tinysrgb&w=600', // Sample
      type: 'Dog',
    ),
    Pet(
      name: 'Şimanski',
      breed: 'Tabby',
      gender: 'Male',
      age: '1 year',
      imagePath: 'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&w=600', // Sample
      type: 'Cat',
    ),
    Pet(
      name: 'Limon',
      breed: 'Canary',
      gender: 'Male',
      age: '6 months',
      imagePath: 'https://images.pexels.com/photos/1661179/pexels-photo-1661179.jpeg?auto=compress&cs=tinysrgb&w=600', // Sample
      type: 'Bird',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 6),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ProfileHeaderCard(),
            const SizedBox(height: 24),
            const Text(
              'My Pets',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // List of Pets
            Expanded(
              child: ListView.builder(
                itemCount: myPets.length,
                itemBuilder: (context, index) {
                  final pet = myPets[index];
                  return _PetTile(pet: pet);
                },
              ),
            ),
            
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_pet');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE3A8AF),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text(
                        'Add New Pet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.person,
                size: 32,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Mehmet Salcan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetTile extends StatelessWidget {
  final Pet pet;

  const _PetTile({required this.pet});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.grey[400],
        backgroundImage: NetworkImage(pet.imagePath), // Using network image
        onBackgroundImageError: (_, __) => const Icon(Icons.pets),
        child: pet.imagePath.isEmpty ? const Icon(Icons.pets) : null,
      ),
      title: Text(
        pet.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () {
          // Navigate to Pet Details on 3-dots click
          Navigator.pushNamed(context, '/pet_detail', arguments: pet);
        },
      ),
      onTap: () {
          // Also allow tapping the tile itself
          Navigator.pushNamed(context, '/pet_detail', arguments: pet);
      },
    );
  }
}
