import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async'; // Added missing import
import 'my_wardrode_model.dart';
export 'my_wardrode_model.dart';

class MyWardrodeWidget extends StatefulWidget {
  const MyWardrodeWidget({super.key});

  static String routeName = 'MyWardrode';
  static String routePath = '/myWardrode';

  @override
  State<MyWardrodeWidget> createState() => _MyWardrodeWidgetState();
}

class _MyWardrodeWidgetState extends State<MyWardrodeWidget> {
  late MyWardrodeModel _model;

  // Add a refresh key to force stream rebuild
  int _refreshKey = 0;

  // Add stream subscription to manage it manually
  StreamSubscription<List<WardrobeItemsRecord>>? _wardrobeStreamSubscription;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyWardrodeModel());

    // Force refresh when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _forceRefresh();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _wardrobeStreamSubscription?.cancel();
    super.dispose();
  }

  // Add method to force refresh
  void _forceRefresh() {
    setState(() {
      _refreshKey++;
    });
  }

  // Create a fresh stream each time
  Stream<List<WardrobeItemsRecord>> _getWardrobeStream() {
    return queryWardrobeItemsRecord(
      queryBuilder: (wardrobeItemsRecord) {
        return wardrobeItemsRecord
            .where('user_id', isEqualTo: currentUserUid)
            .orderBy('date_added', descending: true);
      },
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).underground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            FFLocalizations.of(context).getText(
              'cc9n9pk0' /* My Wardrode */,
            ),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
          actions: [
            // Add refresh button in app bar
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
                size: 20.0,
              ),
              onPressed: () {
                _forceRefresh();
              },
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            30.0, 30.0, 30.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                'xx8781di' /* Your Virtual Wardrobe */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    color: FlutterFlowTheme.of(context)
                                        .underground,
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  // Navigate to add item and refresh when returning
                                  final result = await context.pushNamed(
                                      'AddNewItem'); // Fixed route name
                                  // Force refresh when returning from add item screen
                                  _forceRefresh();
                                },
                                text: FFLocalizations.of(context).getText(
                                  '0k6okwgq' /* Add Item */,
                                ),
                                options: FFButtonOptions(
                                  height: 25.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color:
                                      FlutterFlowTheme.of(context).underground,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily:
                                            GoogleFonts.interTight().fontFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 330.0,
                        child: Divider(
                          height: 30.0,
                          thickness: 2.0,
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            30.0, 0.0, 30.0, 15.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 5.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'h95v1vtg' /* Sort by: */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .underground,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, 0.0),
                              child: FlutterFlowDropDown<String>(
                                controller: _model.dropDownValueController ??=
                                    FormFieldController<String>(
                                  _model.dropDownValue ??= 'All Clothes',
                                ),
                                options: [
                                  'All Clothes',
                                  'Tops',
                                  'Bottoms',
                                  'Skirts',
                                  'Shoes'
                                ],
                                onChanged: (val) => setState(() {
                                  _model.dropDownValue = val;
                                  // Force refresh when filter changes
                                  _forceRefresh();
                                }),
                                width: 150.0,
                                height: 30.0,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .underground,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                hintText: FFLocalizations.of(context).getText(
                                  '7d4ufn4n' /* Select */,
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor:
                                    FlutterFlowTheme.of(context).blankCanvas,
                                elevation: 2.0,
                                borderColor: Colors.transparent,
                                borderWidth: 0.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 12.0, 0.0),
                                hidesUnderline: true,
                                isOverButton: false,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 590.0, // Fixed height for the grid
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              15.0, 0.0, 15.0, 0.0),
                          child: StreamBuilder<List<WardrobeItemsRecord>>(
                            key: ValueKey(
                                _refreshKey), // Force rebuild with refresh key
                            stream: _getWardrobeStream(),
                            builder: (context, snapshot) {
                              // Add debug logging
                              print('=== StreamBuilder State Debug ===');
                              print(
                                  'Connection State: ${snapshot.connectionState}');
                              print('Has Error: ${snapshot.hasError}');
                              print('Has Data: ${snapshot.hasData}');
                              print(
                                  'Data Length: ${snapshot.data?.length ?? 0}');
                              print('Refresh Key: $_refreshKey');
                              print('Current User ID: $currentUserUid');

                              if (snapshot.hasError) {
                                print('Firestore error: ${snapshot.error}');
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 60.0,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Error loading items',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '${snapshot.error}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 16.0),
                                      FFButtonWidget(
                                        onPressed: _forceRefresh,
                                        text: 'Retry',
                                        options: FFButtonOptions(
                                          height: 30.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .underground,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    color: Colors.white,
                                                  ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              // Show loading only if we don't have data yet
                              if (!snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .underground,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Loading wardrobe...',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              List<WardrobeItemsRecord> allWardrobeItems =
                                  snapshot.data ?? [];

                              // Enhanced debug logging
                              print('=== Wardrobe Items Debug ===');
                              print(
                                  'Total items from Firestore: ${allWardrobeItems.length}');
                              print('Current filter: ${_model.dropDownValue}');
                              print('Stream timestamp: ${DateTime.now()}');

                              // Debug: Print all items with their document IDs
                              for (int i = 0;
                                  i < allWardrobeItems.length;
                                  i++) {
                                var item = allWardrobeItems[i];
                                print(
                                    'Item $i: ID="${item.reference.id}", name="${item.name}", category="${item.category}", user_id="${item.userId}"');
                              }

                              // Apply filtering based on dropdown selection
                              List<WardrobeItemsRecord> filteredItems =
                                  allWardrobeItems;

                              if (_model.dropDownValue != null &&
                                  _model.dropDownValue != 'All Clothes' &&
                                  _model.dropDownValue!.isNotEmpty) {
                                filteredItems = allWardrobeItems.where((item) {
                                  return item.category.toLowerCase() ==
                                      _model.dropDownValue!.toLowerCase();
                                }).toList();
                              }

                              print('Filtered items: ${filteredItems.length}');
                              print('=== End Debug Info ===');

                              if (filteredItems.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.checkroom,
                                        size: 80.0,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        _model.dropDownValue == 'All Clothes' ||
                                                _model.dropDownValue == null
                                            ? 'No items in your wardrobe yet'
                                            : 'No ${_model.dropDownValue} items found',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        _model.dropDownValue == 'All Clothes' ||
                                                _model.dropDownValue == null
                                            ? 'Add your first item to get started!'
                                            : 'Try selecting a different category or add new items',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 16.0),
                                      FFButtonWidget(
                                        onPressed: _forceRefresh,
                                        text: 'Refresh',
                                        options: FFButtonOptions(
                                          height: 30.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .underground,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    color: Colors.white,
                                                  ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return RefreshIndicator(
                                onRefresh: () async {
                                  _forceRefresh();
                                  // Wait a bit for the stream to update
                                  await Future.delayed(
                                      Duration(milliseconds: 500));
                                },
                                child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 1.0,
                                  ),
                                  scrollDirection: Axis.vertical,
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final wardrobeItem = filteredItems[index];
                                    return GestureDetector(
                                      onTap: () async {
                                        // Navigate to item detail/edit and refresh when returning
                                        final result = await context.pushNamed(
                                          'ItemDetail', // Replace with your actual item detail route
                                          queryParameters: {
                                            'itemId': wardrobeItem.reference.id
                                          },
                                        );
                                        // Force refresh when returning
                                        _forceRefresh();
                                      },
                                      onLongPress: () {
                                        // Show options dialog for delete/edit
                                        _showItemOptionsDialog(wardrobeItem);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x33000000),
                                              offset: Offset(0.0, 2.0),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                wardrobeItem.imageUrl,
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  print(
                                                      'Image load error for ${wardrobeItem.name}: $error');
                                                  return Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: 40.0,
                                                        ),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                          wardrobeItem.name,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 10.0,
                                                              ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              // Favorite icon overlay if item is favorite
                                              if (wardrobeItem.isFavourite)
                                                Positioned(
                                                  top: 5.0,
                                                  right: 5.0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(4.0),
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                      size: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              // Category badge
                                              Positioned(
                                                top: 5.0,
                                                left: 5.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .underground
                                                        .withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.0,
                                                      vertical: 2.0),
                                                  child: Text(
                                                    wardrobeItem.category,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          color: Colors.white,
                                                          fontSize: 8.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              // Item name overlay at bottom
                                              Positioned(
                                                bottom: 0.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment
                                                          .bottomCenter,
                                                      end: Alignment.topCenter,
                                                      colors: [
                                                        Colors.black
                                                            .withOpacity(0.7),
                                                        Colors.transparent,
                                                      ],
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 4.0,
                                                  ),
                                                  child: Text(
                                                    wardrobeItem.name,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          color: Colors.white,
                                                          fontSize: 10.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Modern Bottom Navigation Bar
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
                        .getText('l1ne2qaz' /* Home */),
                    isActive: false,
                    onTap: () => context.pushNamed('HomePage'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.checkroom_rounded,
                    label: FFLocalizations.of(context)
                        .getText('zg10biwv' /* Wardrobe */),
                    isActive: true, // This is the current page
                    onTap: () {
                      // Already on wardrobe page, just refresh
                      _forceRefresh();
                    },
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.style_rounded,
                    label: FFLocalizations.of(context)
                        .getText('53fiy14s' /* Match */),
                    isActive: false,
                    onTap: () => context.pushNamed('OutfitMatch'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.shopping_bag_rounded,
                    label: FFLocalizations.of(context)
                        .getText('fe3q2shz' /* Shop */),
                    isActive: false,
                    onTap: () => context.pushNamed('BuyClothes'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.calendar_month_rounded,
                    label: FFLocalizations.of(context)
                        .getText('un7ew6mp' /* Calendar */),
                    isActive: false,
                    onTap: () => context.pushNamed('OutfitPlanner2'),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.person_rounded,
                    label: FFLocalizations.of(context)
                        .getText('dme19kzg' /* Profile */),
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

  // Add method to show item options dialog
  void _showItemOptionsDialog(WardrobeItemsRecord item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete "${item.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteItem(item);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Add method to delete item
  Future<void> _deleteItem(WardrobeItemsRecord item) async {
    try {
      // Show confirmation dialog
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text(
                'Are you sure you want to delete "${item.name}"? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        // Delete the item from Firestore
        await item.reference.delete();

        // Force refresh to update UI immediately
        _forceRefresh();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item "${item.name}" deleted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        print('Item deleted: ${item.reference.id}');
      }
    } catch (e) {
      print('Error deleting item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting item: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
