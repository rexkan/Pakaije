import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'outfit_planner2_model.dart';
export 'outfit_planner2_model.dart';

class OutfitPlanner2Widget extends StatefulWidget {
  const OutfitPlanner2Widget({super.key});

  static String routeName = 'OutfitPlanner2';
  static String routePath = '/outfitPlanner2';

  @override
  State<OutfitPlanner2Widget> createState() => _OutfitPlanner2WidgetState();
}

class _OutfitPlanner2WidgetState extends State<OutfitPlanner2Widget> {
  late OutfitPlanner2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _calendarInitialized = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OutfitPlanner2Model());

    // Initialize calendar after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _calendarInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Show outfit selection popup
  void _showOutfitSelectionDialog(DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Select Outfit for ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                        style: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .override(
                              fontFamily: 'Inter Tight',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 20.0),

                // Show existing selection if any
                FutureBuilder<OutfitsRecord?>(
                  future: _model.getOutfitForDate(selectedDate),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent3,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: FlutterFlowTheme.of(context).tertiary,
                              size: 20.0,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Current: ${snapshot.data!.name}',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                    ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final success = await _model
                                    .removePlannedOutfit(selectedDate);
                                if (success) {
                                  if (dialogContext.mounted) {
                                    Navigator.of(dialogContext).pop();
                                  }
                                  if (mounted) {
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            const Text('Outfit plan removed!'),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context).error,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Remove',
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Loading state or outfit grid
                Expanded(
                  child: _model.isLoadingOutfits
                      ? Center(
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        )
                      : _model.availableOutfits.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.checkroom_outlined,
                                    size: 64.0,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    'No outfits available',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Create some outfits first!',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.0,
                                mainAxisSpacing: 12.0,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: _model.availableOutfits.length,
                              itemBuilder: (context, index) {
                                final outfit = _model.availableOutfits[index];

                                return FutureBuilder<OutfitsRecord?>(
                                  future: _model.getOutfitForDate(selectedDate),
                                  builder: (context, snapshot) {
                                    final isSelected = snapshot.hasData &&
                                        snapshot.data?.reference.id ==
                                            outfit.reference.id;

                                    return GestureDetector(
                                      onTap: () async {
                                        // Show loading dialog
                                        showDialog(
                                          context: dialogContext,
                                          barrierDismissible: false,
                                          builder: (loadingContext) => Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                          ),
                                        );

                                        // Save to Firebase
                                        final success =
                                            await _model.addPlannedOutfit(
                                                selectedDate, outfit);

                                        // Close loading dialog
                                        if (dialogContext.mounted) {
                                          Navigator.of(dialogContext).pop();
                                        }

                                        if (success) {
                                          // Close selection dialog
                                          if (dialogContext.mounted) {
                                            Navigator.of(dialogContext).pop();
                                          }

                                          if (mounted) {
                                            setState(() {});
                                            // Show success message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Outfit "${outfit.name}" planned for ${DateFormat('MMM dd').format(selectedDate)}!',
                                                ),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                duration:
                                                    const Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        } else {
                                          if (mounted) {
                                            // Show error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'Failed to save outfit plan. Please try again.'),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: isSelected
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                : FlutterFlowTheme.of(context)
                                                    .alternate,
                                            width: isSelected ? 3.0 : 1.0,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x1A000000),
                                              offset: Offset(0.0, 2.0),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Outfit placeholder
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(12.0),
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(12.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.checkroom,
                                                    size: 50.0,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Outfit Details
                                            Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    outfit.name,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              'Inter Tight',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 4.0),
                                                  if (outfit.isSuggested)
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6.0,
                                                          vertical: 2.0),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent3,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: Text(
                                                        'AI Suggested',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .tertiary,
                                                                  fontSize: 9.0,
                                                                ),
                                                      ),
                                                    ),
                                                  if (isSelected)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0),
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        size: 16.0,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
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
        );
      },
    );
  }

  // Build planned outfit list item
  Widget _buildPlannedOutfitItem(PlannedOutfit plannedOutfit) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 1.0),
            )
          ],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Outfit icon on the left
              GestureDetector(
                onTap: () => _showOutfitSelectionDialog(plannedOutfit.date),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  margin: const EdgeInsets.only(right: 12.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    Icons.checkroom,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                ),
              ),
              // Outfit details
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plannedOutfit.outfit.name,
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Inter Tight',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 18.0,
                              ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          DateFormat('dd/MM/yyyy').format(plannedOutfit.date),
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Inter',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                        if (plannedOutfit.planRecord?.event?.isNotEmpty ==
                            true) ...[
                          const SizedBox(width: 12.0),
                          Icon(
                            Icons.event,
                            size: 14.0,
                            color: FlutterFlowTheme.of(context).tertiary,
                          ),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              plannedOutfit.planRecord!.event,
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    fontFamily: 'Inter',
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation Item Builder - UPDATED TO MATCH HOME PAGE
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: isActive
              ? FlutterFlowTheme.of(context).waxFlower.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.0,
              color: isActive
                  ? FlutterFlowTheme.of(context).waxFlower
                  : FlutterFlowTheme.of(context).info,
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Inter',
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive
                        ? FlutterFlowTheme.of(context).waxFlower
                        : FlutterFlowTheme.of(context).info,
                    fontSize: 11.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            FFLocalizations.of(context)
                .getText('nb7yeaja' /* Outfit Planner */),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Inter Tight',
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await _model.refreshData();
                if (mounted) {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Data refreshed!'),
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.refresh,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Calendar Widget with highlighting
                        StreamBuilder<List<OutfitPlansRecord>>(
                          stream: queryOutfitPlansRecord(
                            queryBuilder: (outfitPlansRecord) =>
                                outfitPlansRecord.where('user_id',
                                    isEqualTo: currentUserUid),
                          ),
                          builder: (context, planSnapshot) {
                            // Update local data when stream updates
                            if (planSnapshot.hasData &&
                                planSnapshot.data != null) {
                              // Sort the data locally
                              final sortedData = List<OutfitPlansRecord>.from(
                                  planSnapshot.data!);
                              sortedData.sort((a, b) {
                                if (a.date == null && b.date == null) return 0;
                                if (a.date == null) return 1;
                                if (b.date == null) return -1;
                                return a.date!.compareTo(b.date!);
                              });

                              _model.updatePlannedOutfitRecords(sortedData);
                            }

                            final plannedDates = _model.getPlannedOutfitDates();

                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Color(0x33000000),
                                    offset: Offset(0.0, 1.0),
                                  )
                                ],
                              ),
                              child: Stack(
                                children: [
                                  FlutterFlowCalendar(
                                    color: FlutterFlowTheme.of(context)
                                        .underground,
                                    iconColor: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    weekFormat: false,
                                    weekStartsMonday: true,
                                    onChange: (DateTimeRange? newSelectedDate) {
                                      setState(() =>
                                          _model.calendarSelectedDay =
                                              newSelectedDate);

                                      // Only show dialog when calendar is initialized and date is selected
                                      if (_calendarInitialized &&
                                          newSelectedDate != null) {
                                        _showOutfitSelectionDialog(
                                            newSelectedDate.start);
                                      }
                                    },
                                    titleStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          letterSpacing: 0.0,
                                        ),
                                    dayOfWeekStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                    dateStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                    selectedDateStyle:
                                        FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Inter Tight',
                                              letterSpacing: 0.0,
                                            ),
                                    inactiveDateStyle:
                                        FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0.0,
                                            ),
                                    locale: FFLocalizations.of(context)
                                        .languageCode,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // Upcoming Outfits Section
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20.0, 16.0, 20.0, 0.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                        'yvs9q8r4' /* Coming Outfit */),
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 20.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  if (_model.isLoadingPlans)
                                    SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Upcoming outfits list - Fast synchronous version
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: StreamBuilder<List<OutfitPlansRecord>>(
                                stream: queryOutfitPlansRecord(
                                  queryBuilder: (outfitPlansRecord) =>
                                      outfitPlansRecord.where('user_id',
                                          isEqualTo: currentUserUid),
                                ),
                                builder: (context, planSnapshot) {
                                  // Update local data when stream updates
                                  if (planSnapshot.hasData &&
                                      planSnapshot.data != null) {
                                    // Sort the data locally
                                    final sortedData =
                                        List<OutfitPlansRecord>.from(
                                            planSnapshot.data!);
                                    sortedData.sort((a, b) {
                                      if (a.date == null && b.date == null)
                                        return 0;
                                      if (a.date == null) return 1;
                                      if (b.date == null) return -1;
                                      return a.date!.compareTo(b.date!);
                                    });

                                    _model
                                        .updatePlannedOutfitRecords(sortedData);
                                  }

                                  // Get upcoming outfits synchronously (fast)
                                  final upcomingOutfits =
                                      _model.getUpcomingOutfitsSync();

                                  if (upcomingOutfits.isEmpty) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_outlined,
                                              size: 48.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                            ),
                                            const SizedBox(height: 12.0),
                                            Text(
                                              'No upcoming outfit plans',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleMedium
                                                  .override(
                                                    fontFamily: 'Inter Tight',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                  ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              'Tap on calendar dates to plan your outfits!',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                      ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  // Build the list directly with immediate data
                                  return Column(
                                    children: upcomingOutfits
                                        .map((plannedOutfit) =>
                                            _buildPlannedOutfitItem(
                                                plannedOutfit))
                                        .toList(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Modern Bottom Navigation Bar - UPDATED TO MATCH HOME PAGE
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).underground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.home_rounded,
                    label: FFLocalizations.of(context)
                        .getText('juu7t29n' /* Home */),
                    isActive: false,
                    onTap: () => context.pushNamed('HomePage'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.checkroom_rounded,
                    label: FFLocalizations.of(context)
                        .getText('j10f5yzy' /* Wardrobe */),
                    isActive: false,
                    onTap: () => context.pushNamed('MyWardrobe'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.style_rounded,
                    label: FFLocalizations.of(context)
                        .getText('rud9dgwq' /* Match */),
                    isActive: false,
                    onTap: () => context.pushNamed('OutfitMatch'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.shopping_bag_rounded,
                    label: FFLocalizations.of(context)
                        .getText('addqz4ow' /* Shop */),
                    isActive: false,
                    onTap: () => context.pushNamed('BuyClothes'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.calendar_month_rounded,
                    label: FFLocalizations.of(context)
                        .getText('4sm6nxfd' /* Calendar */),
                    isActive: true, // This is the current page
                    onTap: () {
                      // Already on calendar page
                    },
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.person_rounded,
                    label: FFLocalizations.of(context)
                        .getText('lswy1ody' /* Profile */),
                    isActive: false,
                    onTap: () => context.pushNamed('UserProfile'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
