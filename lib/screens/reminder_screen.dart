//Hilal Ongel 
//I created this two screen before. Anyone can see my commit histoy in the main branch. After my team did their screens we met and arranged coherence between screens and  bottom navigator.To get coherence I updated my draft version which is on main branc. Updated version is right below:
import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../models/vaccination.dart';
import '../widgets/custom_bottom_nav.dart';

// COLORS
const Color primaryPink = Color(0xFFC1485F);
const Color cardPink = Color(0xFFDEB9C0);
const Color lightPink = Color(0xFFC6A2A3);

const Color warningRed = Color(0xFFD9534F);
const Color badgeRed = Color(0xFFFF7676);
const Color successGreen = Color(0xFF3CB371);


// Global list to share with my pets  page

final List<Pet> allPets = [
  Pet(
    name: "Max",
    breed: "Golden Retriever", // Added breed to match new Pet model
    gender: "Male",
    age: "3 years",
    imagePath: "assets/images/max.jpg",
    type: "Dog",
    vaccinations: [
      Vaccination(title: "Rabies", dateText: "Dec 1, 2025"),
      Vaccination(
        title: "DHPP",
        dateText: "Dec 8, 2025",
        warning: true,
      ),
    ],
  ),
  Pet(
    name: "Luna",
    breed: "Siamese",
    gender: "Female",
    age: "2 years",
    imagePath: "assets/images/luna.jpg",
    type: "Cat",
    vaccinations: [
      Vaccination(title: "Rabies", dateText: "Dec 12, 2025"),
      Vaccination(
        title: "FVRCP",
        dateText: "Dec 5, 2025",
        completed: true,
      ),
    ],
  ),
];

// ===================================================================
// REMINDER SCREEN
// ===================================================================

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
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

      // Using Home index as it's accessed from Home
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          
          ...allPets.map(
            (pet) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: _PetCard(
                pet: pet,
                onAddVaccination: () async {
                  final newVacc =
                      await _showAddVaccinationBottomSheet(context, pet);
                  if (newVacc != null) {
                    setState(() {
                      pet.vaccinations.add(newVacc);
                    });
                  }
                },
                onToggleVaccination: (vaccination) {
                  setState(() {
                    vaccination.completed = !vaccination.completed;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// PET CARD
// ===================================================================

class _PetCard extends StatelessWidget {
  final Pet pet;
  final Future<void> Function() onAddVaccination;
  final void Function(Vaccination) onToggleVaccination;

  const _PetCard({
    required this.pet,
    required this.onAddVaccination,
    required this.onToggleVaccination,
  });

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
          Text(
            pet.name,
            style: const TextStyle(
              fontSize: 20,
              color: primaryPink,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(pet.type, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 10),

          ...pet.vaccinations.map(
            (v) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _VaccinationCard(
                vaccination: v,
                onToggle: () => onToggleVaccination(v),
              ),
            ),
          ),

          const SizedBox(height: 6),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onAddVaccination();
              },
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

// ===================================================================
// VACCINATION CARD 
// ===================================================================

class _VaccinationCard extends StatelessWidget {
  final Vaccination vaccination;
  final VoidCallback onToggle;

  const _VaccinationCard({
    required this.vaccination,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = vaccination.completed;

    return Container(
      decoration: BoxDecoration(
        color: lightPink.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today,
                  color: primaryPink, size: 18),
              const SizedBox(width: 8),
              Text(
                vaccination.title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            vaccination.dateText,
            style: const TextStyle(color: Colors.black54),
          ),

          if (vaccination.warning && !isCompleted) ...[
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "in 3 days",
                style: TextStyle(color: badgeRed, fontSize: 12),
              ),
            ),
          ],

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onToggle,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isCompleted ? successGreen : warningRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Text(
                isCompleted ? "Completed" : "Mark Complete",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// BOTTOM SHEET : new vaccination
// ===================================================================

Future<Vaccination?> _showAddVaccinationBottomSheet(
    BuildContext context, Pet pet) {
  return showModalBottomSheet<Vaccination>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black.withOpacity(0.3),
    builder: (ctx) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFECEE),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
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

// ===================================================================
// FORM – input + Save Record → new Vaccination
// ===================================================================

class _AddVaccinationForm extends StatefulWidget {
  final Pet pet;

  const _AddVaccinationForm({required this.pet});

  @override
  State<_AddVaccinationForm> createState() => _AddVaccinationFormState();
}

class _AddVaccinationFormState extends State<_AddVaccinationForm> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _typeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _save() {
    final type = _typeController.text.trim();
    final date = _dateController.text.trim();

    if (type.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in both fields."),
        ),
      );
      return;
    }

    final newVacc = Vaccination(
      title: type,
      dateText: date,
      completed: false,
      warning: false,
    );

    Navigator.pop(context, newVacc);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: primaryPink.withOpacity(.6),
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

        _field(
          label: "Vaccination Type",
          controller: _typeController,
          hint: "e.g. Rabies",
        ),
        const SizedBox(height: 16),
        _field(
          label: "Vaccination Date",
          controller: _dateController,
          hint: "e.g. Dec 10, 2025",
        ),

        const SizedBox(height: 24),

        const Text(
          "Current Vaccinations:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: cardPink,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: widget.pet.vaccinations
                .map((v) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _CurrentVaccRow(
                        name: v.title,
                        date: v.dateText,
                      ),
                    ))
                .toList(),
          ),
        ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: successGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              "Save Record",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, null),
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
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: lightPink,
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(color: Colors.white),
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

class _CurrentVaccRow extends StatelessWidget {
  final String name;
  final String date;

  const _CurrentVaccRow({required this.name, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: const TextStyle(color: primaryPink)),
        Text(date, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}
