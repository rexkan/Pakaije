import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_details_page_model.dart';
export 'product_details_page_model.dart';

// Import the ClothingItem class from buy_clothes_widget
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

class ProductDetailsPageWidget extends StatefulWidget {
  const ProductDetailsPageWidget({super.key});

  static String routeName = 'ProductDetailsPage';
  static String routePath = '/productDetailsPage';

  @override
  State<ProductDetailsPageWidget> createState() =>
      _ProductDetailsPageWidgetState();
}

class _ProductDetailsPageWidgetState extends State<ProductDetailsPageWidget>
    with TickerProviderStateMixin {
  late ProductDetailsPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // This will hold the passed ClothingItem data
  ClothingItem? _selectedItem;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductDetailsPageModel());

    animationsMap.addAll({
      'imageOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.8, 0.8),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation': AnimationInfo(
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
            begin: Offset(0.0, 30.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation': AnimationInfo(
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the passed data from FlutterFlow navigation
    final routeSettings = ModalRoute.of(context)?.settings;

    // Try to get from FlutterFlow's extra parameter first
    if (context.mounted) {
      try {
        final extra = GoRouterState.of(context).extra;
        if (extra != null && extra is ClothingItem) {
          _selectedItem = extra;
        }
      } catch (e) {
        // Fallback to route arguments
        if (routeSettings?.arguments != null &&
            routeSettings!.arguments is ClothingItem) {
          _selectedItem = routeSettings.arguments as ClothingItem;
        }
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Get item data (use passed item or fallback to default)
  ClothingItem get _currentItem {
    return _selectedItem ??
        ClothingItem(
          id: '1',
          name: 'Basic Tees',
          description: '100% Suprima Cotton, 260gsm, Enzyme wash',
          price: '\$50.00',
          imagePath: 'assets/images/basic_black_tee.jpg',
          colors: ['Black', 'White', 'Gray'],
          sizes: ['S', 'M', 'L', 'XL'],
          category: 'Tops',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: _buildAppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(),
                  _buildProductInfo(),
                  _buildProductDescription(),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
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
        'Product Details',
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
              color: FlutterFlowTheme.of(context).white,
              fontSize: 20.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: true,
      elevation: 2.0,
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
              child: Hero(
                tag: 'item-${_currentItem.id}',
                transitionOnUserGestures: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    _currentItem.imagePath,
                    width: 350.0,
                    height: 350.0,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 350.0,
                        height: 350.0,
                        color: FlutterFlowTheme.of(context).alternate,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 60.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // Badges
          if (_currentItem.isNew || _currentItem.isOnSale)
            Positioned(
              top: 40.0,
              left: 30.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentItem.isNew) _buildBadge('NEW', Colors.green),
                  if (_currentItem.isOnSale)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: _buildBadge(
                          '-${_currentItem.discountPercent}%', Colors.red),
                    ),
                ],
              ),
            ),
        ],
      ),
    ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation']!);
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand (if available)
          if (_currentItem.brand.isNotEmpty) ...[
            Text(
              _currentItem.brand.toUpperCase(),
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    color: FlutterFlowTheme.of(context).underground,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
            ),
            const SizedBox(height: 8.0),
          ],

          // Product Name
          Text(
            _currentItem.name,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.interTight(),
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation']!),

          const SizedBox(height: 12.0),

          // Rating (if available)
          if (_currentItem.rating > 0) ...[
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < _currentItem.rating.floor()
                        ? Icons.star
                        : index < _currentItem.rating
                            ? Icons.star_half
                            : Icons.star_border,
                    size: 20.0,
                    color: Colors.amber,
                  );
                }),
                const SizedBox(width: 8.0),
                Text(
                  '${_currentItem.rating} (${_currentItem.reviewCount} reviews)',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14.0,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
          ],

          // Price
          Row(
            children: [
              if (_currentItem.originalPrice.isNotEmpty &&
                  _currentItem.isOnSale) ...[
                Text(
                  _currentItem.originalPrice,
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 20.0,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
                const SizedBox(width: 12.0),
              ],
              Text(
                _currentItem.price,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.interTight(),
                      color: FlutterFlowTheme.of(context).underground,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),

          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _buildProductDescription() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
          ),
          const SizedBox(height: 12.0),
          Text(
            _currentItem.description.isNotEmpty
                ? _currentItem.description
                : '100% Suprima Cotton, 260gsm, Enzyme wash. This premium basic tee offers exceptional comfort and durability with a perfect fit.',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 16.0,
                  letterSpacing: 0.2,
                  fontWeight:
                      FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
          ),
        ],
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
  }

  Widget _buildBottomActions() {
    return Material(
      color: Colors.transparent,
      elevation: 8.0,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.fromSTEB(24.0, 20.0, 24.0, 34.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0.0, -4.0),
            )
          ],
        ),
        child: Row(
          children: [
            // Copy Promo Code Button
            Expanded(
              flex: 1,
              child: FFButtonWidget(
                onPressed: () {
                  _copyPromoCode();
                },
                text: 'Promo Code',
                icon: Icon(
                  Icons.local_offer_outlined,
                  size: 25.0,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                options: FFButtonOptions(
                  height: 56.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                  color: FlutterFlowTheme.of(context).alternate,
                  textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.interTight(),
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                      ),
                  elevation: 3.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(28.0),
                ),
              ),
            ),

            const SizedBox(width: 16.0),

            // Copy Product Link Button
            Expanded(
              flex: 1,
              child: FFButtonWidget(
                onPressed: () {
                  _copyProductLink();
                },
                text: 'Product Link',
                icon: Icon(
                  Icons.link,
                  size: 25.0,
                  color: Colors.white,
                ),
                options: FFButtonOptions(
                  height: 56.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                  color: FlutterFlowTheme.of(context).underground,
                  textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.interTight(),
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                      ),
                  elevation: 3.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(28.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: color.withOpacity(0.3),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _copyPromoCode() {
    // Generate or use a promo code for this product
    String promoCode = 'SAVE20${_currentItem.id.toUpperCase()}';

    Clipboard.setData(ClipboardData(text: promoCode));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.local_offer,
              color: Colors.white,
              size: 24.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Promo Code Copied!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    promoCode,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.0,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _copyProductLink() {
    // Generate a product link
    String productLink = 'https://yourstore.com/products/${_currentItem.id}';

    Clipboard.setData(ClipboardData(text: productLink));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.link,
              color: Colors.white,
              size: 24.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Product Link Copied!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'Share this ${_currentItem.name} with others',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'SHARE MORE',
          textColor: Colors.white,
          onPressed: () {
            // Open share sheet or additional sharing options
          },
        ),
      ),
    );
  }
}
