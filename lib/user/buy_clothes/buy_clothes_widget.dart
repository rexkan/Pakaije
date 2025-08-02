import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend.dart';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'buy_clothes_model.dart';
export 'buy_clothes_model.dart';

class BuyClothesWidget extends StatefulWidget {
  const BuyClothesWidget({super.key});

  static String routeName = 'BuyClothes';
  static String routePath = '/buyClothes';

  @override
  State<BuyClothesWidget> createState() => _BuyClothesWidgetState();
}

class _BuyClothesWidgetState extends State<BuyClothesWidget>
    with TickerProviderStateMixin {
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
    'Dresses',
    'Outerwear',
    'Activewear',
    'Accessories',
  ];

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

  @override
  void dispose() {
    _animationController.dispose();
    _model.dispose();
    super.dispose();
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
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      _buildSearchAndFilters(),
                      _buildViewToggle(),
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
                    label: 'Home',
                    isActive: false,
                    onTap: () => context.pushNamed(HomePageWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.checkroom_rounded,
                    label: 'Wardrobe',
                    isActive: false,
                    onTap: () => context.pushNamed(MyWardrodeWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.style_rounded,
                    label: 'Match',
                    isActive: false,
                    onTap: () => context.pushNamed(OutfitMatchWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.shopping_bag_rounded,
                    label: 'Shop',
                    isActive: true, // This is the current page
                    onTap: () {
                      // Already on shop page
                    },
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.calendar_month_rounded,
                    label: 'Calendar',
                    isActive: false,
                    onTap: () =>
                        context.pushNamed(OutfitPlanner2Widget.routeName),
                  ),
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

  Widget _buildFirebaseContent() {
    return StreamBuilder<List<BrandedItemsRecord>>(
      stream: queryBrandedItemsRecord(
        queryBuilder: (brandedItemsRecord) {
          // Apply category filter if not 'All'
          if (_selectedCategory != 'All') {
            return brandedItemsRecord.where('category',
                isEqualTo: _selectedCategory);
          }
          return brandedItemsRecord.orderBy('date_added', descending: true);
        },
      ),
      builder: (context, snapshot) {
        // Handle loading state
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

        final brandedItems = snapshot.data!;

        // Handle empty state
        if (brandedItems.isEmpty) {
          return _buildEmptyState();
        }

        // Build content based on view type
        return _isGridView
            ? _buildFirebaseGrid(brandedItems)
            : _buildFirebaseList(brandedItems);
      },
    );
  }

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
                child: _buildFirebaseClothingCard(items[index]),
              ),
            );
          },
        );
      },
    );
  }

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

  Widget _buildFirebaseClothingCard(BrandedItemsRecord item) {
    return GestureDetector(
      onTap: () {
        // Convert BrandedItemsRecord to Map for navigation - FIXED DATA MAPPING
        final itemMap = {
          'documentId': item.reference.id, // Firebase document ID
          'itemId': item.itemId, // The actual item_id field from Firebase
          'name': item.name,
          'description': item.description,
          'price': '\$${item.price.toStringAsFixed(2)}',
          'imagePath': item.imageUrl, // This maps to imageUrl from Firebase
          'category': item.category,
          'productUrl': item.productUrl,
          'vendorId': item.vendorId,
          'styleTags': item.styleTags,
          'weatherSuitability': item.weatherSuitability,
        };

        // Debug print to see what we're passing
        print('Navigating with data: $itemMap');

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
            // Image Container
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

            // Content Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name
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
                  const SizedBox(height: 12.0),

                  // Price
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirebaseListCard(BrandedItemsRecord item) {
    return GestureDetector(
      onTap: () {
        // Convert BrandedItemsRecord to Map for navigation - FIXED DATA MAPPING
        final itemMap = {
          'documentId': item.reference.id, // Firebase document ID
          'itemId': item.itemId, // The actual item_id field from Firebase
          'name': item.name,
          'description': item.description,
          'price': '\$${item.price.toStringAsFixed(2)}',
          'imagePath': item.imageUrl, // This maps to imageUrl from Firebase
          'category': item.category,
          'productUrl': item.productUrl,
          'vendorId': item.vendorId,
          'styleTags': item.styleTags,
          'weatherSuitability': item.weatherSuitability,
        };

        // Debug print to see what we're passing
        print('Navigating with data: $itemMap');

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
              // Image
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

              // Content - Name only
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  ],
                ),
              ),

              // Price
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
          // Category Filter
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
          // View Toggle
          Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          Text(
            'No items found',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Try adjusting your filters',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
          const SizedBox(height: 24.0),
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

  // _buildBadge method removed as badges are no longer used
}
