import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import 'feeding_point_screen.dart'; // For TopSearchBar and FilterRow reuse

class AddFeedingPointScreen extends StatelessWidget {
  const AddFeedingPointScreen({super.key});

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
              Container(
                height: 220,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E7EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  'https://static.mapquest.com/api/staticmap/v5/map?key=8BwG17g1j1G1j1G1&center=40.8915,29.3792&zoom=15&size=600,400', // Dummy static map URL
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => const Text(
                    'Map View',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
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
                        onPressed: () {
                            Navigator.pop(context);
                        },
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
