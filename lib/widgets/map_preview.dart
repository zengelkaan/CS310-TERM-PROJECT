import 'package:flutter/material.dart';

class MapPreview extends StatelessWidget {
  const MapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE4E7EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Interactive Map Image
          InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 4.0,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                'https://tile.openstreetmap.org/12/2410/1545.png', // Istanbul area OSM tile
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => CustomPaint(
                  size: const Size(double.infinity, double.infinity),
                  painter: _MapPlaceholderPainter(),
                ),
              ),
            ),
          ),
          
          // Center Pin
          const Center(
            child: Icon(Icons.location_on, color: Colors.red, size: 48),
          ),
          
          // Top Right Layer Icon (Visual)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: const Icon(Icons.layers_outlined, size: 20, color: Colors.black87),
            ),
          ),
          
          // Bottom Right Zoom Controls (Visual)
          Positioned(
            bottom: 12,
            right: 12,
            child: Column(
              children: [
                _buildMapControl(Icons.add),
                const SizedBox(height: 8),
                _buildMapControl(Icons.remove),
              ],
            ),
          ),
          
          // Google-like "Map" label or similar visual cue (Optional)
           Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              color: Colors.white.withOpacity(0.7),
              child: const Text(
                'Pawfect Map',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControl(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
           BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Icon(icon, size: 20, color: Colors.black87),
    );
  }
}

// Custom painter to draw a map-like placeholder with roads and water
class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background - land color (light beige/cream like Google Maps)
    final landPaint = Paint()..color = const Color(0xFFF5F3F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), landPaint);

    // Water areas (light blue)
    final waterPaint = Paint()..color = const Color(0xFFAAD3DF);
    
    // Draw a river/water body
    final waterPath = Path();
    waterPath.moveTo(0, size.height * 0.3);
    waterPath.quadraticBezierTo(size.width * 0.3, size.height * 0.35, size.width * 0.5, size.height * 0.4);
    waterPath.quadraticBezierTo(size.width * 0.7, size.height * 0.45, size.width, size.height * 0.35);
    waterPath.lineTo(size.width, size.height * 0.55);
    waterPath.quadraticBezierTo(size.width * 0.7, size.height * 0.6, size.width * 0.5, size.height * 0.55);
    waterPath.quadraticBezierTo(size.width * 0.3, size.height * 0.5, 0, size.height * 0.5);
    waterPath.close();
    canvas.drawPath(waterPath, waterPaint);

    // Major roads (orange/yellow like highways)
    final majorRoadPaint = Paint()
      ..color = const Color(0xFFFCD581)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    
    // Horizontal major road
    canvas.drawLine(
      Offset(0, size.height * 0.7),
      Offset(size.width, size.height * 0.65),
      majorRoadPaint,
    );
    
    // Diagonal major road
    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.8, size.height),
      majorRoadPaint,
    );

    // Minor roads (white/light gray)
    final minorRoadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    // Grid of minor roads
    for (int i = 1; i < 5; i++) {
      // Vertical roads
      canvas.drawLine(
        Offset(size.width * i / 5, 0),
        Offset(size.width * i / 5, size.height),
        minorRoadPaint,
      );
      // Horizontal roads
      canvas.drawLine(
        Offset(0, size.height * i / 5),
        Offset(size.width, size.height * i / 5),
        minorRoadPaint,
      );
    }

    // Parks/green areas
    final parkPaint = Paint()..color = const Color(0xFFCDEAC0);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.15, size.height * 0.15), width: 50, height: 40),
      parkPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.85, size.height * 0.8), width: 60, height: 45),
      parkPaint,
    );

    // Some building blocks (light gray rectangles)
    final buildingPaint = Paint()..color = const Color(0xFFE8E6E3);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.6, size.height * 0.1, 30, 25), buildingPaint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.1, size.height * 0.75, 35, 30), buildingPaint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.7, size.height * 0.7, 25, 20), buildingPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
