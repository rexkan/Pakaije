// Enhanced Model File - outfit_planner2_model.dart
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'outfit_planner2_widget.dart' show OutfitPlanner2Widget;
import 'package:flutter/material.dart';

// Outfit data model
class OutfitData {
  final String id;
  final String name;
  final String imagePath;
  final String category;

  OutfitData({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
  });
}

// Planned outfit model
class PlannedOutfit {
  final DateTime date;
  final OutfitData outfit;

  PlannedOutfit({
    required this.date,
    required this.outfit,
  });
}

class OutfitPlanner2Model extends FlutterFlowModel<OutfitPlanner2Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Calendar widget - simplified to single calendar
  DateTimeRange? calendarSelectedDay;

  // Planned outfits storage
  List<PlannedOutfit> plannedOutfits = [];

  // Available outfits (you can load this from database/API)
  List<OutfitData> availableOutfits = [
    OutfitData(
      id: '1',
      name: 'Casual Look 1',
      imagePath: 'assets/images/outfit1.jpg',
      category: 'Casual',
    ),
    OutfitData(
      id: '2',
      name: 'Formal Look 1',
      imagePath: 'assets/images/formal_look.webp',
      category: 'Formal',
    ),
    OutfitData(
      id: '3',
      name: 'Business Casual',
      imagePath: 'assets/images/business_casual.jpg',
      category: 'Business',
    ),
    OutfitData(
      id: '4',
      name: 'Evening Dress',
      imagePath: 'assets/images/evening_dress.jpg',
      category: 'Evening',
    ),
    OutfitData(
      id: '5',
      name: 'Sporty Look',
      imagePath: 'assets/images/sporty_look.jpg',
      category: 'Sport',
    ),
  ];

  @override
  void initState(BuildContext context) {
    // DO NOT set calendarSelectedDay to today's date to prevent auto-popup
    // Leave it null so no dialog shows on page load
    calendarSelectedDay = null;

    // Initialize with some sample planned outfits
    plannedOutfits = [
      PlannedOutfit(
        date: DateTime(2025, 8, 5), // Future date
        outfit: availableOutfits[0], // Casual Look 1
      ),
      PlannedOutfit(
        date: DateTime(2025, 8, 10), // Future date
        outfit: availableOutfits[1], // Formal Look 1
      ),
    ];
  }

  // Add new planned outfit
  void addPlannedOutfit(DateTime date, OutfitData outfit) {
    // Remove existing outfit for this date if any
    plannedOutfits.removeWhere((po) =>
        po.date.year == date.year &&
        po.date.month == date.month &&
        po.date.day == date.day);

    // Add new planned outfit
    plannedOutfits.add(PlannedOutfit(date: date, outfit: outfit));
    plannedOutfits.sort((a, b) => a.date.compareTo(b.date));
  }

  // Get planned outfit for a specific date
  OutfitData? getOutfitForDate(DateTime date) {
    try {
      return plannedOutfits
          .firstWhere((po) =>
              po.date.year == date.year &&
              po.date.month == date.month &&
              po.date.day == date.day)
          .outfit;
    } catch (e) {
      return null;
    }
  }

  // Get upcoming planned outfits
  List<PlannedOutfit> getUpcomingOutfits() {
    final now = DateTime.now();
    return plannedOutfits
        .where((po) => po.date.isAfter(now.subtract(Duration(days: 1))))
        .toList();
  }

  // Check if a date has a planned outfit (for calendar highlighting)
  bool hasOutfitForDate(DateTime date) {
    return plannedOutfits.any((po) =>
        po.date.year == date.year &&
        po.date.month == date.month &&
        po.date.day == date.day);
  }

  @override
  void dispose() {
    // No TabController to dispose anymore
  }
}
