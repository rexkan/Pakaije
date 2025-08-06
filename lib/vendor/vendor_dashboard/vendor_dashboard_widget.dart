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
import '/backend/schema/users_record.dart';
import 'package:intl/intl.dart';

// ================================================================================
// SECTION 1: MAIN WIDGET CLASS DECLARATION
// ================================================================================
// 🔴 CORE COMPONENT - This is the main widget class structure
// PURPOSE: Defines the main StatefulWidget for the vendor dashboard page
// REMOVAL IMPACT: Cannot remove - this is the core widget structure
// COMPONENTS: StatefulWidget class, route names, and state creation
// ================================================================================

class VendorDashboardWidget extends StatefulWidget {
  const VendorDashboardWidget({super.key});

  static String routeName = 'VendorDashboard';
  static String routePath = '/vendorDashboard';

  @override
  State<VendorDashboardWidget> createState() => _VendorDashboardWidgetState();
}

// ================================================================================
// SECTION 2: STATE CLASS AND INITIALIZATION
// ================================================================================
// 🔴 CORE COMPONENT - Contains essential state management
// PURPOSE: Manages page state, model initialization, and widget lifecycle
// REMOVAL IMPACT: Cannot remove - required for page functionality
// COMPONENTS: State class, model initialization, dispose method
// ================================================================================

class _VendorDashboardWidgetState extends State<VendorDashboardWidget> {
  late VendorDashboardModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

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

// ================================================================================
// SECTION 3: USER DATA FETCHING METHOD
// ================================================================================
// 🔴 CORE COMPONENT - Firebase user data stream
// PURPOSE: Fetches current user data from Firebase users collection
// REMOVAL IMPACT: Cannot remove - required for welcome section functionality
// COMPONENTS: Stream<UsersRecord?> method, Firebase query, null safety
// ================================================================================

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

// ================================================================================
// SECTION 4: LOGOUT FUNCTIONALITY
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - User authentication logout process
// PURPOSE: Handles user logout with confirmation dialog and navigation
// REMOVAL IMPACT: Can be removed - will disable logout functionality
// COMPONENTS: Confirmation dialog, loading indicator, auth sign out, navigation
// ================================================================================

  Future<void> _handleLogout() async {
    // Show Confirmation Dialog
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
        // Show Loading Indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Sign Out User
        await authManager.signOut();

        // Close Loading Dialog and Navigate
        if (mounted) {
          Navigator.of(context).pop();
          context.goNamedAuth(LoginPageWidget.routeName, context.mounted);
        }
      } catch (e) {
        // Error Handling
        if (mounted) {
          Navigator.of(context).pop();
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,

        // ========================================================================
        // SUB-SECTION 5A: APP BAR WITH LOGOUT
        // ========================================================================
        // 🟡 MEDIUM COMPLEXITY - Top navigation bar with logout functionality
        // PURPOSE: Provides page title and logout button
        // REMOVAL IMPACT: Can simplify by removing logout button
        // ========================================================================

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

          // Logout Button Action
          actions: [
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

              // Bottom Navigation Section
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

// ================================================================================
// SECTION 6: WELCOME SECTION WIDGET
// ================================================================================
// 🔴 CORE COMPONENT - User welcome and profile display
// PURPOSE: Shows user profile, name, email, and active status
// REMOVAL IMPACT: Major impact - main user identification area
// COMPONENTS: StreamBuilder, user data display, loading state, profile image
// ================================================================================

  Widget _buildWelcomeSection() {
    print('Current User UID: $currentUserUid');
    return StreamBuilder<UsersRecord?>(
      stream: _getCurrentUser(),
      builder: (context, snapshot) {
        print('Snapshot hasData: ${snapshot.hasData}');
        print('Snapshot data: ${snapshot.data}');

        // Loading State
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
                  // Loading Avatar Placeholder
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

                  // Loading Text Placeholders
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

        // User Data Display
        final user = snapshot.data;
        final brandName = user?.displayName ?? 'Your Brand';
        final email = user?.email ?? currentUserEmail ?? '';
        final isActiveVendor =
            user?.role == 'Vendor' && user?.accountStatus == 'active';

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
                // User Profile Image
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
                    child: user?.photoUrl?.isNotEmpty == true
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

                // User Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand Name
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

                      // Welcome Message
                      Text(
                        'Welcome to your dashboard',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                            ),
                      ),

                      // User Email
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

                // Active Status Badge
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

// ================================================================================
// SECTION 7: QUICK ACTIONS SECTION
// ================================================================================
// 🟢 EASY TO REMOVE - Navigation buttons for main app features
// PURPOSE: Provides quick access buttons to main vendor features
// REMOVAL IMPACT: Can be completely removed - just removes quick navigation
// COMPONENTS: Section title, responsive grid, action buttons with navigation
// ================================================================================

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
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

        // Action Buttons in Responsive Grid
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
                // Virtual Try-On Action Button
                _buildActionButton(
                  'Virtual Try-On Setting',
                  Icons.tv_rounded,
                  () => context.pushNamed(VirtualTryOnSettingWidget.routeName),
                ),

                // Discount Codes Action Button
                _buildActionButton(
                  'Generate Discount Codes',
                  Icons.discount_outlined,
                  () => context.pushNamed(ManageDiscountCodesWidget.routeName),
                ),

                // Buy Links Action Button
                _buildActionButton(
                  'Setting Buy Links',
                  Icons.settings_sharp,
                  () => context.pushNamed(SettingBuyLinksWidget.routeName),
                ),

                // Add Product Action Button
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

// ================================================================================
// SECTION 8: ACTION BUTTON HELPER WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Individual action button component
// PURPOSE: Creates individual action buttons for the quick actions section
// REMOVAL IMPACT: Required if quick actions section is kept
// COMPONENTS: FFButtonWidget with icon, text, and navigation callback
// ================================================================================

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

// ================================================================================
// SECTION 9: PRODUCTS SECTION WIDGET
// ================================================================================
// 🔴 CORE COMPONENT - Main products display functionality
// PURPOSE: Shows vendor's products with filtering, count, and management
// REMOVAL IMPACT: Major impact - this is core dashboard functionality
// COMPONENTS: StreamBuilder, Firebase query, product filtering, empty state, grid view
// ================================================================================

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with Product Count
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

            // Product Count Badge
            StreamBuilder<List<BrandedItemsRecord>>(
              stream: queryBrandedItemsRecord(
                queryBuilder: (brandedItemsRecord) => brandedItemsRecord
                    .where('vendor_id', isEqualTo: currentUserUid)
                    .orderBy('date_added', descending: true),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Debug Information
                  print('Total products found: ${snapshot.data!.length}');
                  for (var product in snapshot.data!) {
                    print(
                        'Product: ${product.name}, Status: ${product.status}, RemovedAt: ${product.removedAt}');
                  }

                  // Filter Active Products
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

        // Products StreamBuilder
        StreamBuilder<List<BrandedItemsRecord>>(
          stream: queryBrandedItemsRecord(
            queryBuilder: (brandedItemsRecord) => brandedItemsRecord
                .where('vendor_id', isEqualTo: currentUserUid)
                .orderBy('date_added', descending: true),
          ),
          builder: (context, snapshot) {
            // Loading State
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

            // Debug Information
            print('Raw products from Firebase: ${snapshot.data!.length}');

            // Filter Products
            List<BrandedItemsRecord> products = snapshot.data!.where((product) {
              bool shouldInclude = product.status != 'removed_for_violation';
              print(
                  'Product ${product.name}: status=${product.status}, including=$shouldInclude');
              return shouldInclude;
            }).toList();

            print('Filtered products count: ${products.length}');

            // Empty State
            if (products.isEmpty) {
              return _buildEmptyProductsState(snapshot.data!);
            }

            // Products Display
            return _buildProductsGrid(products);
          },
        ),
      ],
    );
  }

// ================================================================================
// SECTION 10: EMPTY PRODUCTS STATE WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Empty state when no products exist
// PURPOSE: Shows helpful message and action when no products are found
// REMOVAL IMPACT: Can be removed - will show blank space instead of helpful message
// COMPONENTS: Container with icon, text, debug info, and "Add Product" button
// ================================================================================

  Widget _buildEmptyProductsState(List<BrandedItemsRecord> allProducts) {
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
            'No products found',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: 'Inter Tight',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8.0),

          // Debug Information
          Text(
            'Debug: Total from DB: ${allProducts.length}',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Inter',
                  color: Colors.red,
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(height: 8.0),

          // Empty State Description
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

          // Add First Product Button
          FFButtonWidget(
            onPressed: () => context.pushNamed(AddProductWidget.routeName),
            text: 'Add Your First Product',
            icon: Icon(
              Icons.add_circle_outline,
              size: 20.0,
            ),
            options: FFButtonOptions(
              height: 44.0,
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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

// ================================================================================
// SECTION 11: PRODUCTS GRID WIDGET
// ================================================================================
// 🔴 CORE COMPONENT - Grid display of products with scrolling
// PURPOSE: Displays products in a scrollable grid with count and add button
// REMOVAL IMPACT: Major impact - core product display functionality
// COMPONENTS: Scrollable container, responsive grid, product cards, summary section
// ================================================================================

  Widget _buildProductsGrid(List<BrandedItemsRecord> products) {
    return Column(
      children: [
        // Scrollable Products Grid Container
        Container(
          height: 400.0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

              return GridView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(product);
                },
              );
            },
          ),
        ),

        SizedBox(height: 16.0),

        // Products Summary Container
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

        // Add New Product Button
        Center(
          child: FFButtonWidget(
            onPressed: () => context.pushNamed(AddProductWidget.routeName),
            text: '+ Add New Product',
            options: FFButtonOptions(
              width: 200.0,
              height: 44.0,
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
  }

// ================================================================================
// SECTION 12: PRODUCT CARD WIDGET
// ================================================================================
// 🔴 CORE COMPONENT - Individual product display card
// PURPOSE: Displays individual product information in card format
// REMOVAL IMPACT: Major impact - essential for product display
// COMPONENTS: Card container, product image, name, category, price, status
// ================================================================================

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
          // Product Image Section
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

          // Product Information Section
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

                  // Product Category
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

                  // Price and Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Product Price
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
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(width: 8.0),

                      // Active Status Badge
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 3.0),
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
                                  fontSize: 9.0,
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

// ================================================================================
// SECTION 13: DELETED PRODUCTS SECTION (OPTIONAL)
// ================================================================================
// 🟢 EASY TO REMOVE - Shows products removed by admin (expandable section)
// PURPOSE: Displays products that were removed due to policy violations
// REMOVAL IMPACT: Can be completely removed - optional troubleshooting feature
// COMPONENTS: ExpansionTile, StreamBuilder for deleted products, deleted product cards
// ================================================================================

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

// ================================================================================
// SECTION 14: DELETED PRODUCT CARD WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Individual deleted product display card
// PURPOSE: Shows information for products removed by admin
// REMOVAL IMPACT: Required if deleted products section is kept
// COMPONENTS: ListTile with product image, name, category, removal date, status
// ================================================================================

  Widget _buildDeletedProductCard(BrandedItemsRecord product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1.0),
      ),
      child: ListTile(
        // Product Image
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

        // Product Name
        title: Text(
          product.name,
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                fontFamily: 'Inter',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),

        // Product Details
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

        // Removed Status Badge
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

// ================================================================================
// SECTION 15: BOTTOM NAVIGATION WIDGET
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
          // Profile Navigation Item (Current Page)
          _buildNavItem(Icons.person, 'Profile', true, () => {}),

          // Discount Codes Navigation Item
          _buildNavItem(Icons.discount_outlined, 'Code', false,
              () => context.pushNamed(ManageDiscountCodesWidget.routeName)),

          // Virtual Try-On Navigation Item
          _buildNavItem(Icons.tv_rounded, 'Virtual', false,
              () => context.pushNamed(VirtualTryOnSettingWidget.routeName)),

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
// SECTION 16: NAVIGATION ITEM HELPER WIDGET
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
// END OF VENDOR DASHBOARD WIDGET
// ================================================================================

/*
===============================================================================
PRESENTATION REMOVAL GUIDE FOR YOUR LECTURER DEMO
===============================================================================

🟢 EASIEST TO REMOVE (Independent components):
1. SECTION 15 & 16: Bottom Navigation (Lines ~800-900) - Complete navigation system
2. SECTION 7 & 8: Quick Actions Section (Lines ~350-450) - Navigation button grid
3. SECTION 13 & 14: Deleted Products Section (Lines ~700-800) - Optional admin removal tracking
4. SECTION 10: Empty Products State (Lines ~550-620) - No products message
5. SECTION 4: Logout Functionality (Lines ~90-150) - Authentication logout

🟡 MEDIUM COMPLEXITY (Feature removal):
6. Product Count Badge in SECTION 9 (Lines ~450-500) - Active products counter
7. Products Summary in SECTION 11 (Lines ~650-700) - Total count and add button
8. Loading States in SECTION 6 & 9 (Lines ~200-250, 500-520) - Loading indicators
9. Debug Information throughout - Console.log statements and debug text

🔴 CORE COMPONENTS (Keep for basic functionality):
- SECTION 1: Main Widget Class - Essential structure
- SECTION 2: State Class - Required controllers and state
- SECTION 3: User Data Fetching - Firebase user stream
- SECTION 5: Main Build Method - Core page layout
- SECTION 6: Welcome Section - User profile display
- SECTION 9: Products Section - Main product listing functionality
- SECTION 11: Products Grid - Core product display
- SECTION 12: Product Card - Individual product display

PRESENTATION STRATEGY:
1. Start by removing SECTION 15 & 16 (Bottom Navigation) - Clean removal
2. Remove SECTION 7 & 8 (Quick Actions) - Simplifies dashboard to focus on products
3. Remove SECTION 13 & 14 (Deleted Products) - Removes optional admin features
4. Remove SECTION 10 (Empty State) - Will show blank instead of helpful message
5. Remove SECTION 4 (Logout) - Simplifies app bar to just title
6. Remove debug information and logging statements throughout

The core functionality (user welcome + products display) will remain intact!
Each section is clearly marked with numbered headers and difficulty indicators.
===============================================================================
*/
