import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'buy_clothes_model.dart';
export 'buy_clothes_model.dart';

// Enhanced data model for clothing items
class ClothingItem {
  final String id;
  final String name;
  final String description;
  final String price;
  final String imagePath;
  final List<String> colors;
  final List<String> sizes;
  final double rating;
  final int reviewCount;
  final String category;
  final bool isNew;
  final bool isOnSale;
  final int discountPercent;
  final String brand;

  ClothingItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    this.colors = const [],
    this.sizes = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.category = 'All',
    this.isNew = false,
    this.isOnSale = false,
    this.discountPercent = 0,
    this.brand = '',
  });
}

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

  // Sample enhanced data - removed originalPrice from the constructor calls
  final List<ClothingItem> _clothingItems = [
    ClothingItem(
      id: '1',
      name: 'Premium Basic Tee',
      description: 'Soft cotton blend, perfect fit',
      price: '\$24.99',
      imagePath: 'assets/images/basic_black_tee.jpg',
      colors: ['Black', 'White', 'Gray', 'Navy'],
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      rating: 4.8,
      reviewCount: 234,
      category: 'Tops',
      isOnSale: true,
      discountPercent: 30,
      brand: 'StyleCo',
    ),
    ClothingItem(
      id: '2',
      name: 'Vintage Denim Jacket',
      description: 'Classic American style, distressed finish',
      price: '\$89.99',
      imagePath: 'assets/images/denim_jacket.jpg',
      colors: ['Blue', 'Black', 'Light Blue'],
      sizes: ['S', 'M', 'L', 'XL'],
      rating: 4.9,
      reviewCount: 156,
      category: 'Outerwear',
      isNew: true,
      brand: 'DenimCraft',
    ),
    ClothingItem(
      id: '3',
      name: 'Floral Summer Dress',
      description: 'Lightweight, breathable fabric',
      price: '\$45.00',
      imagePath: 'assets/images/summer_dress.jpg',
      colors: ['Floral Print', 'Solid White', 'Coral'],
      sizes: ['XS', 'S', 'M', 'L'],
      rating: 4.6,
      reviewCount: 89,
      category: 'Dresses',
      isOnSale: true,
      discountPercent: 31,
      brand: 'FloralFashion',
    ),
    ClothingItem(
      id: '4',
      name: 'Slim Fit Chinos',
      description: 'Versatile cotton chinos for any occasion',
      price: '\$39.99',
      imagePath: 'assets/images/chinos.jpg',
      colors: ['Khaki', 'Navy', 'Black', 'Olive'],
      sizes: ['28', '30', '32', '34', '36'],
      rating: 4.7,
      reviewCount: 198,
      category: 'Bottoms',
      brand: 'ClassicFit',
    ),
    ClothingItem(
      id: '5',
      name: 'Luxury Cashmere Sweater',
      description: 'Ultra-soft premium cashmere',
      price: '\$199.99',
      imagePath: 'assets/images/cashmere_sweater.jpg',
      colors: ['Cream', 'Gray', 'Black'],
      sizes: ['S', 'M', 'L'],
      rating: 5.0,
      reviewCount: 67,
      category: 'Sweaters',
      isNew: true,
      brand: 'LuxeWear',
    ),
    ClothingItem(
      id: '6',
      name: 'Athletic Performance Shorts',
      description: 'Moisture-wicking, quick-dry technology',
      price: '\$19.99',
      imagePath: 'assets/images/athletic_shorts.jpg',
      colors: ['Black', 'Gray', 'Navy', 'Red'],
      sizes: ['S', 'M', 'L', 'XL'],
      rating: 4.4,
      reviewCount: 312,
      category: 'Activewear',
      isOnSale: true,
      discountPercent: 33,
      brand: 'SportFlex',
    ),
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

  List<ClothingItem> get _filteredItems {
    return _clothingItems.where((item) {
      final matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      return matchesCategory;
    }).toList();
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
                        child: _isGridView
                            ? _buildClothingGrid()
                            : _buildClothingList(),
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
          // Enhanced Category Filter only
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                'All',
                'Tops',
                'Bottoms',
                'Shoes',
              ].map((category) => _buildCategoryChip(category)).toList(),
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

  Widget _buildClothingGrid() {
    final filteredItems = _filteredItems;

    if (filteredItems.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildEnhancedClothingCard(filteredItems[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildClothingList() {
    final filteredItems = _filteredItems;

    if (filteredItems.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(50 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: _buildListClothingCard(filteredItems[index]),
              ),
            );
          },
        );
      },
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

  Widget _buildEnhancedClothingCard(ClothingItem item) {
    return GestureDetector(
      onTap: () {
        // Convert ClothingItem to Map for FlutterFlow navigation
        final itemMap = {
          'id': item.id,
          'name': item.name,
          'description': item.description,
          'price': item.price,
          'imagePath': item.imagePath,
          'colors': item.colors,
          'sizes': item.sizes,
          'rating': item.rating,
          'reviewCount': item.reviewCount,
          'category': item.category,
          'isNew': item.isNew,
          'isOnSale': item.isOnSale,
          'discountPercent': item.discountPercent,
          'brand': item.brand,
        };

        context.pushNamed(
          'ProductDetailsPage',
          extra: itemMap,
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
            // Enhanced Image Container
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
                child: Stack(
                  children: [
                    Hero(
                      tag: 'item-${item.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        child: Image.asset(
                          item.imagePath,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: FlutterFlowTheme.of(context).alternate,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40.0,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Badges removed
                  ],
                ),
              ),
            ),

            // Content Section - Simplified to show only name and single price
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name only
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

                  // Single Price - No original price comparison
                  Text(
                    item.price,
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

  Widget _buildListClothingCard(ClothingItem item) {
    return GestureDetector(
      onTap: () {
        // Convert ClothingItem to Map for FlutterFlow navigation
        final itemMap = {
          'id': item.id,
          'name': item.name,
          'description': item.description,
          'price': item.price,
          'imagePath': item.imagePath,
          'colors': item.colors,
          'sizes': item.sizes,
          'rating': item.rating,
          'reviewCount': item.reviewCount,
          'category': item.category,
          'isNew': item.isNew,
          'isOnSale': item.isOnSale,
          'discountPercent': item.discountPercent,
          'brand': item.brand,
        };

        context.pushNamed(
          'ProductDetailsPage',
          extra: itemMap,
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
                child: Stack(
                  children: [
                    Hero(
                      tag: 'item-${item.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          item.imagePath,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: FlutterFlowTheme.of(context).alternate,
                              child: Icon(
                                Icons.image_not_supported,
                                size: 30.0,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Badges removed
                  ],
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

              // Single Price - No original price comparison
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.price,
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

  // _buildBadge method removed as badges are no longer used
}
