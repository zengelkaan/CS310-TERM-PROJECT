import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/map_preview.dart'; // Import MapPreview widget
import 'feeding_point_screen.dart'; // For TopSearchBar and FilterRow reuse
import '../models/feeding_point.dart';
import '../models/feeding_point_manager.dart';

class AddFeedingPointScreen extends StatefulWidget {
  const AddFeedingPointScreen({super.key});

  @override
  State<AddFeedingPointScreen> createState() => _AddFeedingPointScreenState();
}

class _AddFeedingPointScreenState extends State<AddFeedingPointScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addNewAddress() {
    if (_addressController.text.isNotEmpty) {
      final newPoint = FeedingPoint(
        title: _addressController.text,
        description: _descriptionController.text,
        imageUrl: 'assets/images/map.jpg', // Default image for now
      );
      
      FeedingPointManager().addFeedingPoint(newPoint);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feeding point added: ${_addressController.text}')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an address/name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F0F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopSearchBar(),
              const SizedBox(height: 8),
              // Map Preview Widget
              const MapPreview(),
              const SizedBox(height: 12),
              // Alt panel
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF2F5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  border: Border.all(
                    color: const Color(0xFFD38498),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'ADD NEW FEEDING POINT',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Color(0xFFD0738D),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address / Location Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 220,
                      height: 64,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD0738D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        onPressed: _addNewAddress,
                        child: const Text(
                          '+',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3), // Updated index to 3 (Feeding)
    );
  }
}
