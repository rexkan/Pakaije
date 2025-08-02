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
import 'dart:async';
import 'my_wardrode_model.dart';
export 'my_wardrode_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

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

  // Add these after the existing state variables
  bool _showOutfits = false; // Toggle between wardrobe items and outfits
  StreamSubscription<QuerySnapshot>? _outfitsStreamSubscription;

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
    _outfitsStreamSubscription?.cancel();
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

  // Method to get user's outfits
  Stream<QuerySnapshot> _getOutfitsStream() {
    return FirebaseFirestore.instance
        .collection('outfits')
        .where('user_id', isEqualTo: currentUserUid)
        .orderBy('created_time', descending: true)
        .snapshots();
  }

  // Build wardrobe items view
  Widget _buildWardrobeView() {
    return StreamBuilder<List<WardrobeItemsRecord>>(
      key: ValueKey(_refreshKey),
      stream: _getWardrobeStream(),
      builder: (context, snapshot) {
        // Add debug logging
        print('=== StreamBuilder State Debug ===');
        print('Connection State: ${snapshot.connectionState}');
        print('Has Error: ${snapshot.hasError}');
        print('Has Data: ${snapshot.hasData}');
        print('Data Length: ${snapshot.data?.length ?? 0}');
        print('Refresh Key: $_refreshKey');
        print('Current User ID: $currentUserUid');

        if (snapshot.hasError) {
          print('Firestore error: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 60.0, color: FlutterFlowTheme.of(context).error),
                SizedBox(height: 16.0),
                Text('Error loading items',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: FlutterFlowTheme.of(context).error,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: 8.0),
                Text('${snapshot.error}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: FlutterFlowTheme.of(context).error),
                    textAlign: TextAlign.center),
                SizedBox(height: 16.0),
                FFButtonWidget(
                    onPressed: _forceRefresh,
                    text: 'Retry',
                    options: FFButtonOptions(
                        height: 30.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        color: FlutterFlowTheme.of(context).underground,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                                fontFamily: GoogleFonts.interTight().fontFamily,
                                color: Colors.white),
                        borderRadius: BorderRadius.circular(8.0))),
              ],
            ),
          );
        }

        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).underground))),
                SizedBox(height: 16.0),
                Text('Loading wardrobe...',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: FlutterFlowTheme.of(context).secondaryText)),
              ],
            ),
          );
        }

        List<WardrobeItemsRecord> allWardrobeItems = snapshot.data ?? [];

        // Apply filtering based on dropdown selection
        List<WardrobeItemsRecord> filteredItems = allWardrobeItems;
        if (_model.dropDownValue != null &&
            _model.dropDownValue != 'All Clothes' &&
            _model.dropDownValue!.isNotEmpty) {
          filteredItems = allWardrobeItems.where((item) {
            return item.category.toLowerCase() ==
                _model.dropDownValue!.toLowerCase();
          }).toList();
        }

        if (filteredItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.checkroom,
                    size: 80.0,
                    color: FlutterFlowTheme.of(context).secondaryText),
                SizedBox(height: 16.0),
                Text(
                    _model.dropDownValue == 'All Clothes' ||
                            _model.dropDownValue == null
                        ? 'No items in your wardrobe yet'
                        : 'No ${_model.dropDownValue} items found',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: 8.0),
                Text(
                    _model.dropDownValue == 'All Clothes' ||
                            _model.dropDownValue == null
                        ? 'Add your first item to get started!'
                        : 'Try selecting a different category or add new items',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: FlutterFlowTheme.of(context).secondaryText),
                    textAlign: TextAlign.center),
                SizedBox(height: 16.0),
                FFButtonWidget(
                    onPressed: _forceRefresh,
                    text: 'Refresh',
                    options: FFButtonOptions(
                        height: 30.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        color: FlutterFlowTheme.of(context).underground,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                                fontFamily: GoogleFonts.interTight().fontFamily,
                                color: Colors.white),
                        borderRadius: BorderRadius.circular(8.0))),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _forceRefresh();
            await Future.delayed(Duration(milliseconds: 500));
          },
          child: GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.0),
            scrollDirection: Axis.vertical,
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final wardrobeItem = filteredItems[index];
              return GestureDetector(
                onTap: () async {
                  final result = await context.pushNamed('ItemDetail',
                      queryParameters: {'itemId': wardrobeItem.reference.id});
                  _forceRefresh();
                },
                onLongPress: () => _showItemOptionsDialog(wardrobeItem),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x33000000),
                            offset: Offset(0.0, 2.0))
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Stack(
                      children: [
                        Image.network(wardrobeItem.imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 40.0),
                                SizedBox(height: 4.0),
                                Text(wardrobeItem.name,
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                            fontFamily:
                                                GoogleFonts.inter().fontFamily,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 10.0),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          );
                        }),
                        if (wardrobeItem.isFavourite)
                          Positioned(
                              top: 5.0,
                              right: 5.0,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8),
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.favorite,
                                      color: Colors.red, size: 16.0))),
                        Positioned(
                            top: 5.0,
                            left: 5.0,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .underground
                                        .withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8.0)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 2.0),
                                child: Text(wardrobeItem.category,
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                            fontFamily:
                                                GoogleFonts.inter().fontFamily,
                                            color: Colors.white,
                                            fontSize: 8.0,
                                            fontWeight: FontWeight.bold)))),
                        Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent
                                    ])),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(wardrobeItem.name,
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                            fontFamily:
                                                GoogleFonts.inter().fontFamily,
                                            color: Colors.white,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis))),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Build outfits view
  Widget _buildOutfitsView() {
    return StreamBuilder<QuerySnapshot>(
      key: ValueKey('outfits_$_refreshKey'),
      stream: _getOutfitsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 60.0, color: FlutterFlowTheme.of(context).error),
                SizedBox(height: 16.0),
                Text('Error loading outfits',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: FlutterFlowTheme.of(context).error,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500)),
                FFButtonWidget(
                    onPressed: _forceRefresh,
                    text: 'Retry',
                    options: FFButtonOptions(
                        height: 30.0,
                        color: FlutterFlowTheme.of(context).underground)),
              ],
            ),
          );
        }

        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).underground)),
                SizedBox(height: 16.0),
                Text('Loading outfits...',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                        )),
              ],
            ),
          );
        }

        List<QueryDocumentSnapshot> outfitDocs = snapshot.data?.docs ?? [];

        if (outfitDocs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.style,
                    size: 80.0,
                    color: FlutterFlowTheme.of(context).secondaryText),
                SizedBox(height: 16.0),
                Text('No saved outfits yet',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: 8.0),
                Text('Create your first outfit to get started!',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: FlutterFlowTheme.of(context).secondaryText),
                    textAlign: TextAlign.center),
                SizedBox(height: 16.0),
                FFButtonWidget(
                    onPressed: () => context.pushNamed('OutfitMatch'),
                    text: 'Create Outfit',
                    options: FFButtonOptions(
                        height: 40.0,
                        color: FlutterFlowTheme.of(context).underground,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                                fontFamily: GoogleFonts.interTight().fontFamily,
                                color: Colors.white))),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _forceRefresh();
            await Future.delayed(Duration(milliseconds: 500));
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: outfitDocs.length,
            itemBuilder: (context, index) {
              final outfitDoc = outfitDocs[index];
              final outfitData = outfitDoc.data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.only(bottom: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(0.0, 2.0))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(outfitData['name'] ?? 'Unnamed Outfit',
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                      fontFamily:
                                          GoogleFonts.inter().fontFamily,
                                      fontWeight: FontWeight.w600)),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'delete') {
                              _deleteOutfit(outfitDoc.id,
                                  outfitData['name'] ?? 'Unnamed Outfit');
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete',
                                    style: TextStyle(color: Colors.red))),
                          ],
                          child: Icon(Icons.more_vert,
                              color:
                                  FlutterFlowTheme.of(context).secondaryText),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(_formatDate(outfitData['created_time']),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            color: FlutterFlowTheme.of(context).secondaryText)),
                    SizedBox(height: 12.0),
                    Row(
                      children: [
                        _buildOutfitItemPreview(
                            outfitData['top_item_id'], 'Top'),
                        SizedBox(width: 8.0),
                        _buildOutfitItemPreview(
                            outfitData['bottom_item_id'], 'Bottom'),
                        SizedBox(width: 8.0),
                        _buildOutfitItemPreview(
                            outfitData['shoes_item_id'], 'Shoes'),
                        Spacer(),
                        // In your MyWardrodeWidget, update the "Try On" button in _buildOutfitsView()

                        FFButtonWidget(
                          onPressed: () {
                            try {
                              // Get the current outfit data
                              final currentOutfitData = outfitData;

                              // Prepare size scales if they exist
                              String? sizeScalesJson;
                              if (currentOutfitData['item_size_scales'] !=
                                  null) {
                                final scales =
                                    currentOutfitData['item_size_scales']
                                        as Map<String, dynamic>;
                                Map<String, double> sizeScales = {
                                  'Tops': (scales['Tops'] ?? 1.0).toDouble(),
                                  'Bottoms':
                                      (scales['Bottoms'] ?? 1.0).toDouble(),
                                  'Shoes': (scales['Shoes'] ?? 1.0).toDouble(),
                                };
                                sizeScalesJson = jsonEncode(sizeScales);
                              }

                              // Debug print to verify data before navigation
                              print('=== Pre-Navigation Debug ===');
                              print(
                                  'Outfit Name: ${currentOutfitData['name']}');
                              print(
                                  'Top Item ID: ${currentOutfitData['top_item_id']}');
                              print(
                                  'Bottom Item ID: ${currentOutfitData['bottom_item_id']}');
                              print(
                                  'Shoes Item ID: ${currentOutfitData['shoes_item_id']}');
                              print('Size Scales JSON: $sizeScalesJson');

                              // Prepare query parameters
                              Map<String, String> queryParams = {
                                'loadOutfit': 'true',
                                'outfitName':
                                    currentOutfitData['name']?.toString() ??
                                        'Unnamed Outfit',
                                'outfitId': outfitDoc.id,
                              };

                              // Add item IDs if they exist
                              if (currentOutfitData['top_item_id'] != null &&
                                  currentOutfitData['top_item_id']
                                      .toString()
                                      .isNotEmpty) {
                                queryParams['topItemId'] =
                                    currentOutfitData['top_item_id'].toString();
                              }

                              if (currentOutfitData['bottom_item_id'] != null &&
                                  currentOutfitData['bottom_item_id']
                                      .toString()
                                      .isNotEmpty) {
                                queryParams['bottomItemId'] =
                                    currentOutfitData['bottom_item_id']
                                        .toString();
                              }

                              if (currentOutfitData['shoes_item_id'] != null &&
                                  currentOutfitData['shoes_item_id']
                                      .toString()
                                      .isNotEmpty) {
                                queryParams['shoesItemId'] =
                                    currentOutfitData['shoes_item_id']
                                        .toString();
                              }

                              // Add size scales if they exist
                              if (sizeScalesJson != null) {
                                queryParams['sizeScales'] = sizeScalesJson;
                              }

                              print('Final query parameters: $queryParams');

                              // Navigate to OutfitMatch with parameters
                              context.pushNamed(
                                'OutfitMatch', // Use the existing route name
                                queryParameters: queryParams,
                              );
                            } catch (e) {
                              print('❌ Error navigating to try-on: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error loading outfit for try-on: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          text: 'Try On',
                          options: FFButtonOptions(
                            height: 32.0,
                            width: 80.0,
                            color: FlutterFlowTheme.of(context).underground,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  color: Colors.white,
                                ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Helper method to build outfit item preview
  Widget _buildOutfitItemPreview(String? itemId, String type) {
    if (itemId == null) {
      return Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: FlutterFlowTheme.of(context).alternate)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add,
                color: FlutterFlowTheme.of(context).secondaryText, size: 20.0),
            Text(type,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 8.0)),
          ],
        ),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('wardrobe_items')
          .doc(itemId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).alternate,
                borderRadius: BorderRadius.circular(8.0)),
            child: Icon(Icons.image_not_supported,
                color: FlutterFlowTheme.of(context).secondaryText),
          );
        }

        final itemData = snapshot.data!.data() as Map<String, dynamic>;
        return Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(itemData['image_url'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                    color: FlutterFlowTheme.of(context).alternate,
                    child: Icon(Icons.image_not_supported,
                        color: FlutterFlowTheme.of(context).secondaryText))),
          ),
        );
      },
    );
  }

  // Helper method to format date
  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown date';
    try {
      final date = (timestamp as Timestamp).toDate();
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown date';
    }
  }

  // Method to delete outfit
  Future<void> _deleteOutfit(String outfitId, String outfitName) async {
    try {
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Outfit'),
            content: Text('Are you sure you want to delete "$outfitName"?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Delete', style: TextStyle(color: Colors.red))),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        await FirebaseFirestore.instance
            .collection('outfits')
            .doc(outfitId)
            .delete();
        _forceRefresh();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Outfit "$outfitName" deleted successfully'),
            backgroundColor: Colors.green));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error deleting outfit: $e'),
          backgroundColor: Colors.red));
    }
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _showOutfits
                                      ? 'Your Saved Outfits'
                                      : FFLocalizations.of(context).getText(
                                          'xx8781di' /* Your Virtual Wardrobe */),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily:
                                            GoogleFonts.inter().fontFamily,
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
                                      if (_showOutfits) {
                                        // Navigate to outfit match page
                                        context.pushNamed('OutfitMatch');
                                      } else {
                                        // Navigate to add item and refresh when returning
                                        final result = await context
                                            .pushNamed('AddNewItem');
                                        _forceRefresh();
                                      }
                                    },
                                    text: _showOutfits
                                        ? 'Create Outfit'
                                        : FFLocalizations.of(context)
                                            .getText('0k6okwgq' /* Add Item */),
                                    options: FFButtonOptions(
                                      height: 25.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context)
                                          .underground,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: GoogleFonts.interTight()
                                                .fontFamily,
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
                            SizedBox(height: 15.0),
                            // Toggle buttons between Wardrobe Items and Outfits
                            Container(
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .alternate
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _showOutfits = false;
                                          _forceRefresh();
                                        });
                                      },
                                      child: Container(
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: !_showOutfits
                                              ? FlutterFlowTheme.of(context)
                                                  .underground
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Wardrobe Items',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      GoogleFonts.inter()
                                                          .fontFamily,
                                                  color: !_showOutfits
                                                      ? Colors.white
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .underground,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _showOutfits = true;
                                          _forceRefresh();
                                        });
                                      },
                                      child: Container(
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: _showOutfits
                                              ? FlutterFlowTheme.of(context)
                                                  .underground
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Saved Outfits',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      GoogleFonts.inter()
                                                          .fontFamily,
                                                  color: _showOutfits
                                                      ? Colors.white
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .underground,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                      if (!_showOutfits) // Only show sort dropdown for wardrobe items
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
                          child: _showOutfits
                              ? _buildOutfitsView()
                              : _buildWardrobeView(),
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
                    fontFamily: GoogleFonts.inter().fontFamily,
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
}
