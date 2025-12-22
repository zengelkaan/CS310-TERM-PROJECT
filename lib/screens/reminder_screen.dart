import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pet.dart';

import '../providers/auth_provider.dart';
import '../providers/pet_provider.dart';

import '../widgets/custom_bottom_nav.dart';

// COLORS
const Color primaryPink = Color(0xFFC1485F);
const Color cardPink = Color(0xFFDEB9C0);
const Color lightPink = Color(0xFFC6A2A3);
const Color warningRed = Color(0xFFD9534F);
const Color badgeRed = Color(0xFFFF7676);
const Color successGreen = Color(0xFF3CB371);

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: const Text(
          "Vaccination Reminders",
          style: TextStyle(
            color: primaryPink,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
      body: authProvider.isAuthenticated
          ? StreamBuilder<List<Pet>>(
              stream: context.read<PetProvider>().streamMyPets(authProvider.userId),
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

                final pets = snapshot.data ?? [];

                if (pets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No pets yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your pets in Profile to track vaccinations',
                          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/add_pet'),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Pet'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: _PetVaccinationCard(pet: pet),
                    );
                  },
                );
              },
            )
          : const Center(child: Text('Please login to see reminders')),
    );
  }
}

class _PetVaccinationCard extends StatelessWidget {
  final Pet pet;

  const _PetVaccinationCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardPink,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(pet.imagePath),
                onBackgroundImageError: (_, __) {},
                child: pet.imagePath.isEmpty ? const Icon(Icons.pets) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: primaryPink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${pet.type} • ${pet.breed}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Vaccinations from Firestore
          _VaccinationList(petId: pet.id ?? ''),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showAddVaccinationBottomSheet(context, pet),
              style: ElevatedButton.styleFrom(
                backgroundColor: lightPink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text("+ Add Vaccination"),
            ),
          ),
        ],
      ),
    );
  }
}

class _VaccinationList extends StatelessWidget {
  final String petId;

  const _VaccinationList({required this.petId});

  @override
  Widget build(BuildContext context) {
    if (petId.isEmpty) {
      return const Text('No vaccinations', style: TextStyle(color: Colors.black54));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pets')
          .doc(petId)
          .collection('vaccinations')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final vaccinations = snapshot.data?.docs ?? [];

        if (vaccinations.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: lightPink.withAlpha(90),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'No vaccinations added yet',
              style: TextStyle(color: Colors.black54),
            ),
          );
        }

        return Column(
          children: vaccinations.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _VaccinationCard(
                vaccinationId: doc.id,
                petId: petId,
                title: data['title'] ?? '',
                dateText: data['dateText'] ?? '',
                completed: data['completed'] ?? false,
                warning: data['warning'] ?? false,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _VaccinationCard extends StatelessWidget {
  final String vaccinationId;
  final String petId;
  final String title;
  final String dateText;
  final bool completed;
  final bool warning;

  const _VaccinationCard({
    required this.vaccinationId,
    required this.petId,
    required this.title,
    required this.dateText,
    required this.completed,
    required this.warning,
  });

  Future<void> _toggleCompleted(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('pets')
        .doc(petId)
        .collection('vaccinations')
        .doc(vaccinationId)
        .update({'completed': !completed});
  }

  Future<void> _deleteVaccination(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Vaccination'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance
          .collection('pets')
          .doc(petId)
          .collection('vaccinations')
          .doc(vaccinationId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightPink.withAlpha(90),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: primaryPink, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: warningRed, size: 20),
                onPressed: () => _deleteVaccination(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(dateText, style: const TextStyle(color: Colors.black54)),

          if (warning && !completed) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeRed.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Upcoming",
                style: TextStyle(color: badgeRed, fontSize: 12),
              ),
            ),
          ],

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _toggleCompleted(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: completed ? successGreen : warningRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Text(
                completed ? "Completed" : "Mark Complete",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showAddVaccinationBottomSheet(BuildContext context, Pet pet) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFECEE),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: _AddVaccinationForm(pet: pet),
        ),
      );
    },
  );
}

class _AddVaccinationForm extends StatefulWidget {
  final Pet pet;

  const _AddVaccinationForm({required this.pet});

  @override
  State<_AddVaccinationForm> createState() => _AddVaccinationFormState();
}

class _AddVaccinationFormState extends State<_AddVaccinationForm> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _isLoading = false;
  bool _isWarning = false;

  @override
  void dispose() {
    _typeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final type = _typeController.text.trim();
    final date = _dateController.text.trim();

    if (type.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in both fields.")),
      );
      return;
    }

    if (widget.pet.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Pet ID not found")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('pets')
          .doc(widget.pet.id)
          .collection('vaccinations')
          .add({
        'title': type,
        'dateText': date,
        'completed': false,
        'warning': _isWarning,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vaccination "$type" added!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: primaryPink.withAlpha(150),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Add Vaccination",
            style: TextStyle(
              color: primaryPink,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            "for ${widget.pet.name}",
            style: const TextStyle(color: primaryPink),
          ),
          const SizedBox(height: 20),

          _buildField(
            label: "Vaccination Type",
            controller: _typeController,
            hint: "e.g. Rabies, DHPP",
          ),
          const SizedBox(height: 16),
          _buildField(
            label: "Vaccination Date",
            controller: _dateController,
            hint: "e.g. Dec 10, 2025",
          ),

          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text('Mark as upcoming/warning'),
            value: _isWarning,
            onChanged: (val) => setState(() => _isWarning = val),
            activeColor: primaryPink,
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: successGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text(
                      "Save Record",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: warningRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: lightPink,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
