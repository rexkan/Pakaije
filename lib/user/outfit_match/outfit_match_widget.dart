import 'package:firebase_auth/firebase_auth.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/backend.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'outfit_match_model.dart';
export 'outfit_match_model.dart';

class OutfitMatchWidget extends StatefulWidget {
  const OutfitMatchWidget({super.key});

  static String routeName = 'OutfitMatch';
  static String routePath = '/outfitMatch';

  @override
  State<OutfitMatchWidget> createState() => _OutfitMatchWidgetState();
}

class _OutfitMatchWidgetState extends State<OutfitMatchWidget> {
  late OutfitMatchModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // 🔥 NEW: Body view and outfit state
  String? userBodyImageUrl;
  String? currentUserId;
  List<WardrobeItemsRecord> wardrobeItems = [];
  Map<String, WardrobeItemsRecord?> selectedItems = {
    'Top': null,
    'Bottom': null,
    'Shoes': null,
  };
  Map<String, Offset> itemPositions = {
    'Top': Offset(0.5, 0.25), // Relative positions (0.0 to 1.0)
    'Bottom': Offset(0.5, 0.55),
    'Shoes': Offset(0.5, 0.85),
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OutfitMatchModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _loadUserData();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      // Get current authenticated user ID from Firebase Auth
      currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null || currentUserId!.isEmpty) {
        print('No authenticated user found');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Load user's profile data including front body image
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final frontBodyUrl = userData['front_body_image_url'] as String?;

        // Check if it's a valid URL (not a local path)
        if (frontBodyUrl != null &&
            (frontBodyUrl.startsWith('http://') ||
                frontBodyUrl.startsWith('https://'))) {
          userBodyImageUrl = frontBodyUrl;
        } else {
          // Handle local paths or invalid URLs
          userBodyImageUrl = null;
          print(
              'Front body image is a local path or invalid URL: $frontBodyUrl');
        }
      }

      // Load user's wardrobe items
      final wardrobeQuery = await FirebaseFirestore.instance
          .collection('wardrobe_items')
          .where('user_id', isEqualTo: currentUserId)
          .get();

      wardrobeItems = wardrobeQuery.docs
          .map((doc) => WardrobeItemsRecord.fromSnapshot(doc))
          .toList();

      print('📊 Loaded ${wardrobeItems.length} wardrobe items for user');
      print('🖼️ Front body image URL: $userBodyImageUrl');

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // 🔥 NEW: Filter wardrobe items by category
  List<WardrobeItemsRecord> _getItemsByCategory(String category) {
    return wardrobeItems
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // 🔥 NEW: Handle item drop on body
  void _handleItemDrop(String slot, WardrobeItemsRecord item, Offset position) {
    setState(() {
      selectedItems[slot] = item;
      // Convert global position to relative position (0.0 to 1.0)
      // This will need to be calculated based on the actual drop area
      itemPositions[slot] = position;
    });
  }

  // 🔥 NEW: Remove item from outfit
  void _removeItem(String slot) {
    setState(() {
      selectedItems[slot] = null;
    });
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
              '5dhiappa' /* Virtual Try On */,
            ),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(),
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
          elevation: 0.0,
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
                      // Header Section
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            4.0, 20.0, 16.0, 0.0), // Much more left-aligned
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Your Look',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.inter(),
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Drag items onto your body to try them on',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Outfit Name Input
                      Container(
                        width: double.infinity,
                        margin: EdgeInsetsDirectional.fromSTEB(
                            4.0, 20.0, 16.0, 0.0), // Matched left alignment
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x0F000000),
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Outfit Name',
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    font: GoogleFonts.inter(),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            SizedBox(height: 12.0),
                            TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'e.g., Casual Friday Look',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 16.0, 16.0, 16.0),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    font: GoogleFonts.inter(),
                                    letterSpacing: 0.0,
                                  ),
                              validator: _model.textControllerValidator
                                  .asValidator(context),
                            ),
                          ],
                        ),
                      ),

                      // 🔥 NEW: Vertical Layout - Virtual Try-On Section (Full Width)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsetsDirectional.fromSTEB(
                            4.0, 20.0, 16.0, 0.0), // Consistent left alignment
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x0F000000),
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 16.0, 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Virtual Try-On',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          font: GoogleFonts.inter(),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Row(
                                    children: [
                                      FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 8.0,
                                        buttonSize: 40.0,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .accent1,
                                        icon: Icon(
                                          Icons.clear_all,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 20.0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            selectedItems = {
                                              'Top': null,
                                              'Bottom': null,
                                              'Shoes': null,
                                            };
                                          });
                                        },
                                      ),
                                      SizedBox(width: 8),
                                      FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 8.0,
                                        buttonSize: 40.0,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .accent1,
                                        icon: Icon(
                                          Icons.refresh,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 20.0,
                                        ),
                                        onPressed: _loadUserData,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Virtual Try-On Body View (Full Width)
                            Container(
                              width: double.infinity,
                              height:
                                  400.0, // Fixed reasonable height for mobile
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 16.0),
                              child: Stack(
                                children: [
                                  // Background body image or placeholder
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: userBodyImageUrl != null &&
                                              userBodyImageUrl!.isNotEmpty
                                          ? Image.network(
                                              userBodyImageUrl!,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return _buildPlaceholderBody();
                                              },
                                            )
                                          : _buildPlaceholderBody(),
                                    ),
                                  ),

                                  // Drag target zones
                                  ..._buildResponsiveDragTargets(400.0),

                                  // Positioned items
                                  ..._buildResponsivePositionedItems(400.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 🔥 NEW: Wardrobe Items Section (Below Virtual Try-On)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsetsDirectional.fromSTEB(
                            4.0, 20.0, 16.0, 0.0), // Consistent left alignment
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              color: Color(0x0F000000),
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 16.0, 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.checkroom,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24.0,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Your Wardrobe',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          font: GoogleFonts.inter(),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (isLoading)
                              Padding(
                                padding: EdgeInsets.all(40.0),
                                child: CircularProgressIndicator(),
                              )
                            else ...[
                              _buildHorizontalCategorySection(
                                  'Tops', _getItemsByCategory('Top')),
                              SizedBox(height: 16.0),
                              _buildHorizontalCategorySection(
                                  'Bottoms', _getItemsByCategory('Bottom')),
                              SizedBox(height: 16.0),
                              _buildHorizontalCategorySection(
                                  'Shoes', _getItemsByCategory('Shoes')),
                              SizedBox(height: 16.0),
                            ],
                          ],
                        ),
                      ),

                      // Action Buttons
                      Container(
                        width: double.infinity,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            4.0, 30.0, 16.0, 0.0), // Consistent left alignment
                        child: Center(
                          child: FFButtonWidget(
                            onPressed: () {
                              _saveOutfit();
                            },
                            text: 'Save New Outfit',
                            icon: Icon(
                              Icons.favorite_border,
                              size: 20.0,
                            ),
                            options: FFButtonOptions(
                              width: 200.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 8.0, 0.0),
                              color: FlutterFlowTheme.of(context).underground,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.0,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 100.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigation(),
      ),
    );
  }

  // 🔥 NEW: Build placeholder body when no image is set
  Widget _buildPlaceholderBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).accent4,
            FlutterFlowTheme.of(context).accent3,
          ],
          stops: [0.0, 1.0],
          begin: AlignmentDirectional(0.0, -1.0),
          end: AlignmentDirectional(0, 1.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 80.0,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          SizedBox(height: 16),
          Text(
            'Go to Profile to upload\nyour body view',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  // 🔥 UPDATED: Build responsive drag target zones for fixed height
  List<Widget> _buildResponsiveDragTargets(double containerHeight) {
    return [
      // Top zone - responsive positioning
      Positioned(
        left: 20,
        right: 20,
        top: containerHeight * 0.15, // 15% from top
        height: containerHeight * 0.25, // 25% of container height
        child: DragTarget<Map<String, dynamic>>(
          onAccept: (data) {
            if (data['item'] is WardrobeItemsRecord &&
                data['item'].category.toLowerCase() == 'top') {
              _handleItemDrop('top', data['item'], Offset(0.5, 0.25));
            }
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              decoration: BoxDecoration(
                color: candidateData.isNotEmpty
                    ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: candidateData.isNotEmpty
                    ? Border.all(
                        color: FlutterFlowTheme.of(context).primary, width: 2)
                    : Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
              ),
              child: candidateData.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.checkroom,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Drop Top Here',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        'Tops',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
      // Bottom zone - responsive positioning
      Positioned(
        left: 20,
        right: 20,
        top: containerHeight * 0.45, // 45% from top
        height: containerHeight * 0.3, // 30% of container height
        child: DragTarget<Map<String, dynamic>>(
          onAccept: (data) {
            if (data['item'] is WardrobeItemsRecord &&
                data['item'].category.toLowerCase() == 'Bottom') {
              _handleItemDrop('Bottom', data['item'], Offset(0.5, 0.55));
            }
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              decoration: BoxDecoration(
                color: candidateData.isNotEmpty
                    ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: candidateData.isNotEmpty
                    ? Border.all(
                        color: FlutterFlowTheme.of(context).primary, width: 2)
                    : Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
              ),
              child: candidateData.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.straighten,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Drop Bottom Here',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        'Bottoms',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
      // Shoes zone - responsive positioning
      Positioned(
        left: 20,
        right: 20,
        bottom: containerHeight * 0.05, // 5% from bottom
        height: containerHeight * 0.15, // 15% of container height
        child: DragTarget<Map<String, dynamic>>(
          onAccept: (data) {
            if (data['item'] is WardrobeItemsRecord &&
                data['item'].category.toLowerCase() == 'shoes') {
              _handleItemDrop('shoes', data['item'], Offset(0.5, 0.85));
            }
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              decoration: BoxDecoration(
                color: candidateData.isNotEmpty
                    ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: candidateData.isNotEmpty
                    ? Border.all(
                        color: FlutterFlowTheme.of(context).primary, width: 2)
                    : Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
              ),
              child: candidateData.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_run,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Drop Shoes Here',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        'Shoes',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    ];
  }

  // 🔥 UPDATED: Build responsive positioned items for fixed height
  List<Widget> _buildResponsivePositionedItems(double containerHeight) {
    List<Widget> positioned = [];

    selectedItems.forEach((slot, item) {
      if (item != null) {
        final position = itemPositions[slot]!;
        final itemSize = 60.0; // Fixed size for better mobile experience

        positioned.add(
          Positioned(
            left: (MediaQuery.of(context).size.width * 0.5) -
                (itemSize / 2), // Center horizontally
            top: (position.dy * containerHeight) - (itemSize / 2),
            child: GestureDetector(
              onTap: () => _removeItem(slot),
              child: Container(
                width: itemSize,
                height: itemSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: FlutterFlowTheme.of(context).primary, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        item.imageUrl,
                        width: itemSize,
                        height: itemSize,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: FlutterFlowTheme.of(context).accent3,
                            child: Icon(Icons.image_not_supported,
                                size: itemSize * 0.4),
                          );
                        },
                      ),
                    ),
                    // Remove indicator
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });

    return positioned;
  }

  // 🔥 NEW: Horizontal category section for vertical layout
  Widget _buildHorizontalCategorySection(
      String title, List<WardrobeItemsRecord> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.inter(),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                    ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).accent1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${items.length}',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (items.isEmpty)
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'No ${title.toLowerCase()} found',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 14.0,
                    ),
              ),
            ),
          )
        else
          Container(
            height: 100.0, // Fixed height for horizontal scroll
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Draggable<Map<String, dynamic>>(
                    data: {'item': item, 'category': title.toLowerCase()},
                    feedback: Material(
                      child: Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    childWhenDragging: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .accent4
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                      ),
                      child: Icon(
                        Icons.drag_handle,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                    ),
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2.0,
                            color: Color(0x0F000000),
                            offset: Offset(0.0, 1.0),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: FlutterFlowTheme.of(context).accent3,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 24.0,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  // 🔥 NEW: Compact category section for mobile
  Widget _buildCompactCategorySection(
      String title, List<WardrobeItemsRecord> items) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 2.0,
            color: Color(0x0F000000),
            offset: Offset(0.0, 1.0),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0, // Smaller font for mobile
                        letterSpacing: 0.0,
                      ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).accent1,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${items.length}',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No ${title.toLowerCase()}',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12,
                    ),
              ),
            )
          else
            Container(
              height: 90, // Reduced height for mobile
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 6),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Draggable<Map<String, dynamic>>(
                      data: {'item': item, 'category': title.toLowerCase()},
                      feedback: Material(
                        child: Container(
                          width: 60, // Smaller feedback size
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent4,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.drag_handle,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 16,
                        ),
                      ),
                      child: Container(
                        width: 60, // Smaller items for mobile
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: FlutterFlowTheme.of(context).accent3,
                                child:
                                    Icon(Icons.image_not_supported, size: 20),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  // 🔥 NEW: Save outfit functionality
  void _saveOutfit() async {
    if (_model.textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an outfit name')),
      );
      return;
    }

    if (selectedItems.values.every((item) => item == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one item to your outfit')),
      );
      return;
    }

    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to save outfits')),
      );
      return;
    }

    try {
      // Create outfit record
      await FirebaseFirestore.instance.collection('outfits').add({
        'user_id': currentUserId,
        'name': _model.textController.text.trim(),
        'top_item_id': selectedItems['Top']?.reference.id,
        'bottom_item_id': selectedItems['Bottom']?.reference.id,
        'shoes_item_id': selectedItems['Shoes']?.reference.id,
        'created_time': FieldValue.serverTimestamp(),
        'is_suggested': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Outfit "${_model.textController.text.trim()}" saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the form
      _model.textController?.clear();
      setState(() {
        selectedItems = {
          'Top': null,
          'Bottom': null,
          'Shoes': null,
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving outfit: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Bottom Navigation
  Widget _buildBottomNavigation() {
    return Container(
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
                label:
                    FFLocalizations.of(context).getText('gxiqwln6' /* Home */),
                isActive: false,
                onTap: () => context.pushNamed('HomePage'),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.checkroom_rounded,
                label: FFLocalizations.of(context)
                    .getText('v9tq8h9e' /* Wardrobe */),
                isActive: false,
                onTap: () => context.pushNamed('MyWardrode'),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.style_rounded,
                label:
                    FFLocalizations.of(context).getText('s0c3e49b' /* Match */),
                isActive: true,
                onTap: () {},
              ),
              _buildNavItem(
                context: context,
                icon: Icons.shopping_bag_rounded,
                label:
                    FFLocalizations.of(context).getText('957557to' /* Shop */),
                isActive: false,
                onTap: () => context.pushNamed('BuyClothes'),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.calendar_month_rounded,
                label: FFLocalizations.of(context)
                    .getText('rccz29xa' /* Calendar */),
                isActive: false,
                onTap: () => context.pushNamed('OutfitPlanner2'),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.person_rounded,
                label: FFLocalizations.of(context)
                    .getText('06sx6hcx' /* Profile */),
                isActive: false,
                onTap: () => context.pushNamed('UserProfile'),
              ),
            ],
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
}
