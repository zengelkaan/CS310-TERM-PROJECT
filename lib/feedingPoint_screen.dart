import 'package:flutter/material.dart';

class FeedingPointsScreen extends StatelessWidget {
  const FeedingPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            const TopSearchBar(),
            const FilterRow(),
            const SizedBox(height: 8),
            // Map placeholder
            Container(
              height: 220,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE4E7EE),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Map Placeholder',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 12),
            // List of feeding points
            Expanded(
              child: ListView(
                padding:
                const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  FeedingPointCard(
                    title: 'Dormitory',
                    imageUrl:
                    'https://images.pexels.com/photos/271639/pexels-photo-271639.jpeg',
                    buttonText: 'yol tarifi al',
                  ),
                  SizedBox(height: 12),
                  FeedingPointCard(
                    title: 'Faculty of Engineering',
                    imageUrl:
                    'https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg',
                    buttonText: 'yol tarifi al',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-feeding');
        },
        shape: const StadiumBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TopSearchBar extends StatelessWidget {
  const TopSearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(16, 8, 16, 4),
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
            ),
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
  const FilterRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
          Border.all(color: const Color(0xFFE0E0E0)),
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
          // image + dots göstermek için Stack kullanabilirsin,
          // şimdilik sadece resim:
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Container(
              color: Colors.grey,
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            padding:
            const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              height: 40,
              width: 140,
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

class BottomNavBar extends StatelessWidget {
  const BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.notifications_none),
            Icon(Icons.pets_outlined),
            SizedBox(width: 40), // FAB boşluğu
            Icon(Icons.person_outline),
            Icon(Icons.chat_bubble_outline),
          ],
        ),
      ),
    );
  }
}
