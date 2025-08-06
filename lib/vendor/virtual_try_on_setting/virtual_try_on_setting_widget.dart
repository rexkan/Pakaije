import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'virtual_try_on_setting_model.dart';
export 'virtual_try_on_setting_model.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';

// ================================================================================
// SECTION 1: MAIN WIDGET CLASS DECLARATION
// ================================================================================
// 🔴 CORE COMPONENT - This is the main widget class structure
// PURPOSE: Defines the main StatefulWidget for the virtual try-on settings page
// REMOVAL IMPACT: Cannot remove - this is the core widget structure
// COMPONENTS: StatefulWidget class, route names, and state creation
// ================================================================================

class VirtualTryOnSettingWidget extends StatefulWidget {
  const VirtualTryOnSettingWidget({super.key});

  static String routeName = 'VirtualTryOnSetting';
  static String routePath = '/virtualTryOnSetting';

  @override
  State<VirtualTryOnSettingWidget> createState() =>
      _VirtualTryOnSettingWidgetState();
}

// ================================================================================
// SECTION 2: STATE CLASS AND INITIALIZATION
// ================================================================================
// 🔴 CORE COMPONENT - Contains essential state management and animations
// PURPOSE: Manages page state, model initialization, and widget lifecycle
// REMOVAL IMPACT: Cannot remove - required for page functionality
// COMPONENTS: State class, model initialization, switch values, dispose method
// ================================================================================

class _VirtualTryOnSettingWidgetState extends State<VirtualTryOnSettingWidget>
    with TickerProviderStateMixin {
  late VirtualTryOnSettingModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Map to track virtual try-on state for each product
  Map<String, bool> _productVirtualTryOnState = {};

  // Map to track animation controllers for each product
  Map<String, AnimationController> _animationControllers = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VirtualTryOnSettingModel());

    // Default Switch Values
    _model.switchValue1 = true;
    _model.switchValue2 = true;
    _model.switchValue3 = false;
    _model.switchValue4 = true;
  }

  @override
  void dispose() {
    _model.dispose();
    // Dispose all animation controllers
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

// ================================================================================
// SECTION 3: ANIMATION AND STATE MANAGEMENT METHODS
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Animation controllers and virtual try-on state management
// PURPOSE: Manages per-product animations and virtual try-on toggle states
// REMOVAL IMPACT: Can be removed - will disable animations and individual product states
// COMPONENTS: Animation controller initialization, state getters/setters
// ================================================================================

  // Initialize Animation Controller for a Product
  AnimationController _getAnimationController(String productId) {
    if (!_animationControllers.containsKey(productId)) {
      _animationControllers[productId] = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
    }
    return _animationControllers[productId]!;
  }

  // Get Virtual Try-On State for a Product
  bool _getVirtualTryOnState(String productId) {
    return _productVirtualTryOnState[productId] ?? true; // Default to true
  }

  // Update Virtual Try-On State for a Product
  void _updateVirtualTryOnState(String productId, bool value) {
    setState(() {
      _productVirtualTryOnState[productId] = value;
    });

    // Animate the Controller
    final controller = _getAnimationController(productId);
    if (value) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

// ================================================================================
// SECTION 4: DELETE CONFIRMATION DIALOG
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
// SECTION 5: DELETE PRODUCT METHOD
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Firebase deletion logic with state cleanup
// PURPOSE: Handles the actual deletion of products from Firebase with UI feedback
// REMOVAL IMPACT: Required if delete functionality is kept
// COMPONENTS: Loading dialog, Firebase delete operation, state cleanup, success/error snackbars
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

      // Clean Up Local State
      _productVirtualTryOnState.remove(product.reference.id);
      _animationControllers[product.reference.id]?.dispose();
      _animationControllers.remove(product.reference.id);

      // Close Loading Dialog
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
      // Close Loading Dialog if Open
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
// SECTION 6: MAIN BUILD METHOD
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,

        // ========================================================================
        // SUB-SECTION 6A: APP BAR
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
            'Virtual Try-On Setting',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Inter Tight',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),

        // ========================================================================
        // SUB-SECTION 6B: BODY LAYOUT
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

                      // Products Grid Section
                      _buildProductsGrid(),

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
// SECTION 7: PAGE HEADER SECTION
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
                fontFamily: 'Inter Tight',
                fontSize: 24.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8.0),
        Text(
          'Enable or disable virtual try-on for your products',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Inter',
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }

// ================================================================================
// SECTION 8: PRODUCTS GRID SECTION
// ================================================================================
// 🔴 CORE COMPONENT - Main functionality displaying products from Firebase
// PURPOSE: Shows list of products with virtual try-on toggle capabilities
// REMOVAL IMPACT: Major impact - this is the main functionality
// COMPONENTS: StreamBuilder, Firebase query, product grid, empty state, loading state
// ================================================================================

  Widget _buildProductsGrid() {
    return StreamBuilder<List<BrandedItemsRecord>>(
      stream: queryBrandedItemsRecord(
        queryBuilder: (brandedItemsRecord) =>
            brandedItemsRecord.where('vendor_id', isEqualTo: currentUserUid),
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

        // Client-side Filtering for Active Products
        List<BrandedItemsRecord> products = snapshot.data!.where((product) {
          // Filter out products that are deleted or have removal timestamp
          return product.status != 'removed_for_violation' &&
              product.removedAt == null;
        }).toList();

        // Empty State
        if (products.isEmpty) {
          return _buildEmptyState();
        }

        // Products Grid Display
        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: crossAxisCount == 2 ? 1.0 : 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                // Get Style Tags as String
                String tags = product.styleTags.isNotEmpty
                    ? product.styleTags.join(', ')
                    : product.category;

                return _buildProductCard(
                  product.name,
                  tags,
                  _getVirtualTryOnState(product.reference.id),
                  (value) {
                    _updateVirtualTryOnState(product.reference.id, value);
                  },
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
// SECTION 9: EMPTY STATE WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Empty state display when no products exist
// PURPOSE: Shows helpful message when no products are found
// REMOVAL IMPACT: Can be removed - will show blank space instead of helpful message
// COMPONENTS: Container with icon, text, and helpful message
// ================================================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty State Icon
          Icon(
            Icons.inventory_2_outlined,
            size: 64.0,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          SizedBox(height: 16.0),

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
          SizedBox(height: 8.0),

          // Empty State Description
          Text(
            'Add some products to manage virtual try-on settings',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

// ================================================================================
// SECTION 10: PRODUCT CARD WIDGET
// ================================================================================
// 🔴 CORE COMPONENT - Individual product card with virtual try-on toggle
// PURPOSE: Displays individual product with animated virtual try-on controls
// REMOVAL IMPACT: Major impact - essential for virtual try-on management
// COMPONENTS: Animated card, product image, info, custom animated switch, feedback
// ================================================================================

  Widget _buildProductCard(
    String productName,
    String tags,
    bool isEnabled,
    Function(bool) onChanged, {
    BrandedItemsRecord? product,
  }) {
    final productId = product?.reference.id ?? '';
    final animationController = _getAnimationController(productId);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                color: Color(0x33000000),
                offset: Offset(0.0, 2.0),
              )
            ],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isEnabled
                  ? FlutterFlowTheme.of(context).primary.withOpacity(0.3)
                  : FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
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
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  fontFamily: 'Inter Tight',
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
                          color: FlutterFlowTheme.of(context)
                              .error
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context)
                                .error
                                .withOpacity(0.3),
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
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 48.0,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: FlutterFlowTheme.of(context).alternate,
                              child: Icon(
                                Icons.image,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 48.0,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 16.0),

                // Product Information and Controls Section
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Price Display
                      if (product != null)
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),

                      SizedBox(height: 8.0),

                      // Product Tags Display
                      Text(
                        'Tags: $tags',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                            ),
                      ),

                      Spacer(),

                      // Virtual Try-On Toggle Section with Custom Animation
                      _buildVirtualTryOnToggle(
                          productName, isEnabled, onChanged),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// ================================================================================
// SECTION 11: VIRTUAL TRY-ON TOGGLE WIDGET
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Custom animated toggle switch with feedback
// PURPOSE: Provides animated toggle control for virtual try-on feature per product
// REMOVAL IMPACT: Can be removed - will disable virtual try-on toggle functionality
// COMPONENTS: Custom animated switch, tap handling, snackbar feedback, state animations
// ================================================================================

  Widget _buildVirtualTryOnToggle(
      String productName, bool isEnabled, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Toggle Label with Color Animation
        Expanded(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 200),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                  color: isEnabled
                      ? FlutterFlowTheme.of(context).primaryText
                      : FlutterFlowTheme.of(context).secondaryText,
                ),
            child: Text('Virtual Try-On'),
          ),
        ),

        // Custom Animated Switch
        GestureDetector(
          onTap: () {
            onChanged(!isEnabled);

            // Show Animated Feedback with SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        !isEnabled ? Icons.visibility : Icons.visibility_off,
                        key: ValueKey(!isEnabled),
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(!isEnabled
                          ? 'Virtual try-on enabled for $productName'
                          : 'Virtual try-on disabled for $productName'),
                    ),
                  ],
                ),
                backgroundColor: FlutterFlowTheme.of(context).primary,
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            );
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 50.0,
            height: 30.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: isEnabled
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).alternate,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedAlign(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment:
                  isEnabled ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 26.0,
                height: 26.0,
                margin: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2.0,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    isEnabled ? Icons.check : Icons.close,
                    key: ValueKey(isEnabled),
                    size: 16.0,
                    color: isEnabled
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

// ================================================================================
// SECTION 12: BOTTOM NAVIGATION WIDGET
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

          // Discount Codes Navigation Item
          _buildNavItem(Icons.discount_outlined, 'Code', false,
              () => context.pushNamed(ManageDiscountCodesWidget.routeName)),

          // Virtual Try-On Navigation Item (Current Page)
          _buildNavItem(Icons.tv_rounded, 'Virtual', true, () => {}),

          // Buy Links Navigation Item
          _buildNavItem(Icons.settings_sharp, 'Link', false,
              () => context.pushNamed(SettingBuyLinksWidget.routeName)),

          // Add Product Navigation Item
          _buildNavItem(Icons.add, 'Add', false,
              () => context.pushNamed(AddProductWidget.routeName)),
        ],
      ),
    );
  }

// ================================================================================
// SECTION 13: NAVIGATION ITEM HELPER WIDGET
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
                  fontFamily: 'Inter',
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
// END OF VIRTUAL TRY-ON SETTING WIDGET
// ================================================================================

/*
===============================================================================
PRESENTATION REMOVAL GUIDE FOR YOUR LECTURER DEMO
===============================================================================

🟢 EASIEST TO REMOVE (Independent components):
1. SECTION 12 & 13: Bottom Navigation (Lines ~550-620) - Complete navigation system
2. SECTION 7: Page Header Section (Lines ~300-330) - Title and description text
3. SECTION 9: Empty State Widget (Lines ~390-440) - No products message
4. SECTION 11: Virtual Try-On Toggle Widget (Lines ~500-550) - Custom animated switch
5. SECTION 3: Animation and State Management (Lines ~80-130) - Per-product animations

🟡 MEDIUM COMPLEXITY (Feature removal):
6. SECTION 4: Delete Confirmation Dialog (Lines ~130-220) - Safety confirmation
7. SECTION 5: Delete Product Method (Lines ~220-300) - Actual deletion logic
8. Custom Animations in SECTION 10 (Product Card animations)
9. SnackBar Feedback in SECTION 11 (Toggle feedback messages)

🔴 CORE COMPONENTS (Keep for basic functionality):
- SECTION 1: Main Widget Class - Essential structure
- SECTION 2: State Class - Required controllers and state (keep basic parts)
- SECTION 6: Main Build Method - Core page layout
- SECTION 8: Products Grid Section - Main product listing functionality
- SECTION 10: Product Card Widget - Individual product display (simplified version)

PRESENTATION STRATEGY:
1. Start by removing SECTION 12 & 13 (Bottom Navigation) - Clean removal
2. Remove SECTION 7 (Page Header) - Simplifies the top area
3. Remove SECTION 11 (Virtual Try-On Toggle) - Removes the custom animated switch
4. Remove SECTION 9 (Empty State) - Will show blank instead of helpful message
5. Remove SECTION 3 (Animation Management) - Disables per-product animations
6. Remove SECTION 4 & 5 (Delete functionality) - Simplifies product management
7. Simplify SECTION 10 by removing animations and just showing basic product info

UNIQUE FEATURES TO HIGHLIGHT:
- Custom animated toggle switches
- Per-product state management
- Smooth animations and transitions
- Real-time feedback with snackbars
- Advanced animation controller management

The core functionality (loading and displaying products) will remain intact!
Each section is clearly marked with numbered headers and difficulty indicators.
===============================================================================
*/
