import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class AddNewPetScreen extends StatelessWidget {
  const AddNewPetScreen({super.key});

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

      // It's often better not to have a bottom nav on a form screen, 
      // but if you want consistent navigation:
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _LabeledDropdownRow(label: "Kind:"),
            const SizedBox(height: 16),
            const _LabeledDropdownRow(label: "Breed:"),
            const SizedBox(height: 16),
            const _LabeledDropdownRow(label: "Gender:"),
            const SizedBox(height: 16),
            const _LabeledDropdownRow(label: "Age:"),

            const SizedBox(height: 30),

            const Text(
              "Photos:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Center(
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.black38),
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  size: 48,
                  color: Colors.black54,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "About:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write something about your pet...",
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.pink,
                   padding: const EdgeInsets.symmetric(vertical: 15),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                ),
                child: const Text("Save Pet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LabeledDropdownRow extends StatelessWidget {
  final String label;
  const _LabeledDropdownRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90, // Sabit label genişliği
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "",
                  style: TextStyle(color: Colors.black),
                ),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
