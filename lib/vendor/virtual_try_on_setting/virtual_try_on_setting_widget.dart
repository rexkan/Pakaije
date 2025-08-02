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

class VirtualTryOnSettingWidget extends StatefulWidget {
  const VirtualTryOnSettingWidget({super.key});

  static String routeName = 'VirtualTryOnSetting';
  static String routePath = '/virtualTryOnSetting';

  @override
  State<VirtualTryOnSettingWidget> createState() =>
      _VirtualTryOnSettingWidgetState();
}

class _VirtualTryOnSettingWidgetState extends State<VirtualTryOnSettingWidget>
    with TickerProviderStateMixin {
  late VirtualTryOnSettingModel _model;

  // Map to track virtual try-on state for each product
  Map<String, bool> _productVirtualTryOnState = {};

  // Map to track animation controllers for each product
  Map<String, AnimationController> _animationControllers = {};

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VirtualTryOnSettingModel());

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

  // Initialize animation controller for a product
  AnimationController _getAnimationController(String productId) {
    if (!_animationControllers.containsKey(productId)) {
      _animationControllers[productId] = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
    }
    return _animationControllers[productId]!;
  }

  // Get virtual try-on state for a product
  bool _getVirtualTryOnState(String productId) {
    return _productVirtualTryOnState[productId] ?? true; // Default to true
  }

  // Update virtual try-on state for a product
  void _updateVirtualTryOnState(String productId, bool value) {
    setState(() {
      _productVirtualTryOnState[productId] = value;
    });

    // Animate the controller
    final controller = _getAnimationController(productId);
    if (value) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(BrandedItemsRecord product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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

  // Delete product from Firebase
  Future<void> _deleteProduct(BrandedItemsRecord product) async {
    try {
      // Show loading indicator
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

      // Delete the product from Firebase
      await product.reference.delete();

      // Remove from local state
      _productVirtualTryOnState.remove(product.reference.id);
      _animationControllers[product.reference.id]?.dispose();
      _animationControllers.remove(product.reference.id);

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
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
      // Close loading dialog if it's open
      Navigator.of(context).pop();

      // Show error message
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
                      Text(
                        'Product Lists',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
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

                      SizedBox(height: 24.0),

                      // Products Grid
                      StreamBuilder<List<BrandedItemsRecord>>(
                        stream: queryBrandedItemsRecord(
                          queryBuilder: (brandedItemsRecord) =>
                              brandedItemsRecord.where('vendor_id',
                                  isEqualTo: currentUserUid),
                        ),
                        builder: (context, snapshot) {
                          // Loading state
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

                          // ADDED: Additional client-side filtering as safety net
                          List<BrandedItemsRecord> products =
                              snapshot.data!.where((product) {
                            // Filter out products that are deleted or have removal timestamp
                            return product.status != 'removed_for_violation' &&
                                product.removedAt == null;
                          }).toList();

                          // Empty state
                          if (products.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 64.0,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'No active products found', // UPDATED: Changed text
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Inter Tight',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Add some products to manage virtual try-on settings',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              int crossAxisCount =
                                  constraints.maxWidth > 600 ? 2 : 1;

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16.0,
                                  mainAxisSpacing: 16.0,
                                  childAspectRatio:
                                      crossAxisCount == 2 ? 1.0 : 0.8,
                                ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];

                                  // Get the style tags as a string
                                  String tags = product.styleTags.isNotEmpty
                                      ? product.styleTags.join(', ')
                                      : product.category;

                                  return _buildProductCard(
                                    product.name,
                                    tags,
                                    _getVirtualTryOnState(product.reference.id),
                                    (value) {
                                      _updateVirtualTryOnState(
                                          product.reference.id, value);
                                    },
                                    product: product,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),

                      SizedBox(height: 80.0), // Space for bottom navigation
                    ],
                  ),
                ),
              ),

              // Bottom Navigation
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

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
                // Header with Delete Button
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

                // Product Image
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

                // Product Info
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show price if available
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

                      // Virtual Try-On Toggle with Animation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AnimatedDefaultTextStyle(
                              duration: Duration(milliseconds: 200),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    color: isEnabled
                                        ? FlutterFlowTheme.of(context)
                                            .primaryText
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                  ),
                              child: Text('Virtual Try-On'),
                            ),
                          ),

                          // Custom Animated Switch
                          GestureDetector(
                            onTap: () {
                              onChanged(!isEnabled);

                              // Show animated feedback
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      AnimatedSwitcher(
                                        duration: Duration(milliseconds: 300),
                                        child: Icon(
                                          !isEnabled
                                              ? Icons.visibility
                                              : Icons.visibility_off,
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
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).primary,
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
                                alignment: isEnabled
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
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
                                          : FlutterFlowTheme.of(context)
                                              .secondaryText,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
  }

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
          _buildNavItem(Icons.person, 'Profile', false,
              () => context.pushNamed(VendorDashboardWidget.routeName)),
          _buildNavItem(Icons.discount_outlined, 'Code', false,
              () => context.pushNamed(ManageDiscountCodesWidget.routeName)),
          _buildNavItem(Icons.tv_rounded, 'Virtual', true, () => {}),
          _buildNavItem(Icons.settings_sharp, 'Link', false,
              () => context.pushNamed(SettingBuyLinksWidget.routeName)),
          _buildNavItem(Icons.add, 'Add', false,
              () => context.pushNamed(AddProductWidget.routeName)),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color:
                isActive ? FlutterFlowTheme.of(context).primary : Colors.white,
            size: 24.0,
          ),
          SizedBox(height: 4.0),
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
