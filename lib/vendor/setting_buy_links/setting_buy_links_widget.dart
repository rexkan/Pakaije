import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'setting_buy_links_model.dart';
export 'setting_buy_links_model.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';

// ================================================================================
// SECTION 1: MAIN WIDGET CLASS DECLARATION
// ================================================================================
// 🔴 CORE COMPONENT - This is the main widget class structure
// PURPOSE: Defines the main StatefulWidget for the buy links management page
// REMOVAL IMPACT: Cannot remove - this is the core widget structure
// COMPONENTS: StatefulWidget class, route names, and state creation
// ================================================================================

class SettingBuyLinksWidget extends StatefulWidget {
  const SettingBuyLinksWidget({super.key});

  static String routeName = 'SettingBuyLinks';
  static String routePath = '/settingBuyLinks';

  @override
  State<SettingBuyLinksWidget> createState() => _SettingBuyLinksWidgetState();
}

// ================================================================================
// SECTION 2: STATE CLASS AND INITIALIZATION
// ================================================================================
// 🔴 CORE COMPONENT - Contains essential state management and animations
// PURPOSE: Manages page state, animations, and widget lifecycle
// REMOVAL IMPACT: Cannot remove - required for page functionality
// COMPONENTS: State class, model initialization, animations setup, dispose method
// ================================================================================

class _SettingBuyLinksWidgetState extends State<SettingBuyLinksWidget>
    with TickerProviderStateMixin {
  late SettingBuyLinksModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingBuyLinksModel());

    // Page Load Animations Setup
    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 50.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 50.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 50.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

// ================================================================================
// SECTION 3: DELETE CONFIRMATION DIALOG
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Modal dialog for confirming product deletion
// PURPOSE: Shows warning dialog before deleting a product
// REMOVAL IMPACT: Can be removed - will disable delete confirmation safety
// COMPONENTS: AlertDialog with warning icon, product name, confirmation text, action buttons
// ================================================================================

  void _showDeleteConfirmation(BrandedItemsRecord product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Dialog Header with Warning Icon
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: FlutterFlowTheme.of(context).error,
                size: 28.0,
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Delete Product',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Inter Tight',
                        color: FlutterFlowTheme.of(context).error,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),

          // Dialog Content with Warning Message
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete "${product.name}"?',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 12.0),
              Text(
                'This action cannot be undone. The product will be permanently removed from your inventory.',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),

          // Dialog Action Buttons
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              ),
              child: Text(
                'Cancel',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteProduct(product);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).error,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  SizedBox(width: 6.0),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

// ================================================================================
// SECTION 4: DELETE PRODUCT METHOD
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Firebase deletion logic with loading states
// PURPOSE: Handles the actual deletion of products from Firebase with UI feedback
// REMOVAL IMPACT: Required if delete functionality is kept
// COMPONENTS: Loading dialog, Firebase delete operation, success/error snackbars
// ================================================================================

  Future<void> _deleteProduct(BrandedItemsRecord product) async {
    try {
      // Show Loading Indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Deleting product...',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Delete from Firebase
      await product.reference.delete();

      // Close loading dialog
      Navigator.of(context).pop();

      // Success Feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20.0,
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  '${product.name} has been deleted successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );
    } catch (e) {
      // Close loading dialog if open
      Navigator.of(context).pop();

      // Error Feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
                size: 20.0,
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  'Error deleting product: ${e.toString()}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );
    }
  }

// ================================================================================
// SECTION 5: MAIN BUILD METHOD
// ================================================================================
// 🔴 CORE COMPONENT - Main page layout structure
// PURPOSE: Builds the main scaffold and page structure
// REMOVAL IMPACT: Cannot remove - this is the core page structure
// COMPONENTS: Scaffold with AppBar, Body sections, and Bottom Navigation
// ================================================================================

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

        // ========================================================================
        // SUB-SECTION 5A: APP BAR
        // ========================================================================
        // 🟡 MEDIUM COMPLEXITY - Top navigation bar with back button and title
        // PURPOSE: Provides page title and back navigation
        // REMOVAL IMPACT: Can be simplified but header is recommended
        // ========================================================================

        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).underground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 8.0,
            buttonSize: 40.0,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Setting Buy Links',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  color: Colors.white,
                  fontSize: 24.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),

        // ========================================================================
        // SUB-SECTION 5B: BODY LAYOUT
        // ========================================================================
        // 🔴 CORE COMPONENT - Main content area layout
        // PURPOSE: Contains all page content in scrollable format
        // REMOVAL IMPACT: Cannot remove - essential for content display
        // ========================================================================

        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Header Section
                      _buildPageHeader(),

                      SizedBox(height: 24.0),

                      // Products List Section
                      _buildProductsList(),

                      SizedBox(height: 80.0), // Space for bottom navigation
                    ],
                  ),
                ),
              ),

              // Bottom Navigation Section
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

// ================================================================================
// SECTION 6: PAGE HEADER SECTION
// ================================================================================
// 🟢 EASY TO REMOVE - Page title and description text
// PURPOSE: Displays page title and instruction text for users
// REMOVAL IMPACT: Can be completely removed - just removes descriptive text
// COMPONENTS: Title text, description text
// ================================================================================

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Lists',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: GoogleFonts.interTight().fontFamily,
                fontSize: 24.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8.0),
        Text(
          'Update buy links for your products to redirect customers to your store',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: GoogleFonts.inter().fontFamily,
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }

// ================================================================================
// SECTION 7: PRODUCTS LIST SECTION
// ================================================================================
// 🔴 CORE COMPONENT - Main functionality displaying products from Firebase
// PURPOSE: Shows list of products with buy link management capabilities
// REMOVAL IMPACT: Major impact - this is the main functionality
// COMPONENTS: StreamBuilder, Firebase query, product grid, empty state, loading state
// ================================================================================

  Widget _buildProductsList() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;

        return StreamBuilder<List<BrandedItemsRecord>>(
          stream: queryBrandedItemsRecord(
            queryBuilder: (brandedItemsRecord) => brandedItemsRecord
                .where('vendor_id', isEqualTo: currentUserUid),
          ),
          builder: (context, snapshot) {
            // Loading State
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
              );
            }

            // Enhanced Client-side Filtering with Debugging
            List<BrandedItemsRecord> allProducts = snapshot.data ?? [];

            // Debug: Print all products to see what's coming from Firebase
            print('Total products from Firebase: ${allProducts.length}');
            for (var product in allProducts) {
              print(
                  'Product: ${product.name}, Status: ${product.status}, VendorID: ${product.vendorId}');
            }

            List<BrandedItemsRecord> products = allProducts.where((product) {
              bool hasValidStatus = product.status != 'removed_for_violation' &&
                  product.status != 'deleted';
              bool notRemoved = product.removedAt == null;
              bool belongsToUser = product.vendorId == currentUserUid;

              return hasValidStatus && notRemoved && belongsToUser;
            }).toList();

            // Sort by date manually with null safety
            products.sort((a, b) {
              DateTime dateA = a.dateAdded ?? DateTime.now();
              DateTime dateB = b.dateAdded ?? DateTime.now();
              return dateB.compareTo(dateA);
            });

            print('Filtered products count: ${products.length}');

            // Empty State
            if (products.isEmpty) {
              return _buildEmptyState(allProducts);
            }

            // Products Grid
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: crossAxisCount == 2 ? 0.9 : 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(
                  product.name,
                  product.productUrl,
                  animationsMap[
                      'containerOnPageLoadAnimation${(index % 3) + 1}']!,
                  product: product,
                );
              },
            );
          },
        );
      },
    );
  }

// ================================================================================
// SECTION 8: EMPTY STATE WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Empty state display when no products exist
// PURPOSE: Shows helpful message and action button when no products are found
// REMOVAL IMPACT: Can be removed - will show blank space instead of helpful message
// COMPONENTS: Container with icon, text, debug info, and "Add Product" button
// ================================================================================

  Widget _buildEmptyState(List<BrandedItemsRecord> allProducts) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 60.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty State Icon
          Icon(
            Icons.link_off,
            size: 80.0,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          SizedBox(height: 24.0),

          // Empty State Title
          Text(
            'No active products found',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Inter Tight',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 12.0),

          // Empty State Description
          Text(
            'Add products to manage their buy links',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            textAlign: TextAlign.center,
          ),

          // Debug Information (for troubleshooting)
          if (allProducts.isNotEmpty) ...[
            SizedBox(height: 16.0),
            Text(
              'Debug: Found ${allProducts.length} total products but 0 match filters',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Inter',
                    color: Colors.orange,
                    letterSpacing: 0.0,
                  ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Current User ID: ${currentUserUid ?? "null"}',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Inter',
                    color: Colors.orange,
                    letterSpacing: 0.0,
                  ),
              textAlign: TextAlign.center,
            ),
          ],

          SizedBox(height: 32.0),

          // Add Product Button
          FFButtonWidget(
            onPressed: () => context.pushNamed(AddProductWidget.routeName),
            text: 'Add Your First Product',
            icon: Icon(
              Icons.add_circle_outline,
              size: 20.0,
            ),
            options: FFButtonOptions(
              height: 48.0,
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter Tight',
                    color: Colors.white,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
              elevation: 2.0,
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ],
      ),
    );
  }

// ================================================================================
// SECTION 9: PRODUCT CARD WIDGET
// ================================================================================
// 🔴 CORE COMPONENT - Individual product display card with management options
// PURPOSE: Displays individual product information and buy link management
// REMOVAL IMPACT: Major impact - essential for product management
// COMPONENTS: Card container, product image, info display, delete button, update link button
// ================================================================================

  Widget _buildProductCard(
    String productName,
    String currentLink,
    AnimationInfo animation, {
    BrandedItemsRecord? product,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Product Name and Delete Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    productName,
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Delete Button
                GestureDetector(
                  onTap: () {
                    if (product != null) {
                      _showDeleteConfirmation(product);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color:
                          FlutterFlowTheme.of(context).error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color:
                            FlutterFlowTheme.of(context).error.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: FlutterFlowTheme.of(context).error,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.0),

            // Product Image Section
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: product?.imageUrl.isNotEmpty == true
                      ? Image.network(
                          product!.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: FlutterFlowTheme.of(context).alternate,
                              child: Icon(
                                Icons.image_not_supported,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 48.0,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: FlutterFlowTheme.of(context).alternate,
                          child: Icon(
                            Icons.image,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 48.0,
                          ),
                        ),
                ),
              ),
            ),

            SizedBox(height: 12.0),

            // Product Information Section
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Category
                  if (product != null)
                    Text(
                      product.category,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),

                  SizedBox(height: 6.0),

                  // Item ID Display
                  if (product != null && product.itemId.isNotEmpty)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        'ID: ${product.itemId}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),

                  SizedBox(height: 6.0),

                  // Current Link Label
                  Text(
                    'Current Link:',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontSize: 12.0,
                        ),
                  ),

                  SizedBox(height: 2.0),

                  // Current Link Display
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: 40.0),
                      child: Text(
                        currentLink.isEmpty ? 'No link set' : currentLink,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                              color: currentLink.isEmpty
                                  ? FlutterFlowTheme.of(context).secondaryText
                                  : FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              fontSize: 14.0,
                              decoration: currentLink.isEmpty
                                  ? null
                                  : TextDecoration.underline,
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  SizedBox(height: 8.0),

                  // Update Link Button
                  SizedBox(
                    width: double.infinity,
                    height: 36.0,
                    child: TextButton(
                      onPressed: () {
                        _showUpdateLinkDialog(
                            productName, currentLink, product);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Update Link',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
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
    ).animateOnPageLoad(animation);
  }

// ================================================================================
// SECTION 10: UPDATE LINK DIALOG
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Modal dialog for updating product buy links
// PURPOSE: Provides interface to modify product buy links
// REMOVAL IMPACT: Can be removed - will disable link update functionality
// COMPONENTS: AlertDialog with form field, validation, Firebase update logic
// ================================================================================

  void _showUpdateLinkDialog(
      String productName, String currentLink, BrandedItemsRecord? product) {
    final TextEditingController dialogController =
        TextEditingController(text: currentLink);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Dialog Header
          title: Row(
            children: [
              Icon(
                Icons.link,
                color: FlutterFlowTheme.of(context).primary,
                size: 24.0,
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Update Link',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Inter Tight',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),

          // Dialog Content with Update Form
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name Display
              Text(
                'Product: $productName',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 8.0),

              // Instructions
              Text(
                'Enter the new buy link for this product:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              SizedBox(height: 16.0),

              // Link Input Field
              TextFormField(
                controller: dialogController,
                decoration: InputDecoration(
                  hintText: 'https://your-store.com/product',
                  hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2.0,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.link,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                keyboardType: TextInputType.url,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),

          // Dialog Action Buttons
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              ),
              child: Text(
                'Cancel',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Handle Update Logic with Firebase
                if (product != null) {
                  try {
                    await product.reference.update({
                      'product_url': dialogController.text,
                    });

                    Navigator.of(context).pop();

                    // Success Feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Link updated for $productName',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        duration: Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();

                    // Error Feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Error updating link: ${e.toString()}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: FlutterFlowTheme.of(context).error,
                        duration: Duration(seconds: 4),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    );
                  }
                } else {
                  Navigator.of(context).pop();

                  // Product Not Found Error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Error: Product not found',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: FlutterFlowTheme.of(context).error,
                      duration: Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  SizedBox(width: 6.0),
                  Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

// ================================================================================
// SECTION 11: BOTTOM NAVIGATION WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Complete bottom navigation bar
// PURPOSE: Provides navigation between different vendor dashboard sections
// REMOVAL IMPACT: Can be completely removed - page will work without navigation
// COMPONENTS: Container with navigation items, icons, labels, and navigation logic
// ================================================================================

  Widget _buildBottomNavigation() {
    return Container(
      width: double.infinity,
      height: 80.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).underground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, -2.0),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Profile Navigation Item
          _buildNavItem(Icons.person, 'Profile', false,
              () => context.pushNamed(VendorDashboardWidget.routeName)),

          // Discount Code Navigation Item
          _buildNavItem(Icons.discount_outlined, 'Code', false,
              () => context.pushNamed(ManageDiscountCodesWidget.routeName)),

          // Virtual Try-On Navigation Item
          _buildNavItem(Icons.tv_rounded, 'Virtual', false,
              () => context.pushNamed(VirtualTryOnSettingWidget.routeName)),

          // Buy Links Navigation Item (Current Page)
          _buildNavItem(Icons.settings_sharp, 'Link', true, () => {}),

          // Add Product Navigation Item
          _buildNavItem(Icons.add, 'Add', false,
              () => context.pushNamed(AddProductWidget.routeName)),
        ],
      ),
    );
  }

// ================================================================================
// SECTION 12: NAVIGATION ITEM HELPER WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Individual navigation button component
// PURPOSE: Creates individual navigation items for the bottom navigation
// REMOVAL IMPACT: Required if bottom navigation is kept
// COMPONENTS: GestureDetector with icon, label, and active state styling
// ================================================================================

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Navigation Icon
          Icon(
            icon,
            color:
                isActive ? FlutterFlowTheme.of(context).primary : Colors.white,
            size: 24.0,
          ),
          SizedBox(height: 4.0),

          // Navigation Label
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: isActive
                      ? FlutterFlowTheme.of(context).primary
                      : Colors.white,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

// ================================================================================
// END OF SETTING BUY LINKS WIDGET
// ================================================================================

/*
===============================================================================
PRESENTATION REMOVAL GUIDE FOR YOUR LECTURER DEMO
===============================================================================

🟢 EASIEST TO REMOVE (Independent components):
1. SECTION 11: Bottom Navigation Widget (Lines ~700-750) - Complete navigation bar
2. SECTION 12: Navigation Item Helper Widget (Lines ~750-800) - Individual nav buttons
3. SECTION 6: Page Header Section (Lines ~320-350) - Title and description text
4. SECTION 8: Empty State Widget (Lines ~420-520) - No products message and button
5. Animations in SECTION 2 (Lines ~40-110) - All page load animations

🟡 MEDIUM COMPLEXITY (Feature removal):
6. SECTION 3: Delete Confirmation Dialog (Lines ~110-200) - Safety confirmation
7. SECTION 4: Delete Product Method (Lines ~200-300) - Actual deletion logic
8. SECTION 10: Update Link Dialog (Lines ~580-700) - Link modification functionality
9. Debug Information in SECTION 7 (Lines ~360-420) - Console logs and debug text

🔴 CORE COMPONENTS (Keep for basic functionality):
- SECTION 1: Main Widget Class - Essential structure
- SECTION 2: State Class - Required controllers and state (keep basic parts)
- SECTION 5: Main Build Method - Core page layout
- SECTION 7: Products List Section - Main functionality
- SECTION 9: Product Card Widget - Individual product display

PRESENTATION STRATEGY:
1. Start by removing SECTION 11 & 12 (Bottom Navigation) - Clean removal
2. Remove SECTION 6 (Page Header) - Simplifies the top
3. Remove SECTION 8 (Empty State) - Will show blank instead of helpful message
4. Remove SECTION 10 (Update Link Dialog) to disable link editing
5. Remove SECTION 3 & 4 (Delete functionality) to simplify product management
6. Remove animations from SECTION 2 to reduce complexity

Each section is clearly marked with numbered headers and difficulty indicators!
The core functionality (loading and displaying products) will remain intact.
===============================================================================
*/
