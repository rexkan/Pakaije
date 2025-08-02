import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vendor_dashboard_model.dart';
export 'vendor_dashboard_model.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/schema/users_record.dart'; // CHANGED: Use users_record instead of vendors_record
import 'package:intl/intl.dart';

class VendorDashboardWidget extends StatefulWidget {
  const VendorDashboardWidget({super.key});

  static String routeName = 'VendorDashboard';
  static String routePath = '/vendorDashboard';

  @override
  State<VendorDashboardWidget> createState() => _VendorDashboardWidgetState();
}

class _VendorDashboardWidgetState extends State<VendorDashboardWidget> {
  late VendorDashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildWelcomeSection() {
    print('Current User UID: $currentUserUid');
    return StreamBuilder<UsersRecord?>(
      // CHANGED: Use UsersRecord instead of VendorsRecord
      stream:
          _getCurrentUser(), // CHANGED: Use _getCurrentUser instead of _getCurrentVendor
      builder: (context, snapshot) {
        print('Snapshot hasData: ${snapshot.hasData}');
        print('Snapshot data: ${snapshot.data}');

        // Loading state
        if (!snapshot.hasData) {
          return Container(
            width: double.infinity,
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
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).accent1,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          width: 180.0,
                          height: 16.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final user = snapshot.data; // CHANGED: Use user instead of vendor
        final brandName = user?.displayName ??
            'Your Brand'; // CHANGED: Use displayName instead of brandName
        final email = user?.email ?? currentUserEmail ?? '';
        final isActiveVendor = user?.role == 'Vendor' &&
            user?.accountStatus ==
                'active'; // CHANGED: Check user role and status

        return Container(
          width: double.infinity,
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
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).accent1,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: user?.photoUrl?.isNotEmpty ==
                            true // CHANGED: Use user's photoUrl
                        ? Image.network(
                            user!.photoUrl,
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/user_848006.png',
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/user_848006.png',
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        brandName,
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Welcome to your dashboard',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                            ),
                      ),
                      if (email.isNotEmpty) ...[
                        SizedBox(height: 2.0),
                        Text(
                          email,
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Inter',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Status indicator - CHANGED: Use accountStatus from users collection
                if (isActiveVendor)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.green, width: 1.0),
                    ),
                    child: Text(
                      'Active',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            color: Colors.green,
                            fontSize: 10.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
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

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VendorDashboardModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// Handle logout functionality
  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Sign out the user
        await authManager.signOut();

        // Close loading dialog
        if (mounted) {
          Navigator.of(context).pop();

          // Navigate to login page and clear all previous routes
          context.goNamedAuth(LoginPageWidget.routeName, context.mounted);
        }
      } catch (e) {
        // Close loading dialog if still open
        if (mounted) {
          Navigator.of(context).pop();

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to logout: $e'),
              backgroundColor: Colors.red[600],
            ),
          );
        }
      }
    }
  }

  // CHANGED: New method to get current user from users collection
  Stream<UsersRecord?> _getCurrentUser() {
    if (currentUserUid.isEmpty) return Stream.value(null);

    return UsersRecord.collection
        .doc(currentUserUid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return UsersRecord.fromSnapshot(snapshot);
      }
      return null;
    });
  }

  // REMOVED: Delete these old vendor-related methods since we're using users collection now

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
          title: Text(
            'Vendor Dashboard',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Inter Tight',
                  color: Colors.white,
                  fontSize: 24.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          actions: [
            // Logout button
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
              child: FlutterFlowIconButton(
                borderRadius: 8.0,
                borderWidth: 0.0,
                buttonSize: 40.0,
                fillColor: Colors.transparent,
                hoverColor: Colors.white.withOpacity(0.1),
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: _handleLogout,
                showLoadingIndicator: false,
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              // Main content area
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      _buildWelcomeSection(),

                      SizedBox(height: 24.0),

                      // Quick Actions Section
                      _buildQuickActionsSection(),

                      SizedBox(height: 24.0),

                      // Products Section
                      _buildProductsSection(),

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

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Inter Tight',
                fontSize: 20.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16.0),

        // Action buttons in a responsive grid
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;

            return GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 6.0,
              children: [
                _buildActionButton(
                  'Virtual Try-On Setting',
                  Icons.tv_rounded,
                  () => context.pushNamed(VirtualTryOnSettingWidget.routeName),
                ),
                _buildActionButton(
                  'Generate Discount Codes',
                  Icons.discount_outlined,
                  () => context.pushNamed(ManageDiscountCodesWidget.routeName),
                ),
                _buildActionButton(
                  'Setting Buy Links',
                  Icons.settings_sharp,
                  () => context.pushNamed(SettingBuyLinksWidget.routeName),
                ),
                _buildActionButton(
                  'Add New Product',
                  Icons.add,
                  () => context.pushNamed(AddProductWidget.routeName),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, VoidCallback onPressed) {
    return FFButtonWidget(
      onPressed: onPressed,
      text: title,
      icon: Icon(
        icon,
        size: 20.0,
        color: Colors.white,
      ),
      options: FFButtonOptions(
        width: double.infinity,
        height: 48.0,
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
        color: Color(0xFF685B50),
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              fontFamily: 'Inter Tight',
              color: Colors.white,
              fontSize: 14.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
        elevation: 2.0,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

// Fixed _buildProductsSection method for vendor_dashboard_widget.dart

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Branded Products',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Inter Tight',
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            // Product count indicator - now shows only active products
            StreamBuilder<List<BrandedItemsRecord>>(
              stream: queryBrandedItemsRecord(
                queryBuilder: (brandedItemsRecord) => brandedItemsRecord
                    .where('vendor_id', isEqualTo: currentUserUid)
                    .orderBy('date_added',
                        descending: true), // REMOVED status filter from query
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Debug: Print all products to see what's being returned
                  print('Total products found: ${snapshot.data!.length}');
                  for (var product in snapshot.data!) {
                    print(
                        'Product: ${product.name}, Status: ${product.status}, RemovedAt: ${product.removedAt}');
                  }

                  // Filter active products
                  final activeProducts = snapshot.data!.where((product) {
                    bool isActive = product.status != 'removed_for_violation' &&
                        product.removedAt == null;
                    print('Product ${product.name} is active: $isActive');
                    return isActive;
                  }).toList();

                  print('Active products count: ${activeProducts.length}');

                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      '${activeProducts.length} items',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
        SizedBox(height: 16.0),

        // Products StreamBuilder - Updated to be more flexible
        StreamBuilder<List<BrandedItemsRecord>>(
          stream: queryBrandedItemsRecord(
            queryBuilder: (brandedItemsRecord) => brandedItemsRecord
                .where('vendor_id', isEqualTo: currentUserUid)
                .orderBy('date_added',
                    descending: true), // REMOVED status filter from query
          ),
          builder: (context, snapshot) {
            // Loading state
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Loading your products...',
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

            // Debug: Print raw data
            print('Raw products from Firebase: ${snapshot.data!.length}');

            // More lenient filtering - only filter out truly deleted products
            List<BrandedItemsRecord> products = snapshot.data!.where((product) {
              // Only filter out products that are explicitly marked as removed
              bool shouldInclude = product.status != 'removed_for_violation';
              print(
                  'Product ${product.name}: status=${product.status}, including=$shouldInclude');
              return shouldInclude;
            }).toList();

            print('Filtered products count: ${products.length}');

            // Empty state
            if (products.isEmpty) {
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
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'No products found',
                      style: FlutterFlowTheme.of(context)
                          .headlineSmall
                          .override(
                            fontFamily: 'Inter Tight',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Debug: Total from DB: ${snapshot.data!.length}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Inter',
                            color: Colors.red,
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Start building your brand by adding your first product',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.0),
                    FFButtonWidget(
                      onPressed: () =>
                          context.pushNamed(AddProductWidget.routeName),
                      text: 'Add Your First Product',
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 20.0,
                      ),
                      options: FFButtonOptions(
                        height: 44.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Inter Tight',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                    ),
                  ],
                ),
              );
            }

            // FIXED: Products grid with proper scrollable layout
            return Column(
              children: [
                // Container with fixed height for scrollable grid
                Container(
                  height: 400.0, // Fixed height for scrollable area
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

                      return GridView.builder(
                        // REMOVED: shrinkWrap and NeverScrollableScrollPhysics
                        // This allows the GridView to handle its own scrolling
                        physics:
                            AlwaysScrollableScrollPhysics(), // Enable scrolling
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount:
                            products.length, // Show ALL products, not just 6
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _buildProductCard(product);
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 16.0),

                // Show total count
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    'Total: ${products.length} products',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 16.0),

                // Add Product Button
                Center(
                  child: FFButtonWidget(
                    onPressed: () =>
                        context.pushNamed(AddProductWidget.routeName),
                    text: '+ Add New Product',
                    options: FFButtonOptions(
                      width: 200.0,
                      height: 44.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter Tight',
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // Optional: Add method to show deleted products in a separate section
  Widget _buildDeletedProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: Text(
            'Removed Products',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Inter Tight',
                  fontSize: 18.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
          ),
          subtitle: Text(
            'Products removed by admin due to policy violations',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
          children: [
            StreamBuilder<List<BrandedItemsRecord>>(
              stream: queryBrandedItemsRecord(
                queryBuilder: (brandedItemsRecord) => brandedItemsRecord
                    .where('vendor_id', isEqualTo: currentUserUid)
                    .where('status', isEqualTo: 'removed_for_violation')
                    .orderBy('removed_at', descending: true),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<BrandedItemsRecord> deletedProducts = snapshot.data!;

                if (deletedProducts.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No removed products',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: deletedProducts.length,
                  itemBuilder: (context, index) {
                    final product = deletedProducts[index];
                    return _buildDeletedProductCard(product);
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to build deleted product cards
  Widget _buildDeletedProductCard(BrandedItemsRecord product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1.0),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: product.imageUrl.isNotEmpty
              ? Image.network(
                  product.imageUrl,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50.0,
                      height: 50.0,
                      color: FlutterFlowTheme.of(context).alternate,
                      child: Icon(Icons.image_not_supported),
                    );
                  },
                )
              : Container(
                  width: 50.0,
                  height: 50.0,
                  color: FlutterFlowTheme.of(context).alternate,
                  child: Icon(Icons.image),
                ),
        ),
        title: Text(
          product.name,
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                fontFamily: 'Inter',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.category,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            if (product.removedAt != null)
              Text(
                'Removed: ${DateFormat('MMM dd, yyyy').format(product.removedAt!)}',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Inter',
                      color: Colors.red,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                    ),
              ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.red, width: 1.0),
          ),
          child: Text(
            'Removed',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Inter',
                  color: Colors.red,
                  fontSize: 10.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BrandedItemsRecord product) {
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: FlutterFlowTheme.of(context).alternate,
                          child: Icon(
                            Icons.image_not_supported,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 32.0,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: FlutterFlowTheme.of(context).alternate,
                      child: Icon(
                        Icons.image,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 32.0,
                      ),
                    ),
            ),
          ),

          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4.0),

                  // Category
                  Text(
                    product.category,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                  ),

                  Spacer(),

                  // Price and Status - FIXED: Added Flexible widgets to prevent overflow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price with Flexible to prevent overflow
                      Flexible(
                        flex: 2,
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                          overflow: TextOverflow
                              .ellipsis, // Add this to handle long prices
                        ),
                      ),

                      SizedBox(width: 8.0), // Add some spacing

                      // Status badge with Flexible
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 3.0), // Reduced padding
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent1,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            'Active',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 9.0, // Reduced font size
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
          _buildNavItem(Icons.person, 'Profile', true, () => {}),
          _buildNavItem(Icons.discount_outlined, 'Code', false,
              () => context.pushNamed(ManageDiscountCodesWidget.routeName)),
          _buildNavItem(Icons.tv_rounded, 'Virtual', false,
              () => context.pushNamed(VirtualTryOnSettingWidget.routeName)),
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
