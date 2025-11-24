import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/map_preview.dart'; // Import MapPreview widget
import '../models/feeding_point_manager.dart';

class FeedingPointsScreen extends StatefulWidget {
  const FeedingPointsScreen({super.key});

  @override
  State<FeedingPointsScreen> createState() => _FeedingPointsScreenState();
}

class _FeedingPointsScreenState extends State<FeedingPointsScreen> {
  @override
  void initState() {
    super.initState();
    // Listen to changes in FeedingPointManager
    FeedingPointManager().addListener(_updateList);
  }

  @override
  void dispose() {
    FeedingPointManager().removeListener(_updateList);
    super.dispose();
  }

  void _updateList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final feedingPoints = FeedingPointManager().feedingPoints;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            const TopSearchBar(),
            const FilterRow(),
            const SizedBox(height: 8),
            // Map Preview Widget
            const MapPreview(),
            const SizedBox(height: 12),
            // List of feeding points
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: feedingPoints.length,
                itemBuilder: (context, index) {
                  final point = feedingPoints[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FeedingPointCard(
                      title: point.title,
                      imageUrl: point.imageUrl,
                      buttonText: point.buttonText,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3), // Index 3 for Feeding
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_feeding_point');
        },
        shape: const StadiumBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TopSearchBar extends StatelessWidget {
  const TopSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // back + icons bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              Row(
                children: const [
                  Icon(Icons.signal_cellular_alt, size: 18),
                  SizedBox(width: 4),
                  Icon(Icons.wifi, size: 18),
                  SizedBox(width: 4),
                  Icon(Icons.battery_full, size: 18),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Search bar
          Container(
            height: 44,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                ]),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.search),
                const SizedBox(width: 8),
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 4),
                const Text(
                  'sabancı university',
                  style: TextStyle(fontSize: 14),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterRow extends StatelessWidget {
  const FilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _FilterChipButton(
            label: 'Filter',
            icon: Icons.keyboard_arrow_down,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _FilterChipButton(
            label: 'Sort',
            icon: Icons.keyboard_arrow_down,
            onTap: () {},
          ),
          const Spacer(),
          const Text(
            '5 results',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Text(label),
            const SizedBox(width: 2),
            Icon(icon, size: 18),
          ],
        ),
      ),
    );
  }
}

class FeedingPointCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String buttonText;

  const FeedingPointCard({
    required this.title,
    required this.imageUrl,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                    color: Colors.grey,
                    child: const Center(
                        child: Icon(Icons.image_not_supported, color: Colors.white)));
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              height: 40,
              width: 160,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: Text(buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
