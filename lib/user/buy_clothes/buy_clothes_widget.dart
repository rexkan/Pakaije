import 'package:firebase_auth/firebase_auth.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'buy_clothes_model.dart';
export 'buy_clothes_model.dart';
import '/auth/firebase_auth/auth_util.dart';

// ============================================================================
// MAIN WIDGET CLASS - BuyClothesWidget
// ============================================================================
class BuyClothesWidget extends StatefulWidget {
  const BuyClothesWidget({super.key});

  static String routeName = 'BuyClothes';
  static String routePath = '/buyClothes';

  @override
  State<BuyClothesWidget> createState() => _BuyClothesWidgetState();
}

// ============================================================================
// STATE CLASS - Contains all state management and UI logic
// ============================================================================
class _BuyClothesWidgetState extends State<BuyClothesWidget>
    with TickerProviderStateMixin {
  
  // ----------------------------------------------------------------------------
  // STATE VARIABLES SECTION
  // ----------------------------------------------------------------------------
  late BuyClothesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Search and filter state
  String _selectedCategory = 'All';
  bool _isGridView = true;

  // Available categories - you can customize these based on your Firebase data
  final List<String> _categories = [
    'All',
    'Tops',
    'Bottoms',
    'Shoes',
  ];

  // ----------------------------------------------------------------------------
  // INITIALIZATION SECTION
  // ----------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BuyClothesModel());
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  // ----------------------------------------------------------------------------
  // CLEANUP SECTION
  // ----------------------------------------------------------------------------
  @override
  void dispose() {
    _animationController.dispose();
    _model.dispose();
    super.dispose();
  }

  // ============================================================================
  // MAIN BUILD METHOD - Contains the overall page structure
  // ============================================================================
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
        
        // ----------------------------------------------------------------------------
        // APP BAR SECTION
        // ----------------------------------------------------------------------------
        appBar: _buildAppBar(),
        
        // ----------------------------------------------------------------------------
        // MAIN BODY SECTION
        // ----------------------------------------------------------------------------
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Search and Filter Section
                      _buildSearchAndFilters(),
                      
                      // View Toggle Section (Grid/List Toggle)
                      _buildViewToggle(),
                      
                      // Main Content Section (Firebase Data Display)
                      Expanded(
                        child: _buildFirebaseContent(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // ----------------------------------------------------------------------------
        // BOTTOM NAVIGATION BAR SECTION
        // ----------------------------------------------------------------------------
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
                  // Home Navigation Item
                  _buildNavItem(
                    context: context,
                    icon: Icons.home_rounded,
                    label: 'Home',
                    isActive: false,
                    onTap: () => context.pushNamed(HomePageWidget.routeName),
                  ),
                  
                  // Wardrobe Navigation Item
                  _buildNavItem(
                    context: context,
                    icon: Icons.checkroom_rounded,
                    label: 'Wardrobe',
                    isActive: false,
                    onTap: () => context.pushNamed(MyWardrodeWidget.routeName),
                  ),
                  
                  // Match Navigation Item
                  _buildNavItem(
                    context: context,
                    icon: Icons.style_rounded,
                    label: 'Match',
                    isActive: false,
                    onTap: () => context.pushNamed(OutfitMatchWidget.routeName),
                  ),
                  
                  // Shop Navigation Item (Current Active Page)
                  _buildNavItem(
                    context: context,
                    icon: Icons.shopping_bag_rounded,
                    label: 'Shop',
                    isActive: true, // This is the current page
                    onTap: () {
                      // Already on shop page
                    },
                  ),
                  
                  // Calendar Navigation Item
                  _buildNavItem(
                    context: context,
                    icon: Icons.calendar_month_rounded,
                    label: 'Calendar',
                    isActive: false,
                    onTap: () =>
                        context.pushNamed(OutfitPlanner2Widget.routeName),
                  ),
                  
                  // Profile Navigation Item
                  _buildNavItem(
                    context: context,
                    icon: Icons.person_rounded,
                    label: 'Profile',
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

  // ============================================================================
  // FIREBASE CONTENT SECTION - Handles data fetching and display
  // ============================================================================
  Widget _buildFirebaseContent() {
    return StreamBuilder<List<BrandedItemsRecord>>(
      stream: queryBrandedItemsRecord(
        queryBuilder: (brandedItemsRecord) {
          var query = brandedItemsRecord;

          // Apply category filter if not 'All'
          if (_selectedCategory != 'All') {
            query = query.where('category', isEqualTo: _selectedCategory);
          }

          return query.orderBy('date_added', descending: true);
        },
      ),
      builder: (context, snapshot) {
        
        // ----------------------------------------------------------------------------
        // LOADING STATE WIDGET
        // ----------------------------------------------------------------------------
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).underground,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Loading products...',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ],
            ),
          );
        }

        List<BrandedItemsRecord> allItems = snapshot.data!;

        // ----------------------------------------------------------------------------
        // FILTERED ITEMS FUTURE BUILDER
        // ----------------------------------------------------------------------------
        return FutureBuilder<List<BrandedItemsRecord>>(
          future: _filterRemovedItems(allItems),
          builder: (context, filteredSnapshot) {
            if (!filteredSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).underground,
                  ),
                ),
              );
            }

            List<BrandedItemsRecord> brandedItems = filteredSnapshot.data!;

            // Empty State Check
            if (brandedItems.isEmpty) {
              return _buildEmptyState();
            }

            // Build content based on view type (Grid or List)
            return _isGridView
                ? _buildFirebaseGrid(brandedItems)
                : _buildFirebaseList(brandedItems);
          },
        );
      },
    );
  }

  // ============================================================================
  // HELPER METHODS SECTION
  // ============================================================================
  
  // ----------------------------------------------------------------------------
  // FILTER REMOVED ITEMS METHOD - Async filtering of unavailable items
  // ----------------------------------------------------------------------------
  Future<List<BrandedItemsRecord>> _filterRemovedItems(
      List<BrandedItemsRecord> items) async {
    List<BrandedItemsRecord> filteredItems = [];

    for (BrandedItemsRecord item in items) {
      try {
        // Check the current status of each item
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('branded_items')
            .doc(item.reference.id)
            .get();

        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String status = data['status'] ?? '';

          // Only include items that haven't been removed
          if (status != 'removed_for_violation' &&
              status != 'deleted' &&
              status != 'hidden' &&
              status != 'inactive') {
            filteredItems.add(item);
          } else {
            print('🚫 Filtered out item: ${item.name} (status: $status)');
          }
        } else {
          // If document doesn't exist, don't include it
          print('🚫 Document not found for item: ${item.name}');
          continue;
        }
      } catch (e) {
        print('Error checking item status: $e');
        // If there's an error, include the item to be safe
        filteredItems.add(item);
      }
    }

    print(
        '📦 Filtered ${items.length} items down to ${filteredItems.length} available items');
    return filteredItems;
  }

  // ============================================================================
  // GRID VIEW SECTION - Displays items in grid format
  // ============================================================================
  Widget _buildFirebaseGrid(List<BrandedItemsRecord> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildEnhancedProductCard(items[index]),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================================
  // LIST VIEW SECTION - Displays items in list format
  // ============================================================================
  Widget _buildFirebaseList(List<BrandedItemsRecord> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(50 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: _buildFirebaseListCard(items[index]),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================================
  // PRODUCT CARD WIDGET SECTION - Grid view item card
  // ============================================================================
  Widget _buildEnhancedProductCard(BrandedItemsRecord item) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'ProductDetailsPage',
          queryParameters: {
            'documentId': item.reference.id,
            'itemId': item.itemId,
            'name': item.name,
            'description': item.description,
            'price': item.price.toString(),
            'imageUrl': item.imageUrl,
            'category': item.category,
            'productUrl': item.productUrl,
            'vendorId': item.vendorId,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 12.0,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // ----------------------------------------------------------------------------
            // PRODUCT IMAGE SECTION
            // ----------------------------------------------------------------------------
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Hero(
                  tag:
                      'item-${item.itemId.isNotEmpty ? item.itemId : item.reference.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    child: item.imageUrl.isNotEmpty
                        ? Image.network(
                            item.imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: FlutterFlowTheme.of(context).alternate,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).underground,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: FlutterFlowTheme.of(context).alternate,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 40.0,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              Icons.image_not_supported,
                              size: 40.0,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                  ),
                ),
              ),
            ),

            // ----------------------------------------------------------------------------
            // PRODUCT INFORMATION SECTION
            // ----------------------------------------------------------------------------
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  // Product Name
                  Text(
                    item.name,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0,
                          fontSize: 16.0,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),

                  // Product Price
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          color: FlutterFlowTheme.of(context).underground,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.0,
                        ),
                  ),

                  const SizedBox(height: 8.0),

                  // Product Category
                  Text(
                    item.category,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
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

  // ============================================================================
  // LIST CARD WIDGET SECTION - List view item card
  // ============================================================================
  Widget _buildFirebaseListCard(BrandedItemsRecord item) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'ProductDetailsPage',
          queryParameters: {
            'documentId': item.reference.id,
            'itemId': item.itemId,
            'name': item.name,
            'description': item.description,
            'price': item.price.toString(),
            'imageUrl': item.imageUrl,
            'category': item.category,
            'productUrl': item.productUrl,
            'vendorId': item.vendorId,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              
              // ----------------------------------------------------------------------------
              // LIST ITEM IMAGE SECTION
              // ----------------------------------------------------------------------------
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Hero(
                  tag:
                      'item-${item.itemId.isNotEmpty ? item.itemId : item.reference.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: item.imageUrl.isNotEmpty
                        ? Image.network(
                            item.imageUrl,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: FlutterFlowTheme.of(context).alternate,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).underground,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: FlutterFlowTheme.of(context).alternate,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 30.0,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              Icons.image_not_supported,
                              size: 30.0,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(width: 16.0),

              // ----------------------------------------------------------------------------
              // LIST ITEM CONTENT SECTION
              // ----------------------------------------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Name
                    Text(
                      item.name,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.0,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    
                    // Item Category
                    Text(
                      item.category,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                    ),
                  ],
                ),
              ),

              // ----------------------------------------------------------------------------
              // LIST ITEM PRICE SECTION
              // ----------------------------------------------------------------------------
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          color: FlutterFlowTheme.of(context).underground,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // NAVIGATION ITEM WIDGET SECTION - Bottom navigation bar items
  // ============================================================================
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
            
            // Navigation Icon
            Icon(
              icon,
              size: 24.0,
              color: isActive
                  ? FlutterFlowTheme.of(context).waxFlower
                  : FlutterFlowTheme.of(context).info,
            ),
            SizedBox(height: 4.0),
            
            // Navigation Label
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

  // ============================================================================
  // APP BAR WIDGET SECTION - Top app bar with title and back button
  // ============================================================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: FlutterFlowTheme.of(context).underground,
      automaticallyImplyLeading: false,
      
      // Back Button
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
      
      // App Bar Title
      title: Text(
        FFLocalizations.of(context).getText(
          'w55wjj9s' /* Trending Items */,
        ),
        style: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: GoogleFonts.interTight().fontFamily,
              color: FlutterFlowTheme.of(context).white,
              fontSize: 24.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: const [],
      centerTitle: true,
      elevation: 2.0,
    );
  }

  // ============================================================================
  // SEARCH AND FILTERS WIDGET SECTION - Category filter chips
  // ============================================================================
  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          
          // ----------------------------------------------------------------------------
          // CATEGORY FILTER SECTION
          // ----------------------------------------------------------------------------
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories
                  .map((category) => _buildCategoryChip(category))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // CATEGORY CHIP WIDGET SECTION - Individual filter chip
  // ============================================================================
  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).underground,
                      FlutterFlowTheme.of(context).underground.withOpacity(0.8),
                    ],
                  )
                : null,
            color: isSelected
                ? null
                : FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              color: isSelected
                  ? FlutterFlowTheme.of(context).underground
                  : FlutterFlowTheme.of(context).alternate,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      blurRadius: 8.0,
                      color: FlutterFlowTheme.of(context)
                          .underground
                          .withOpacity(0.3),
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            category,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: isSelected
                      ? Colors.white
                      : FlutterFlowTheme.of(context).primaryText,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.5,
                ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // VIEW TOGGLE WIDGET SECTION - Grid/List view switcher
  // ============================================================================
  Widget _buildViewToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        border: Border(
          bottom: BorderSide(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          
          // ----------------------------------------------------------------------------
          // VIEW TOGGLE BUTTONS SECTION
          // ----------------------------------------------------------------------------
          Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
                
                // Grid View Toggle Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isGridView = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: _isGridView
                          ? FlutterFlowTheme.of(context).underground
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Icon(
                      Icons.grid_view,
                      size: 20.0,
                      color: _isGridView
                          ? Colors.white
                          : FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ),
                
                // List View Toggle Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isGridView = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: !_isGridView
                          ? FlutterFlowTheme.of(context).underground
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Icon(
                      Icons.list,
                      size: 20.0,
                      color: !_isGridView
                          ? Colors.white
                          : FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // EMPTY STATE WIDGET SECTION - Displayed when no items are found
  // ============================================================================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          // ----------------------------------------------------------------------------
          // EMPTY STATE ICON SECTION
          // ----------------------------------------------------------------------------
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 64.0,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          const SizedBox(height: 24.0),
          
          // ----------------------------------------------------------------------------
          // EMPTY STATE TITLE SECTION
          // ----------------------------------------------------------------------------
          Text(
            'No items found',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8.0),
          
          // ----------------------------------------------------------------------------
          // EMPTY STATE SUBTITLE SECTION
          // ----------------------------------------------------------------------------
          Text(
            'Try adjusting your filters',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
          const SizedBox(height: 24.0),
          
          // ----------------------------------------------------------------------------
          // CLEAR FILTERS BUTTON SECTION
          // ----------------------------------------------------------------------------
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedCategory = 'All';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).underground,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text(
              'Clear Filters',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}