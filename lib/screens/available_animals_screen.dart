import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../providers/pet_provider_mock.dart';
import '../models/pet_model.dart';
import 'pet_detail_screen.dart';

class AvailableAnimalsScreen extends StatelessWidget {
  final String? purpose;
  
  const AvailableAnimalsScreen({super.key, this.purpose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.maybePop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                purpose == 'Dating' ? 'Dating Animals' : 'Available Animals',
                style: const TextStyle(
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
                child: Consumer(
                  builder: (context, petProvider, child) {
                    // Handle both PetProvider and PetProviderMock
                    final pets = petProvider is PetProviderMock
                        ? petProvider.pets
                        : (petProvider as PetProvider).pets;
                    final isLoading = petProvider is PetProviderMock
                        ? petProvider.isLoading
                        : (petProvider as PetProvider).isLoading;
                    final errorMessage = petProvider is PetProviderMock
                        ? petProvider.errorMessage
                        : (petProvider as PetProvider).errorMessage;
                    
                    if (isLoading && pets.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (errorMessage != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(errorMessage),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (petProvider is PetProviderMock) {
                                  petProvider.clearError();
                                  petProvider.loadPets(
                                    purpose: purpose,
                                    available: true,
                                  );
                                } else {
                                  (petProvider as PetProvider).clearError();
                                  (petProvider as PetProvider).loadPets(
                                    purpose: purpose,
                                    available: true,
                                  );
                                }
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Filter pets by purpose if specified (already filtered in mock)
                    final filteredPets = purpose != null
                        ? pets.where((pet) => pet.purpose == purpose || pet.purpose == 'Both').toList()
                        : pets;

                    if (filteredPets.isEmpty) {
                      return const Center(
                        child: Text('No pets available'),
                      );
                    }

                    return ListView.separated(
                      itemCount: filteredPets.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final pet = filteredPets[index];
                        return _PetListItem(pet: pet);
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

class _PetListItem extends StatelessWidget {
  final PetModel pet;

  const _PetListItem({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage: pet.photos.isNotEmpty
              ? NetworkImage(pet.photos.first)
              : null,
          child: pet.photos.isEmpty
              ? const Icon(Icons.pets, size: 36)
              : null,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailScreen(petId: pet.id),
                      ),
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

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/animals');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/chats');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
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

