import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/pet_provider.dart';
import '../providers/pet_provider_mock.dart';
import '../models/pet_model.dart';
import '../services/firebase_service.dart';
import '../addNewPat.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated && authProvider.user != null) {
        final petProvider = Provider.of(context, listen: false);
        if (petProvider is PetProviderMock) {
          petProvider.loadUserPets(authProvider.user!.uid);
        } else if (petProvider is PetProvider) {
          petProvider.loadUserPets(authProvider.user!.uid);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeaderCard(userName: authProvider.userData?.name ?? 'User'),
            const SizedBox(height: 24),
            const Text(
              'My Pets',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer(
                builder: (context, petProvider, child) {
                  final userPets = petProvider is PetProviderMock
                      ? petProvider.userPets
                      : (petProvider as PetProvider).userPets;
                  final isLoading = petProvider is PetProviderMock
                      ? petProvider.isLoading
                      : (petProvider as PetProvider).isLoading;

                  if (isLoading && userPets.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (userPets.isEmpty) {
                    return const Center(
                      child: Text('No pets added yet'),
                    );
                  }

                  return ListView.builder(
                    itemCount: userPets.length,
                    itemBuilder: (context, index) {
                      final pet = userPets[index];
                      return _PetTile(pet: pet);
                    },
                  );
                },
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddNewPetPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE3A8AF),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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

  Future<void> _showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signOut();
    }
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final String userName;

  const _ProfileHeaderCard({required this.userName});

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
            Expanded(
              child: Text(
                userName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // Settings or edit profile
              },
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetTile extends StatelessWidget {
  final PetModel pet;

  const _PetTile({required this.pet});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 26,
        backgroundImage:
            pet.photos.isNotEmpty ? NetworkImage(pet.photos.first) : null,
        child: pet.photos.isEmpty
            ? const Icon(Icons.pets, size: 26)
            : null,
      ),
      title: Text(
        pet.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text('${pet.kind} - ${pet.breed}'),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        onPressed: () {
          // Edit or delete pet
        },
      ),
    );
  }
}

