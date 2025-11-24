import 'package:flutter/foundation.dart';
import 'feeding_point.dart';

class FeedingPointManager extends ChangeNotifier {
  static final FeedingPointManager _instance = FeedingPointManager._internal();

  factory FeedingPointManager() {
    return _instance;
  }

  FeedingPointManager._internal();

  final List<FeedingPoint> _feedingPoints = [
    FeedingPoint(
      title: 'Dormitory',
      imageUrl: 'assets/images/dormitory.jpg',
      buttonText: 'Get Directions',
    ),
    FeedingPoint(
      title: 'Faculty of Engineering',
      imageUrl: 'assets/images/engineering.jpg',
      buttonText: 'Get Directions',
    ),
  ];

  List<FeedingPoint> get feedingPoints => List.unmodifiable(_feedingPoints);

  void addFeedingPoint(FeedingPoint point) {
    _feedingPoints.add(point);
    notifyListeners();
  }
}




