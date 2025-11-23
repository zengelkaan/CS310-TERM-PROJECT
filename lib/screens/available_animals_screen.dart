import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/custom_bottom_nav.dart';

class AvailableAnimalsScreen extends StatelessWidget {
  const AvailableAnimalsScreen({super.key});

  // Dummy data - moved from main.dart
  static List<Pet> pets = [
    Pet(
      name: 'Max',
      breed: 'Golden Retriever',
      gender: 'Male',
      age: '3 years',
      imagePath: 'https://images.pexels.com/photos/33053/dog-young-dog-small-dog-maltese.jpg?auto=compress&cs=tinysrgb&w=600',
      type: 'Dog',
    ),
    Pet(
      name: 'Luna',
      breed: 'Siamese',
      gender: 'Female',
      age: '2 years',
      imagePath: 'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&w=600',
      type: 'Cat',
    ),
    Pet(
      name: 'Coco',
      breed: 'Holland Lop',
      gender: 'Female',
      age: '1 year',
      imagePath: 'https://images.pexels.com/photos/4001296/pexels-photo-4001296.jpeg?auto=compress&cs=tinysrgb&w=600',
      type: 'Rabbit',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // back icon
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.maybePop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                'Available Animals',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Find your perfect companion',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: pets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return _PetListItem(pet: pet);
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

class _PetListItem extends StatelessWidget {
  final Pet pet;

  const _PetListItem({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage: NetworkImage(pet.imagePath),
          onBackgroundImageError: (_, __) => const Icon(Icons.pets),
          child: pet.imagePath.isEmpty ? const Icon(Icons.pets) : null, 
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pet.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Breed: ${pet.breed}\nGender: ${pet.gender}\nAge: ${pet.age}',
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 120,
                height: 34,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/pet_detail',
                      arguments: pet,
                    );
                  },
                  child: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
