// Enhanced Widget File - outfit_planner2_widget.dart
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _isInitialLoad = true; // Track if this is initial load

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OutfitPlanner2Model());

    // Set a delay to mark initial load as complete
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isInitialLoad = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Show outfit selection popup (simplified version)
  void _showOutfitSelectionDialog(DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Outfit for ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.interTight(),
                                color: FlutterFlowTheme.of(context).underground,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),

                Divider(height: 20.0),

                // Simplified Outfit Grid - Only image and name
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _model.availableOutfits.length,
                    itemBuilder: (context, index) {
                      final outfit = _model.availableOutfits[index];
                      final isSelected =
                          _model.getOutfitForDate(selectedDate)?.id ==
                              outfit.id;

                      return GestureDetector(
                        onTap: () {
                          _model.addPlannedOutfit(selectedDate, outfit);
                          Navigator.of(context).pop();
                          setState(() {});

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Outfit planned for ${DateFormat('MMM dd').format(selectedDate)}!'),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).waxFlower,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: isSelected
                                  ? FlutterFlowTheme.of(context).waxFlower
                                  : FlutterFlowTheme.of(context).alternate,
                              width: isSelected ? 3.0 : 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x1A000000),
                                offset: Offset(0.0, 2.0),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Outfit Image
                              Expanded(
                                flex: 4,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12.0),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12.0),
                                    ),
                                    child: Image.asset(
                                      outfit.imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 50.0,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              // Outfit Name Only
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      outfit.name,
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.interTight(),
                                            color: FlutterFlowTheme.of(context)
                                                .underground,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                    if (isSelected)
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: FlutterFlowTheme.of(context)
                                              .waxFlower,
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
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 3.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 1.0),
            )
          ],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                    child: Text(
                      plannedOutfit.outfit.name,
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.interTight(),
                                color: FlutterFlowTheme.of(context).underground,
                                fontSize: 22.0,
                              ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(plannedOutfit.date),
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).underground,
                              ),
                        ),
                        SizedBox(width: 8.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent3,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            plannedOutfit.outfit.category,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  font: GoogleFonts.inter(),
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  fontSize: 10.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(8.0),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1.0,
                  ),
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    plannedOutfit.outfit.imagePath,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modern Navigation Item Builder (copied from home page)
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
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
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
            SizedBox(height: 4.0),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.inter(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
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
                  font: GoogleFonts.interTight(),
                  color: FlutterFlowTheme.of(context).underground,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
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
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3.0,
                                color: Color(0x33000000),
                                offset: Offset(0.0, 1.0),
                              )
                            ],
                          ),
                          child: FlutterFlowCalendar(
                            color: FlutterFlowTheme.of(context).waxFlower,
                            iconColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            weekFormat: false,
                            weekStartsMonday: true,
                            onChange: (DateTimeRange? newSelectedDate) {
                              safeSetState(() =>
                                  _model.calendarSelectedDay = newSelectedDate);
                              // Only show dialog when date is selected by user (not initial auto-selection)
                              if (newSelectedDate != null && !_isInitialLoad) {
                                _showOutfitSelectionDialog(
                                    newSelectedDate.start);
                              }
                            },
                            titleStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  font: GoogleFonts.interTight(),
                                  letterSpacing: 0.0,
                                ),
                            dayOfWeekStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(),
                                  letterSpacing: 0.0,
                                ),
                            dateStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(),
                                  letterSpacing: 0.0,
                                ),
                            selectedDateStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                              font: GoogleFonts.interTight(),
                              letterSpacing: 0.0,
                              shadows: [
                                Shadow(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 2.0,
                                )
                              ],
                            ),
                            inactiveDateStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(),
                                  letterSpacing: 0.0,
                                ),
                            locale: FFLocalizations.of(context).languageCode,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 12.0, 0.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context)
                                    .getText('yvs9q8r4' /* Coming Outfit */),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold),
                                      color: FlutterFlowTheme.of(context)
                                          .underground,
                                      fontSize: 20.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: Column(
                                children: _model
                                    .getUpcomingOutfits()
                                    .map((plannedOutfit) =>
                                        _buildPlannedOutfitItem(plannedOutfit))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: 100.0), // Add bottom spacing for nav bar
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Modern Bottom Navigation Bar (copied from home page)
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).underground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.0,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.home_rounded,
                    label: FFLocalizations.of(context)
                        .getText('juu7t29n' /* Home */),
                    isActive: false,
                    onTap: () => context.pushNamed(HomePageWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.checkroom_rounded,
                    label: FFLocalizations.of(context)
                        .getText('j10f5yzy' /* Wardrobe */),
                    isActive: false,
                    onTap: () => context.pushNamed(MyWardrodeWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.style_rounded,
                    label: FFLocalizations.of(context)
                        .getText('rud9dgwq' /* Match */),
                    isActive: false,
                    onTap: () => context.pushNamed(OutfitMatchWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.shopping_bag_rounded,
                    label: FFLocalizations.of(context)
                        .getText('addqz4ow' /* Shop */),
                    isActive: false,
                    onTap: () => context.pushNamed(BuyClothesWidget.routeName),
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
                    onTap: () => context.pushNamed(UserProfileWidget.routeName),
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
