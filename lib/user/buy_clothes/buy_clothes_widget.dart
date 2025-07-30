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
  final String originalPrice;
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
    this.originalPrice = '',
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
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isGridView = true;

  // Sample enhanced data
  final List<ClothingItem> _clothingItems = [
    ClothingItem(
      id: '1',
      name: 'Premium Basic Tee',
      description: 'Soft cotton blend, perfect fit',
      price: '\$24.99',
      originalPrice: '\$34.99',
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
      originalPrice: '\$65.00',
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
      originalPrice: '\$29.99',
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
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
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
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildSearchAndFilters(),
              _buildViewToggle(),
              Expanded(
                child: _isGridView ? _buildClothingGrid() : _buildClothingList(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigation(),
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
          font: GoogleFonts.interTight(),
          color: FlutterFlowTheme.of(context).white,
          fontSize: 24.0,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [],
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
              children: ['All', 'Tops', 'Bottoms', 'Outerwear', 'Dresses', 'Sweaters', 'Activewear']
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
                      color: FlutterFlowTheme.of(context).underground.withOpacity(0.3),
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            category,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
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
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Try adjusting your search or filters',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Text(
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
        // Navigate to item details with hero animation
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
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
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
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Badges
                    Positioned(
                      top: 12.0,
                      left: 12.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.isNew) _buildBadge('NEW', Colors.green),
                          if (item.isOnSale) 
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: _buildBadge('-${item.discountPercent}%', Colors.red),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Simplified Content Section
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
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                      fontSize: 16.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    item.description,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      fontSize: 12.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12.0),
                  
                  // Price Section only
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.originalPrice.isNotEmpty && item.isOnSale) ...[
                        Text(
                          item.originalPrice,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12.0,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                      ],
                      Text(
                        item.price,
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
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
          ],
        ),
      ),
    );
  }

  Widget _buildListClothingCard(ClothingItem item) {
    return Container(
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
                  ClipRRect(
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
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        );
                      },
                    ),
                  ),
                  // Badges
                  if (item.isNew || item.isOnSale)
                    Positioned(
                      top: 8.0,
                      left: 8.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.isNew) _buildBadge('NEW', Colors.green),
                          if (item.isOnSale) 
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: _buildBadge('-${item.discountPercent}%', Colors.red),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(width: 16.0),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    item.description,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Price Section only
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (item.originalPrice.isNotEmpty && item.isOnSale) ...[
                  Text(
                    item.originalPrice,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 12.0,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                ],
                Text(
                  item.price,
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
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
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 2.0,
            color: color.withOpacity(0.3),
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 85.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).underground,
            FlutterFlowTheme.of(context).underground.withOpacity(0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 12.0,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 'Home', false, () {
                context.pushNamed(HomePageWidget.routeName);
              }),
              _buildNavItem(Icons.dry_cleaning_outlined, Icons.dry_cleaning, 'Wardrobe', false, () {
                context.pushNamed(MyWardrodeWidget.routeName);
              }),
              _buildNavItem(Icons.touch_app_outlined, Icons.touch_app, 'Match', false, () {
                context.pushNamed(OutfitMatchWidget.routeName);
              }),
              _buildNavItem(Icons.shopping_cart_outlined, Icons.shopping_cart, 'Shop', true, () {
                context.pushNamed(BuyClothesWidget.routeName);
              }),
              _buildNavItem(Icons.calendar_month_outlined, Icons.calendar_month, 'Calendar', false, () {
                context.pushNamed(OutfitPlanner2Widget.routeName);
              }),
              _buildNavItem(Icons.person_outline, Icons.person, 'Profile', false, () {
                context.pushNamed(UserProfileWidget.routeName);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData outlinedIcon, IconData filledIcon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? filledIcon : outlinedIcon,
                key: ValueKey(isActive),
                color: isActive 
                    ? FlutterFlowTheme.of(context).waxFlower
                    : Colors.white.withOpacity(0.7),
                size: 24.0,
              ),
            ),
            const SizedBox(height: 4.0),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: FlutterFlowTheme.of(context).bodySmall.override(
                color: isActive 
                    ? FlutterFlowTheme.of(context).waxFlower
                    : Colors.white.withOpacity(0.7),
                fontSize: 11.0,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}