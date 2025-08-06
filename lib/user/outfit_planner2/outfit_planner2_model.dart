import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'outfit_planner2_widget.dart' show OutfitPlanner2Widget;
import 'package:flutter/material.dart';

// Data class to hold planned outfit information
class PlannedOutfit {
  final DateTime date;
  final OutfitsRecord outfit;
  final OutfitPlansRecord? planRecord;

  PlannedOutfit({
    required this.date,
    required this.outfit,
    this.planRecord,
  });
}

class OutfitPlanner2Model extends FlutterFlowModel<OutfitPlanner2Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;

  // Loading states
  bool isLoadingOutfits = false;
  bool isLoadingPlans = false;

  // Data lists
  List<OutfitsRecord> availableOutfits = [];
  List<OutfitPlansRecord> plannedOutfitRecords = [];

  // Cache for upcoming outfits to avoid recalculation
  List<PlannedOutfit> _cachedUpcomingOutfits = [];
  DateTime? _lastCacheUpdate;

  @override
  void initState(BuildContext context) {
    // Initialize data loading
    _loadInitialData();
  }

  @override
  void dispose() {
    // Cleanup resources if needed
  }

  /// Load initial data from Firebase
  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadAvailableOutfits(),
      _loadPlannedOutfits(),
    ]);
  }

  /// Load available outfits for the current user
  Future<void> _loadAvailableOutfits() async {
    if (currentUserUid.isEmpty) {
      debugPrint('Warning: currentUserUid is empty');
      return;
    }

    isLoadingOutfits = true;

    try {
      final outfits = await queryOutfitsRecordOnce(
        queryBuilder: (outfitsRecord) => outfitsRecord
            .where('user_id', isEqualTo: currentUserUid)
            .orderBy('created_time', descending: true),
      );

      availableOutfits = outfits;
      debugPrint('Loaded ${availableOutfits.length} outfits');
    } catch (e) {
      debugPrint('Error loading outfits: $e');
      availableOutfits = [];
    } finally {
      isLoadingOutfits = false;
    }
  }

  /// Load planned outfits for the current user
  Future<void> _loadPlannedOutfits() async {
    if (currentUserUid.isEmpty) {
      debugPrint('Warning: currentUserUid is empty');
      return;
    }

    isLoadingPlans = true;

    try {
      // Use a simpler query to avoid index requirements
      final plans = await queryOutfitPlansRecordOnce(
        queryBuilder: (outfitPlansRecord) =>
            outfitPlansRecord.where('user_id', isEqualTo: currentUserUid),
      );

      // Sort locally instead of in the query
      plans.sort((a, b) {
        if (a.date == null && b.date == null) return 0;
        if (a.date == null) return 1;
        if (b.date == null) return -1;
        return a.date!.compareTo(b.date!);
      });

      plannedOutfitRecords = plans;
      debugPrint('Loaded ${plannedOutfitRecords.length} outfit plans');
    } catch (e) {
      debugPrint('Error loading outfit plans: $e');
      plannedOutfitRecords = [];
    } finally {
      isLoadingPlans = false;
    }
  }

  /// Get upcoming planned outfits (synchronous version using cached data)
  List<PlannedOutfit> getUpcomingOutfitsSync() {
    if (currentUserUid.isEmpty) return [];

    try {
      // Use cache if it's recent (less than 1 minute old)
      final now = DateTime.now();
      if (_lastCacheUpdate != null &&
          now.difference(_lastCacheUpdate!).inMinutes < 1 &&
          _cachedUpcomingOutfits.isNotEmpty) {
        return _cachedUpcomingOutfits;
      }

      // If no data loaded yet, return empty list (data will load in background)
      if (plannedOutfitRecords.isEmpty || availableOutfits.isEmpty) {
        return [];
      }

      // Get current date (start of today)
      final today = DateTime(now.year, now.month, now.day);

      // Filter planned outfits for future dates (including today)
      final upcomingPlans = plannedOutfitRecords.where((plan) {
        if (plan.date == null) return false;
        final planDate =
            DateTime(plan.date!.year, plan.date!.month, plan.date!.day);
        return planDate.isAfter(today) || planDate.isAtSameMomentAs(today);
      }).toList();

      // Sort by date (earliest first)
      upcomingPlans.sort((a, b) => a.date!.compareTo(b.date!));

      // Get outfit details for each plan
      List<PlannedOutfit> result = [];

      for (final plan in upcomingPlans) {
        if (plan.date == null || plan.outfitId.isEmpty) continue;

        // Find the outfit by ID
        final outfitIndex = availableOutfits.indexWhere(
          (outfit) => outfit.reference.id == plan.outfitId,
        );

        if (outfitIndex != -1) {
          final outfit = availableOutfits[outfitIndex];
          result.add(PlannedOutfit(
            date: plan.date!,
            outfit: outfit,
            planRecord: plan,
          ));
        }
        // Skip missing outfits without async operations
      }

      // Update cache
      _cachedUpcomingOutfits = result;
      _lastCacheUpdate = now;

      return result;
    } catch (e) {
      debugPrint('Error getting upcoming outfits sync: $e');
      return [];
    }
  }

  /// Get upcoming planned outfits (async version for thorough data loading)
  Future<List<PlannedOutfit>> getUpcomingOutfits() async {
    if (currentUserUid.isEmpty) return [];

    try {
      // Ensure we have data loaded first
      if (plannedOutfitRecords.isEmpty || availableOutfits.isEmpty) {
        await _loadInitialData();
      }

      // Return the sync version for speed
      return getUpcomingOutfitsSync();
    } catch (e) {
      debugPrint('Error getting upcoming outfits: $e');
      return [];
    }
  }

  /// Clear the cache when data changes
  void clearUpcomingOutfitsCache() {
    _cachedUpcomingOutfits.clear();
    _lastCacheUpdate = null;
  }

  /// Update the planned outfit records from stream
  void updatePlannedOutfitRecords(List<OutfitPlansRecord> newRecords) {
    plannedOutfitRecords = newRecords;
    // Clear cache when data updates
    clearUpcomingOutfitsCache();
  }

  /// Refresh all data from Firebase - Force fresh data
  Future<void> refreshData() async {
    // Set loading states
    isLoadingOutfits = true;
    isLoadingPlans = true;

    // Clear existing data first
    plannedOutfitRecords.clear();
    availableOutfits.clear();
    clearUpcomingOutfitsCache();

    // Load fresh data
    await _loadInitialData();
  }

  /// Get outfit for a specific date
  Future<OutfitsRecord?> getOutfitForDate(DateTime date) async {
    try {
      // Find plan for this date
      final plan = plannedOutfitRecords.firstWhere(
        (plan) =>
            plan.date != null &&
            plan.date!.year == date.year &&
            plan.date!.month == date.month &&
            plan.date!.day == date.day,
        orElse: () => throw Exception('No plan found'),
      );

      // Find the outfit
      final outfit = availableOutfits.firstWhere(
        (outfit) => outfit.reference.id == plan.outfitId,
        orElse: () => throw Exception('Outfit not found'),
      );

      return outfit;
    } catch (e) {
      return null;
    }
  }

  /// Add a planned outfit for a specific date
  Future<bool> addPlannedOutfit(DateTime date, OutfitsRecord outfit) async {
    if (currentUserUid.isEmpty) return false;

    try {
      // Check if there's already a plan for this date
      final existingPlanIndex = plannedOutfitRecords.indexWhere(
        (plan) =>
            plan.date != null &&
            plan.date!.year == date.year &&
            plan.date!.month == date.month &&
            plan.date!.day == date.day,
      );

      if (existingPlanIndex != -1) {
        // Update existing plan
        final existingPlan = plannedOutfitRecords[existingPlanIndex];

        // Update in Firestore
        await existingPlan.reference.update({
          'outfit_id': outfit.reference.id,
          'created_time': getCurrentTimestamp,
        });

        // Update local data - Create a new record with updated data
        final updatedData = {
          'user_id': currentUserUid,
          'date': date,
          'outfit_id': outfit.reference.id,
          'event': existingPlan.event,
          'created_time': getCurrentTimestamp,
        };

        plannedOutfitRecords[existingPlanIndex] =
            OutfitPlansRecord.getDocumentFromData(
                updatedData, existingPlan.reference);
      } else {
        // Create new plan
        final newPlanRef = OutfitPlansRecord.collection.doc();
        final planData = createOutfitPlansRecordData(
          userId: currentUserUid,
          date: date,
          outfitId: outfit.reference.id,
          event: '',
          createdTime: getCurrentTimestamp,
        );

        await newPlanRef.set(planData);

        // Add to local data
        plannedOutfitRecords.add(
          OutfitPlansRecord.getDocumentFromData(planData, newPlanRef),
        );
      }

      // Clear cache after changes
      clearUpcomingOutfitsCache();
      return true;
    } catch (e) {
      debugPrint('Error adding planned outfit: $e');
      return false;
    }
  }

  /// Remove planned outfit for a specific date
  Future<bool> removePlannedOutfit(DateTime date) async {
    try {
      // Find and remove plan for this date
      final planIndex = plannedOutfitRecords.indexWhere(
        (plan) =>
            plan.date != null &&
            plan.date!.year == date.year &&
            plan.date!.month == date.month &&
            plan.date!.day == date.day,
      );

      if (planIndex != -1) {
        final plan = plannedOutfitRecords[planIndex];
        await plan.reference.delete();
        plannedOutfitRecords.removeAt(planIndex);

        // Clear cache after changes
        clearUpcomingOutfitsCache();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error removing planned outfit: $e');
      return false;
    }
  }

  /// Get all dates that have planned outfits
  List<DateTime> getPlannedOutfitDates() {
    try {
      return plannedOutfitRecords
          .where((plan) => plan.date != null)
          .map((plan) => plan.date!)
          .toList();
    } catch (e) {
      debugPrint('Error getting planned outfit dates: $e');
      return [];
    }
  }

  /// Check if a specific date has a planned outfit
  bool hasOutfitForDate(DateTime date) {
    return plannedOutfitRecords.any((plan) =>
        plan.date != null &&
        plan.date!.year == date.year &&
        plan.date!.month == date.month &&
        plan.date!.day == date.day);
  }
}
