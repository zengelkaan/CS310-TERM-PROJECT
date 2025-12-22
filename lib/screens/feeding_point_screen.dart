import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/map_preview.dart';
import '../models/feeding_point.dart';
import '../providers/feeding_point_provider.dart';
import '../providers/auth_provider.dart';

class FeedingPointsScreen extends StatefulWidget {
  const FeedingPointsScreen({super.key});

  @override
  State<FeedingPointsScreen> createState() => _FeedingPointsScreenState();
}

class _FeedingPointsScreenState extends State<FeedingPointsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            TopSearchBar(
              onSearchChanged: (query) {
                setState(() => _searchQuery = query);
              },
            ),
            const FilterRow(),
            const SizedBox(height: 8),
            const MapPreview(),
            const SizedBox(height: 12),
            // Real-time list from Firestore
            Expanded(
              child: StreamBuilder<List<FeedingPoint>>(
                stream: context.read<FeedingPointProvider>().streamFeedingPoints(),
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

                  var feedingPoints = snapshot.data ?? [];

                  // Filter by search query
                  if (_searchQuery.isNotEmpty) {
                    feedingPoints = feedingPoints
                        .where((point) =>
                            point.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            point.description.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .toList();
                  }

                  if (feedingPoints.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No feeding points match your search'
                                : 'No feeding points yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add a new feeding point using the + button',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: feedingPoints.length,
                    itemBuilder: (context, index) {
                      final point = feedingPoints[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FeedingPointCard(
                          feedingPoint: point,
                          onDelete: () => _deleteFeedingPoint(point),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
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

  Future<void> _deleteFeedingPoint(FeedingPoint point) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Feeding Point'),
        content: Text('Are you sure you want to delete "${point.title}"?'),
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

    if (confirmed == true && point.id != null && mounted) {
      final success = await context.read<FeedingPointProvider>().deleteFeedingPoint(point.id!);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${point.title} deleted')),
        );
      }
    }
  }
}

class TopSearchBar extends StatefulWidget {
  final Function(String)? onSearchChanged;
  
  const TopSearchBar({super.key, this.onSearchChanged});

  @override
  State<TopSearchBar> createState() => _TopSearchBarState();
}

class _TopSearchBarState extends State<TopSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back + icons bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
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
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.search),
                const SizedBox(width: 8),
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search feeding points...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: widget.onSearchChanged,
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      widget.onSearchChanged?.call('');
                    },
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
          StreamBuilder<List<FeedingPoint>>(
            stream: context.read<FeedingPointProvider>().streamFeedingPoints(),
            builder: (context, snapshot) {
              final count = snapshot.data?.length ?? 0;
              return Text(
                '$count results',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              );
            },
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
  final FeedingPoint feedingPoint;
  final VoidCallback? onDelete;

  const FeedingPointCard({
    required this.feedingPoint,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final isOwner = authProvider.userId == feedingPoint.createdBy;

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.asset(
              feedingPoint.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.location_on, size: 48, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedingPoint.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (feedingPoint.description.isNotEmpty)
                        Text(
                          feedingPoint.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (isOwner && onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Delete',
                  ),
              ],
            ),
          ),
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening directions...')),
                  );
                },
                child: Text(feedingPoint.buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
