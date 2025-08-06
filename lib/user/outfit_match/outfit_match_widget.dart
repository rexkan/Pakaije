import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/backend.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pakaije/services/background_removal_service.dart'; // Package import
import 'outfit_match_model.dart';
export 'outfit_match_model.dart';
import 'dart:convert';

class OutfitMatchWidget extends StatefulWidget {
  // Add parameters to accept outfit data
  final String? loadOutfit;
  final String? outfitName;
  final String? topItemId;
  final String? bottomItemId;
  final String? shoesItemId;
  final String? outfitId;
  final String? sizeScales;

  const OutfitMatchWidget({
    super.key,
    this.loadOutfit,
    this.outfitName,
    this.topItemId,
    this.bottomItemId,
    this.shoesItemId,
    this.outfitId,
    this.sizeScales,
  });

  static String routeName = 'OutfitMatch';
  static String routePath = '/outfitMatch';

  @override
  State<OutfitMatchWidget> createState() => _OutfitMatchWidgetState();
}

class _OutfitMatchWidgetState extends State<OutfitMatchWidget> {
  late OutfitMatchModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Body view and outfit state
  String? userBodyImageUrl;
  String? currentUserId;
  List<WardrobeItemsRecord> wardrobeItems = [];
  Map<String, WardrobeItemsRecord?> selectedItems = {
    'Tops': null,
    'Bottoms': null,
    'Shoes': null,
  };
  Map<String, Offset> itemPositions = {
    'Tops': Offset(0.5, 0.25),
    'Bottoms': Offset(0.5, 0.55),
    'Shoes': Offset(0.5, 0.85),
  };
  Map<String, double> itemSizeScales = {
    'Tops': 1.0,
    'Bottoms': 1.0,
    'Shoes': 1.0,
  };
  bool isLoading = true;
  String? errorMessage;
  bool isRealisticView = true;

  // Enhancement tracking
  bool isEnhancing = false;
  int enhancedItemsCount = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OutfitMatchModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // DEBUG: Print all widget parameters
    print('=== OutfitMatchWidget initState Debug ===');
    print('loadOutfit: ${widget.loadOutfit}');
    print('outfitName: ${widget.outfitName}');
    print('topItemId: ${widget.topItemId}');
    print('bottomItemId: ${widget.bottomItemId}');
    print('shoesItemId: ${widget.shoesItemId}');
    print('outfitId: ${widget.outfitId}');
    print('sizeScales: ${widget.sizeScales}');
    print('============================================');

    // Load outfit data if provided, otherwise just load user data
    if (widget.loadOutfit == 'true') {
      print('🔄 Loading outfit data...');
      _loadOutfitData();
    } else {
      print('🔄 Loading user data only...');
      _loadUserData();
    }
  }

  Future<void> _loadOutfitData() async {
    print('=== _loadOutfitData START ===');
    print('loadOutfit: ${widget.loadOutfit}');

    if (widget.loadOutfit == 'true') {
      try {
        setState(() {
          isLoading = true;
          errorMessage = null;
        });

        // Set the outfit name in the text controller
        if (widget.outfitName != null && widget.outfitName!.isNotEmpty) {
          _model.textController?.text = widget.outfitName!;
          print('✅ Set outfit name: ${widget.outfitName}');
        }

        // Load size scales if provided
        if (widget.sizeScales != null && widget.sizeScales!.isNotEmpty) {
          try {
            final scales =
                jsonDecode(widget.sizeScales!) as Map<String, dynamic>;
            setState(() {
              itemSizeScales = {
                'Tops': (scales['Tops'] ?? 1.0).toDouble(),
                'Bottoms': (scales['Bottoms'] ?? 1.0).toDouble(),
                'Shoes': (scales['Shoes'] ?? 1.0).toDouble(),
              };
            });
            print('✅ Size scales loaded: $itemSizeScales');
          } catch (e) {
            print('❌ Error parsing size scales: $e');
          }
        }

        // Load the wardrobe items first
        print('🔄 Loading user wardrobe data...');
        await _loadUserData();
        print(
            '✅ User data loaded. Wardrobe items count: ${wardrobeItems.length}');

        // Then load the specific outfit items
        Map<String, String?> itemIds = {
          'Tops': widget.topItemId,
          'Bottoms': widget.bottomItemId,
          'Shoes': widget.shoesItemId,
        };

        print('🔍 Looking for items with IDs: $itemIds');

        int loadedCount = 0;
        for (String slot in itemIds.keys) {
          String? itemId = itemIds[slot];
          if (itemId != null && itemId.isNotEmpty) {
            print('🔍 Searching for $slot with ID: $itemId');

            // Find the item in the loaded wardrobe
            WardrobeItemsRecord? foundItem;
            try {
              foundItem = wardrobeItems.firstWhere(
                (item) => item.reference.id == itemId,
              );
            } catch (e) {
              print('❌ Item not found in wardrobe for ID: $itemId');
              // Let's also print all available item IDs for debugging
              print('Available item IDs in wardrobe:');
              for (var item in wardrobeItems) {
                print(
                    '  - ${item.reference.id} (${item.name} - ${item.category})');
              }
              foundItem = null;
            }

            if (foundItem != null) {
              setState(() {
                selectedItems[slot] = foundItem;
              });
              loadedCount++;
              print('✅ Loaded $slot: ${foundItem.name} (ID: $itemId)');
            } else {
              print('❌ Could not find item with ID: $itemId for slot: $slot');
            }
          } else {
            print('⚠️ No item ID provided for slot: $slot');
          }
        }

        print(
            '📊 Summary: Loaded $loadedCount out of ${itemIds.length} possible items');

        // Show success message
        if (mounted) {
          if (loadedCount > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Outfit "${widget.outfitName}" loaded! ($loadedCount items)'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Outfit loaded but no items found. Check item IDs.'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        print('❌ Error loading outfit: $e');
        if (mounted) {
          setState(() {
            errorMessage = 'Error loading outfit: $e';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading outfit: $e'),
              backgroundColor: FlutterFlowTheme.of(context).error,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      print('⚠️ loadOutfit is not "true", just loading user data');
      await _loadUserData();
    }

    print('=== _loadOutfitData END ===');
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null || currentUserId!.isEmpty) {
        throw Exception('No authenticated user found. Please log in.');
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final frontBodyUrl = userData['front_body_image_url'] as String?;

        if (frontBodyUrl != null &&
            frontBodyUrl.isNotEmpty &&
            frontBodyUrl.startsWith('https://')) {
          userBodyImageUrl = frontBodyUrl;
          print('✅ Valid body image URL loaded: $userBodyImageUrl');
        } else {
          userBodyImageUrl = null;
          print('❌ No valid body image found. URL: $frontBodyUrl');
        }
      } else {
        throw Exception('User profile not found');
      }

      final wardrobeQuery = await FirebaseFirestore.instance
          .collection('wardrobe_items')
          .where('user_id', isEqualTo: currentUserId)
          .get();

      wardrobeItems = wardrobeQuery.docs
          .map((doc) => WardrobeItemsRecord.fromSnapshot(doc))
          .toList();

      print('📊 Loaded ${wardrobeItems.length} wardrobe items for user');

      // Count enhanced items
      int enhancedCount = 0;
      for (var item in wardrobeItems) {
        final itemDoc = await FirebaseFirestore.instance
            .collection('wardrobe_items')
            .doc(item.reference.id)
            .get();

        if (itemDoc.exists) {
          final data = itemDoc.data();
          final hasTransparentBg =
              data?['has_transparent_bg'] as bool? ?? false;
          if (hasTransparentBg) enhancedCount++;
        }
      }

      setState(() {
        isLoading = false;
        enhancedItemsCount = enhancedCount;
      });

      print('✨ $enhancedCount items have transparent backgrounds');
    } catch (e) {
      print('❌ Error loading user data: $e');
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  List<WardrobeItemsRecord> _getItemsByCategory(String category) {
    return wardrobeItems
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  void _handleItemDrop(String slot, WardrobeItemsRecord item, Offset position) {
    setState(() {
      selectedItems[slot] = item;
      itemPositions[slot] = position;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.category} added to outfit!'),
        duration: Duration(seconds: 1),
        backgroundColor: FlutterFlowTheme.of(context).underground,
      ),
    );
  }

  void _removeItem(String slot) {
    setState(() {
      selectedItems[slot] = null;
      itemSizeScales[slot] = 1.0; // Reset size scale for this item
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$slot removed from outfit'),
        duration: Duration(seconds: 1),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ),
    );
  }

  void _navigateToProfile() {
    context.pushNamed('UserProfile');
  }

  // Enhancement functionality
  void _enhanceWardrobe() async {
    // Show confirmation dialog first
    bool shouldProceed = await _showEnhanceConfirmation();
    if (!shouldProceed) return;

    setState(() {
      isEnhancing = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Enhancing wardrobe items...'),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );

    try {
      int processedCount = 0;
      int totalToProcess = 0;

      // Count items that need processing
      for (var item in wardrobeItems) {
        final itemDoc = await FirebaseFirestore.instance
            .collection('wardrobe_items')
            .doc(item.reference.id)
            .get();

        final data = itemDoc.data();
        final hasTransparentBg = data?['has_transparent_bg'] as bool? ?? false;

        if (!hasTransparentBg && item.imageUrl.isNotEmpty) {
          totalToProcess++;
        }
      }

      if (totalToProcess == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All items are already enhanced!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          isEnhancing = false;
        });
        return;
      }

      for (var item in wardrobeItems) {
        // Check if item already has transparent background
        final itemDoc = await FirebaseFirestore.instance
            .collection('wardrobe_items')
            .doc(item.reference.id)
            .get();

        final data = itemDoc.data();
        final hasTransparentBg = data?['has_transparent_bg'] as bool? ?? false;

        if (!hasTransparentBg && item.imageUrl.isNotEmpty) {
          print(
              '🔄 Processing item ${processedCount + 1}/$totalToProcess: ${item.reference.id}');

          final processedUrl =
              await BackgroundRemovalService.removeBackgroundFromUrl(
                  item.imageUrl);

          if (processedUrl != null) {
            // Delete the original image from Firebase Storage first
            try {
              if (item.imageUrl.contains('firebase')) {
                // Extract the file path from the original URL
                final ref = FirebaseStorage.instance.refFromURL(item.imageUrl);
                await ref.delete();
                print('🗑️ Deleted original image: ${item.imageUrl}');
              }
            } catch (e) {
              print('⚠️ Could not delete original image: $e');
              // Continue anyway - we still want to update with the enhanced image
            }

            // Update the document - replace original imageUrl with enhanced image
            await FirebaseFirestore.instance
                .collection('wardrobe_items')
                .doc(item.reference.id)
                .update({
              'image_url': processedUrl, // Replace original image URL
              'original_image_url':
                  item.imageUrl, // Keep backup of original URL
              'has_transparent_bg': true,
              'processing_status': 'completed',
              'updated_time': FieldValue.serverTimestamp(),
            });

            processedCount++;
            print(
                '✅ Successfully processed and replaced image for item: ${item.reference.id}');
          } else {
            // Mark as failed
            await FirebaseFirestore.instance
                .collection('wardrobe_items')
                .doc(item.reference.id)
                .update({
              'processing_status': 'failed',
              'updated_time': FieldValue.serverTimestamp(),
            });
            print('❌ Failed to process item: ${item.reference.id}');
          }

          // Rate limiting - wait 1 second between requests
          await Future.delayed(Duration(seconds: 1));
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enhanced $processedCount/$totalToProcess items!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'View',
            textColor: Colors.white,
            onPressed: () {
              // Scroll to wardrobe section or refresh
            },
          ),
        ),
      );

      // Reload data to show updated items
      await _loadUserData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enhancement failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isEnhancing = false;
      });
    }
  }

  Future<bool> _showEnhanceConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Enhance Wardrobe'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'This will remove backgrounds from your clothing items for realistic virtual try-on.'),
                  SizedBox(height: 12),
                  Text('• Uses Remove.bg API (50 free calls/month)',
                      style: TextStyle(fontSize: 12)),
                  Text('• Takes 1-2 minutes per item',
                      style: TextStyle(fontSize: 12)),
                  Text('• Will replace original images with enhanced versions',
                      style: TextStyle(fontSize: 12, color: Colors.orange)),
                  Text('• Original images will be permanently deleted',
                      style: TextStyle(fontSize: 12, color: Colors.red)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Enhance'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  // Build enhancement button
  Widget _buildEnhanceButton() {
    final nonEnhancedCount = wardrobeItems.length - enhancedItemsCount;

    if (nonEnhancedCount == 0) {
      return SizedBox.shrink(); // Hide if all items are enhanced
    }

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 0.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).accent1,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.auto_fix_high,
              color: FlutterFlowTheme.of(context).primary,
              size: 20.0,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enhance Your Wardrobe',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                  ),
                  Text(
                    '$nonEnhancedCount items can be enhanced for realistic try-on',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ],
              ),
            ),
            FFButtonWidget(
              onPressed: isEnhancing ? null : _enhanceWardrobe,
              text: isEnhancing ? 'Processing...' : 'Enhance',
              options: FFButtonOptions(
                width: 100.0,
                height: 32.0,
                color: isEnhancing
                    ? Colors.grey
                    : FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                borderRadius: BorderRadius.circular(6.0),
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
          actions: [
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
                size: 24.0,
              ),
              onPressed: _loadUserData,
            ),
          ],
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
                      if (errorMessage != null)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsetsDirectional.fromSTEB(
                              16.0, 20.0, 16.0, 0.0),
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .error
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: FlutterFlowTheme.of(context).error,
                                size: 32.0,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Error loading data',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontWeight: FontWeight.w600,
                                      color: FlutterFlowTheme.of(context).error,
                                    ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                errorMessage!,
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12.0),
                              FFButtonWidget(
                                onPressed: _loadUserData,
                                text: 'Retry',
                                options: FFButtonOptions(
                                  width: 100.0,
                                  height: 35.0,
                                  color: FlutterFlowTheme.of(context).error,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                      ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Header Section
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 20.0, 16.0, 0.0),
                        child: Column(
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
                      ),

                      // Enhancement Button - Add this after the header
                      if (!isLoading && wardrobeItems.isNotEmpty)
                        _buildEnhanceButton(),

                      // Outfit Name Input
                      Container(
                        width: double.infinity,
                        margin: EdgeInsetsDirectional.fromSTEB(
                            16.0, 20.0, 16.0, 0.0),
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

                      // Enhanced Virtual Try-On Section
                      Container(
                        width: double.infinity,
                        margin: EdgeInsetsDirectional.fromSTEB(
                            16.0, 20.0, 16.0, 0.0),
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
                                      // View mode toggle - Enhanced design
                                      Container(
                                        height: 36,
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate
                                              .withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate
                                                .withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isRealisticView = true;
                                                });
                                              },
                                              child: AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 200),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: isRealisticView
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  boxShadow: isRealisticView
                                                      ? [
                                                          BoxShadow(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary
                                                                .withOpacity(
                                                                    0.3),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ]
                                                      : [],
                                                ),
                                                child: Text(
                                                  'Realistic',
                                                  style: TextStyle(
                                                    color: isRealisticView
                                                        ? Colors.white
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 2),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isRealisticView = false;
                                                });
                                              },
                                              child: AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 200),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: !isRealisticView
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  boxShadow: !isRealisticView
                                                      ? [
                                                          BoxShadow(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary
                                                                .withOpacity(
                                                                    0.3),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ]
                                                      : [],
                                                ),
                                                child: Text(
                                                  'Thumb',
                                                  style: TextStyle(
                                                    color: !isRealisticView
                                                        ? Colors.white
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 10.0,
                                        buttonSize: 40.0,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .error
                                            .withOpacity(0.1),
                                        icon: Icon(
                                          Icons.clear_all_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          size: 20.0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            selectedItems = {
                                              'Tops': null,
                                              'Bottoms': null,
                                              'Shoes': null,
                                            };
                                            itemSizeScales = {
                                              'Tops': 1.0,
                                              'Bottoms': 1.0,
                                              'Shoes': 1.0,
                                            };
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text('Outfit cleared'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Enhanced Virtual Try-On Body View
                            Container(
                              width: double.infinity,
                              height: 400.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 16.0),
                              child: Stack(
                                children: [
                                  // Background body image
                                  _buildEnhancedBodyBackground(),

                                  // Enhanced drag target zones
                                  ..._buildEnhancedDragTargets(400.0),

                                  // Enhanced positioned items
                                  ...(isRealisticView
                                      ? _buildRealisticPositionedItems(400.0)
                                      : _buildThumbnailPositionedItems(400.0)),

                                  // Size control overlay (changed from lighting control)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Size Controls Section - New separate section
                      if (!isLoading &&
                          isRealisticView &&
                          userBodyImageUrl != null &&
                          selectedItems.values.any((item) => item != null))
                        Container(
                          width: double.infinity,
                          margin: EdgeInsetsDirectional.fromSTEB(
                              16.0, 20.0, 16.0, 0.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x0F000000),
                                offset: Offset(0.0, 2.0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.tune_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Adjust Size',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLargeFamily,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          itemSizeScales = {
                                            'Tops': 1.0,
                                            'Bottoms': 1.0,
                                            'Shoes': 1.0,
                                          };
                                        });
                                      },
                                      child: Text(
                                        'Reset All',
                                        style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                ...selectedItems.entries
                                    .where((entry) => entry.value != null)
                                    .map((entry) =>
                                        _buildIndividualSizeControl(entry.key)),
                              ],
                            ),
                          ),
                        ),

                      // Wardrobe Items Section
                      if (!isLoading) ...[
                        Container(
                          width: double.infinity,
                          margin: EdgeInsetsDirectional.fromSTEB(
                              16.0, 20.0, 16.0, 0.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
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
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                    Spacer(),
                                    // Enhancement status indicator
                                    if (enhancedItemsCount > 0)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.green, width: 1),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.auto_fix_high,
                                                size: 12, color: Colors.green),
                                            SizedBox(width: 4),
                                            Text(
                                              '$enhancedItemsCount Enhanced',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              _buildHorizontalCategorySection(
                                  'Tops', _getItemsByCategory('Tops')),
                              SizedBox(height: 16.0),
                              _buildHorizontalCategorySection(
                                  'Bottoms', _getItemsByCategory('Bottoms')),
                              SizedBox(height: 16.0),
                              _buildHorizontalCategorySection(
                                  'Shoes', _getItemsByCategory('Shoes')),
                              SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      ] else
                        Container(
                          width: double.infinity,
                          margin: EdgeInsetsDirectional.fromSTEB(
                              16.0, 20.0, 16.0, 0.0),
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 40.0, 16.0, 40.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Loading your wardrobe...',
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Action Buttons
                      Container(
                        width: double.infinity,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 30.0, 16.0, 0.0),
                        child: Center(
                          child: FFButtonWidget(
                            onPressed: _saveOutfit,
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

  // Enhanced body background (removed lighting effects)
  Widget _buildEnhancedBodyBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: userBodyImageUrl != null && userBodyImageUrl!.isNotEmpty
            ? Image.network(
                userBodyImageUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildPlaceholderBody(showLoading: true);
                },
                errorBuilder: (context, error, stackTrace) {
                  print('❌ Error loading body image: $error');
                  return _buildPlaceholderBody(showError: true);
                },
              )
            : _buildPlaceholderBody(),
      ),
    );
  }

  // Enhanced drag target zones - FIXED VERSION
  List<Widget> _buildEnhancedDragTargets(double containerHeight) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth - 64;

    return [
      // Tops zone - FIXED to accept 'tops' with correct comparison
      Positioned(
        left: containerWidth * 0.18,
        right: containerWidth * 0.18,
        top: containerHeight * 0.12,
        height: containerHeight * 0.38,
        child: DragTarget<Map<String, dynamic>>(
          onAccept: (data) {
            if (data['item'] is WardrobeItemsRecord) {
              final item = data['item'] as WardrobeItemsRecord;
              // Fixed: Handle case-insensitive category comparison
              if (item.category.toLowerCase() == 'tops') {
                _handleItemDrop('Tops', item, Offset(0.5, 0.25));
              } else {
                print('❌ Wrong category for Tops slot: ${item.category}');
              }
            }
          },
          builder: (context, candidateData, rejectedData) {
            final bool isDragging = candidateData.isNotEmpty;
            final bool isEmpty = selectedItems['Tops'] == null;

            // Validate that dragged item is correct category
            bool isValidDrop = false;
            if (candidateData.isNotEmpty) {
              final data = candidateData.first as Map<String, dynamic>;
              if (data['item'] is WardrobeItemsRecord) {
                final item = data['item'] as WardrobeItemsRecord;
                isValidDrop = item.category.toLowerCase() == 'tops';
              }
            }

            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isDragging
                    ? (isValidDrop
                        ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: isDragging
                    ? Border.all(
                        color: isValidDrop
                            ? FlutterFlowTheme.of(context).primary
                            : Colors.red,
                        width: 2,
                      )
                    : isEmpty
                        ? Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                            style: BorderStyle.solid,
                          )
                        : null,
              ),
              child: isDragging
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (isValidDrop
                                      ? FlutterFlowTheme.of(context).primary
                                      : Colors.red)
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isValidDrop
                                  ? Icons.add_rounded
                                  : Icons.close_rounded,
                              color: isValidDrop
                                  ? FlutterFlowTheme.of(context).primary
                                  : Colors.red,
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            isValidDrop ? 'Drop Top Here' : 'Wrong Item Type',
                            style: TextStyle(
                              color: isValidDrop
                                  ? FlutterFlowTheme.of(context).primary
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : isEmpty
                      ? Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'TOP',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        )
                      : null,
            );
          },
        ),
      ),

      // Bottoms zone - already correct
      Positioned(
        left: containerWidth * 0.22,
        right: containerWidth * 0.22,
        top: containerHeight * 0.40,
        height: containerHeight * 0.42,
        child: DragTarget<Map<String, dynamic>>(
          onAccept: (data) {
            if (data['item'] is WardrobeItemsRecord &&
                data['item'].category.toLowerCase() == 'bottoms') {
              _handleItemDrop('Bottoms', data['item'], Offset(0.5, 0.55));
            }
          },
          builder: (context, candidateData, rejectedData) {
            final bool isDragging = candidateData.isNotEmpty;
            final bool isEmpty = selectedItems['Bottoms'] == null;

            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isDragging
                    ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: isDragging
                    ? Border.all(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      )
                    : isEmpty
                        ? Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                            style: BorderStyle.solid,
                          )
                        : null,
              ),
              child: isDragging
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Drop Bottom Here',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : isEmpty
                      ? Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'BOTTOM',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        )
                      : null,
            );
          },
        ),
      ),

      // Shoes zone - already correct
      Positioned(
        left: containerWidth * 0.28,
        right: containerWidth * 0.28,
        bottom: containerHeight * 0.05,
        height: containerHeight * 0.18,
        child: DragTarget<Map<String, dynamic>>(
          onAccept: (data) {
            if (data['item'] is WardrobeItemsRecord &&
                data['item'].category.toLowerCase() == 'shoes') {
              _handleItemDrop('Shoes', data['item'], Offset(0.5, 0.85));
            }
          },
          builder: (context, candidateData, rejectedData) {
            final bool isDragging = candidateData.isNotEmpty;
            final bool isEmpty = selectedItems['Shoes'] == null;

            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isDragging
                    ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: isDragging
                    ? Border.all(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      )
                    : isEmpty
                        ? Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                            style: BorderStyle.solid,
                          )
                        : null,
              ),
              child: isDragging
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 24,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Drop Shoes Here',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : isEmpty
                      ? Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'SHOES',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        )
                      : null,
            );
          },
        ),
      ),
    ];
  }

  // Enhanced realistic positioned items with background removal support
  List<Widget> _buildRealisticPositionedItems(double containerHeight) {
    List<Widget> positioned = [];
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth - 64;

    Map<String, Map<String, dynamic>> enhancedSpecs = {
      'Tops': {
        'width': containerWidth * 0.50 * itemSizeScales['Tops']!,
        'height': containerHeight * 0.40 * itemSizeScales['Tops']!,
        'topOffset': containerHeight * 0.12,
        'leftOffset': containerWidth * 0.25,
        'shadowIntensity': 0.3,
        'perspective': 0.02,
      },
      'Bottoms': {
        'width': containerWidth * 0.44 * itemSizeScales['Bottoms']!,
        'height': containerHeight * 0.45 * itemSizeScales['Bottoms']!,
        'topOffset': containerHeight * 0.40,
        'leftOffset': containerWidth * 0.28,
        'shadowIntensity': 0.25,
        'perspective': 0.015,
      },
      'Shoes': {
        'width': containerWidth * 0.30 * itemSizeScales['Shoes']!,
        'height': containerHeight * 0.20 * itemSizeScales['Shoes']!,
        'topOffset': containerHeight * 0.75,
        'leftOffset': containerWidth * 0.35,
        'shadowIntensity': 0.4,
        'perspective': 0.01,
      },
    };

    List<String> layerOrder = ['Bottoms', 'Tops', 'Shoes'];

    for (String slot in layerOrder) {
      WardrobeItemsRecord? item = selectedItems[slot];
      if (item != null) {
        final specs = enhancedSpecs[slot]!;

        // Adjust position to center items when they're scaled
        double adjustedLeft = specs['leftOffset'] +
            ((containerWidth * _getBaseWidth(slot) - specs['width']) / 2);
        double adjustedTop = specs['topOffset'] +
            ((containerHeight * _getBaseHeight(slot) - specs['height']) / 2);

        positioned.add(
          Positioned(
            left: adjustedLeft,
            top: adjustedTop,
            child: Container(
              width: specs['width'],
              height: specs['height'],
              child: _buildEnhancedClothingItem(item, specs, slot),
            ),
          ),
        );
      }
    }

    return positioned;
  }

  // Enhanced clothing item with background removal support
  Widget _buildEnhancedClothingItem(
      WardrobeItemsRecord item, Map<String, dynamic> specs, String slot) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('wardrobe_items')
          .doc(item.reference.id)
          .get(),
      builder: (context, snapshot) {
        String imageUrl = item.imageUrl;
        bool hasTransparentBg = false;
        String processingStatus = 'none';

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final processedUrl = data['processed_image_url'] as String?;
          hasTransparentBg = data['has_transparent_bg'] as bool? ?? false;
          processingStatus = data['processing_status'] as String? ?? 'none';
        }

        return Stack(
          children: [
            // Main clothing item
            Container(
              width: specs['width'],
              height: specs['height'],
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(specs['perspective'])
                    ..scale(1.0, 1.0 + specs['perspective']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: hasTransparentBg ? null : Colors.white,
                    ),
                    child: Image.network(
                      imageUrl,
                      width: specs['width'],
                      height: specs['height'],
                      fit: hasTransparentBg ? BoxFit.contain : BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildErrorPlaceholder(specs);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: specs['width'],
                          height: specs['height'],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Enhancement indicator
            if (hasTransparentBg)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_fix_high, size: 10, color: Colors.white),
                      SizedBox(width: 2),
                      Text(
                        'Enhanced',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Remove button
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeItem(slot),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: FlutterFlowTheme.of(context).error,
                  ),
                ),
              ),
            ),

            // Category label - improved design
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    slot.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper method to get base width ratios
  double _getBaseWidth(String slot) {
    switch (slot) {
      case 'Tops':
        return 0.50;
      case 'Bottoms':
        return 0.44;
      case 'Shoes':
        return 0.30;
      default:
        return 0.50;
    }
  }

  // Helper method to get base height ratios
  double _getBaseHeight(String slot) {
    switch (slot) {
      case 'Tops':
        return 0.40;
      case 'Bottoms':
        return 0.45;
      case 'Shoes':
        return 0.20;
      default:
        return 0.40;
    }
  }

  // Size control overlay - Individual controls for each item
  Widget _buildSizeControls() {
    List<String> activeSlots = [];
    selectedItems.forEach((slot, item) {
      if (item != null) activeSlots.add(slot);
    });

    if (activeSlots.isEmpty) return SizedBox.shrink();

    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 18,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Adjust Size',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyLargeFamily,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                      ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    setState(() {
                      itemSizeScales = {
                        'Tops': 1.0,
                        'Bottoms': 1.0,
                        'Shoes': 1.0,
                      };
                    });
                  },
                  child: Text(
                    'Reset All',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...activeSlots.map((slot) => _buildIndividualSizeControl(slot)),
          ],
        ),
      ),
    );
  }

  Widget _buildIndividualSizeControl(String slot) {
    IconData getIconForSlot(String slot) {
      switch (slot) {
        case 'Tops':
          return Icons.checkroom;
        case 'Bottoms':
          return Icons.straighten;
        case 'Shoes':
          return Icons.directions_walk;
        default:
          return Icons.category;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                getIconForSlot(slot),
                size: 16,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              SizedBox(width: 8),
              Text(
                slot,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                      fontWeight: FontWeight.w500,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(itemSizeScales[slot]! * 100).round()}%',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              activeTrackColor: FlutterFlowTheme.of(context).primary,
              inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
              thumbColor: FlutterFlowTheme.of(context).primary,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
              overlayColor:
                  FlutterFlowTheme.of(context).primary.withOpacity(0.1),
            ),
            child: Slider(
              value: itemSizeScales[slot]!,
              onChanged: (value) {
                setState(() {
                  itemSizeScales[slot] = value;
                });
              },
              min: 0.5,
              max: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder(Map<String, dynamic> specs) {
    return Container(
      width: specs['width'],
      height: specs['height'],
      color: FlutterFlowTheme.of(context).accent3.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: specs['width'] * 0.2,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          SizedBox(height: 8),
          Text(
            'Failed to load',
            style: TextStyle(
              fontSize: 12,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // Build thumbnail positioned items (original small image style)
  List<Widget> _buildThumbnailPositionedItems(double containerHeight) {
    List<Widget> positioned = [];

    selectedItems.forEach((slot, item) {
      if (item != null) {
        final position = itemPositions[slot]!;
        final itemSize =
            60.0 * itemSizeScales[slot]!; // Apply individual size scale

        positioned.add(
          Positioned(
            left: (MediaQuery.of(context).size.width * 0.5) - (itemSize / 2),
            top: (position.dy * containerHeight) - (itemSize / 2),
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
                  // Remove button
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => _removeItem(slot),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).error,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });

    return positioned;
  }

  Widget _buildPlaceholderBody(
      {bool showLoading = false, bool showError = false}) {
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
          if (showLoading) ...[
            CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary,
            ),
            SizedBox(height: 16),
            Text(
              'Loading your body view...',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ] else if (showError) ...[
            Icon(
              Icons.error_outline,
              size: 60.0,
              color: FlutterFlowTheme.of(context).error,
            ),
            SizedBox(height: 16),
            Text(
              'Failed to load body image',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).error,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8),
            FFButtonWidget(
              onPressed: _loadUserData,
              text: 'Retry',
              options: FFButtonOptions(
                width: 80.0,
                height: 32.0,
                color: FlutterFlowTheme.of(context).error,
                textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ] else ...[
            Icon(
              Icons.person_outline,
              size: 80.0,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            SizedBox(height: 16),
            Text(
              'No body image uploaded',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              'Upload your body image in Profile\nfor realistic virtual try-on',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
            ),
            SizedBox(height: 12),
            FFButtonWidget(
              onPressed: _navigateToProfile,
              text: 'Go to Profile',
              icon: Icon(
                Icons.person,
                size: 16.0,
              ),
              options: FFButtonOptions(
                width: 120.0,
                height: 36.0,
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ],
      ),
    );
  }

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
            height: 100.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: _buildDraggableItem(item, title),
                );
              },
            ),
          ),
      ],
    );
  }

  // Enhanced draggable item with enhancement indicator
  Widget _buildDraggableItem(WardrobeItemsRecord item, String title) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('wardrobe_items')
          .doc(item.reference.id)
          .get(),
      builder: (context, snapshot) {
        bool hasTransparentBg = false;
        String processingStatus = 'none';

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          hasTransparentBg = data['has_transparent_bg'] as bool? ?? false;
          processingStatus = data['processing_status'] as String? ?? 'none';
        }

        return Draggable<Map<String, dynamic>>(
          data: {'item': item, 'category': title.toLowerCase()},
          feedback: Material(
            child: Container(
              width: isRealisticView ? 100.0 : 70.0,
              height: isRealisticView ? 120.0 : 70.0,
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
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          childWhenDragging: Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).accent4.withOpacity(0.5),
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
                color: hasTransparentBg
                    ? Colors.green.withOpacity(0.5)
                    : FlutterFlowTheme.of(context).alternate,
                width: hasTransparentBg ? 3.0 : 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2.0,
                  color: Color(0x0F000000),
                  offset: Offset(0.0, 1.0),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: FlutterFlowTheme.of(context).accent3,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 24.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      );
                    },
                  ),
                ),

                // Enhancement indicator
                if (hasTransparentBg)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.auto_fix_high,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),

                // Processing status indicator
                if (processingStatus == 'failed')
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveOutfit() async {
    if (_model.textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter an outfit name'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    if (selectedItems.values.every((item) => item == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one item to your outfit'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please log in to save outfits'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Text('Saving outfit...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      await FirebaseFirestore.instance.collection('outfits').add({
        'user_id': currentUserId,
        'name': _model.textController.text.trim(),
        'top_item_id': selectedItems['Tops']?.reference.id,
        'bottom_item_id': selectedItems['Bottoms']?.reference.id,
        'shoes_item_id': selectedItems['Shoes']?.reference.id,
        'created_time': FieldValue.serverTimestamp(),
        'is_suggested': false,
        'item_size_scales': {
          'Tops': itemSizeScales['Tops'],
          'Bottoms': itemSizeScales['Bottoms'],
          'Shoes': itemSizeScales['Shoes'],
        }, // Save individual size scale settings
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Outfit "${_model.textController.text.trim()}" saved successfully!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'View',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );

      _model.textController?.clear();
      setState(() {
        selectedItems = {
          'Tops': null,
          'Bottoms': null,
          'Shoes': null,
        };
        itemSizeScales = {
          'Tops': 1.0,
          'Bottoms': 1.0,
          'Shoes': 1.0,
        }; // Reset individual size scales
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving outfit: $e'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

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
