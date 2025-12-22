import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/pet_provider.dart';
import '../widgets/custom_bottom_nav.dart';

class AddNewPetScreen extends StatefulWidget {
  const AddNewPetScreen({super.key});

  @override
  State<AddNewPetScreen> createState() => _AddNewPetScreenState();
}

class _AddNewPetScreenState extends State<AddNewPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kindController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  
  bool _isAvailableForAdoption = false;
  bool _isLoading = false;
  String _selectedImage = 'assets/images/max.jpg';

  final List<String> _availableImages = [
    'assets/images/max.jpg',
    'assets/images/luna.jpg',
    'assets/images/coco.jpg',
    'assets/images/limon.jpg',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _kindController.dispose();
    _breedController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    
    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to add a pet'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final petProvider = context.read<PetProvider>();
    
    final success = await petProvider.addPet(
      userId: authProvider.userId,
      name: _nameController.text.trim(),
      type: _kindController.text.trim(),
      breed: _breedController.text.trim(),
      gender: _genderController.text.trim(),
      age: _ageController.text.trim(),
      about: _aboutController.text.trim(),
      imagePath: _selectedImage,
      isAvailableForAdoption: _isAvailableForAdoption,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Success'),
            ],
          ),
          content: Text(
            '${_nameController.text} has been added successfully!${_isAvailableForAdoption ? '\n\nYour pet is now visible to others for adoption.' : ''}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(petProvider.errorMessage ?? 'Failed to add pet'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFAFD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add New Pet",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet Name
              _buildTextFormField(
                label: "Name:",
                controller: _nameController,
                hint: "Enter pet's name",
                icon: Icons.pets,
              ),
              const SizedBox(height: 16),
              
              // Pet Type/Kind
              _buildTextFormField(
                label: "Kind:",
                controller: _kindController,
                hint: "Dog, Cat, Bird, etc.",
                icon: Icons.category,
              ),
              const SizedBox(height: 16),
              
              // Breed
              _buildTextFormField(
                label: "Breed:",
                controller: _breedController,
                hint: "Golden Retriever, Siamese, etc.",
                icon: Icons.info_outline,
              ),
              const SizedBox(height: 16),
              
              // Gender
              _buildTextFormField(
                label: "Gender:",
                controller: _genderController,
                hint: "Male/Female",
                icon: Icons.male,
              ),
              const SizedBox(height: 16),
              
              // Age
              _buildTextFormField(
                label: "Age:",
                controller: _ageController,
                hint: "e.g. 2 years",
                icon: Icons.cake,
              ),
              
              const SizedBox(height: 24),

              // Photo Selection
              const Text(
                "Select Photo:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableImages.length,
                  itemBuilder: (context, index) {
                    final imagePath = _availableImages[index];
                    final isSelected = _selectedImage == imagePath;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedImage = imagePath);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.pink : Colors.grey[300]!,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            imagePath,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 90,
                              height: 90,
                              color: Colors.grey[300],
                              child: const Icon(Icons.pets),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // About Section
              const Text(
                "About:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  controller: _aboutController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write something about your pet...",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please tell us about the pet';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Available for Adoption Switch
              Card(
                child: SwitchListTile(
                  title: const Text(
                    'Available for Adoption',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    _isAvailableForAdoption
                        ? 'Other users can see this pet for adoption'
                        : 'Only you can see this pet',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  value: _isAvailableForAdoption,
                  onChanged: (value) {
                    setState(() => _isAvailableForAdoption = value);
                  },
                  activeColor: Colors.pink,
                ),
              ),

              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePet,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                          "Save Pet",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    IconData? icon,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon != null ? Icon(icon, size: 20) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
