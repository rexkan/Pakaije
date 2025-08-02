import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/schema/structs/index.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'product_details_page_model.dart';
export 'product_details_page_model.dart';

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

  // This will hold the passed product data
  Map<String, dynamic>? _productData;

  // Report dialog controller
  final TextEditingController _reportReasonController = TextEditingController();

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

    // Get the passed data - FIXED TO USE QUERY PARAMETERS
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Try to get data from query parameters (FlutterFlow method)
      final state = GoRouterState.of(context);
      final queryParams = state.uri.queryParameters;

      print('Query parameters: $queryParams'); // Debug print

      if (queryParams.isNotEmpty) {
        setState(() {
          _productData = {
            'documentId': queryParams['documentId'] ?? '',
            'itemId': queryParams['itemId'] ?? '',
            'name': queryParams['name'] ?? '',
            'description': queryParams['description'] ?? '',
            'price': queryParams['price'] ?? '0.00',
            'imagePath': queryParams['imageUrl'] ?? '',
            'category': queryParams['category'] ?? '',
            'productUrl': queryParams['productUrl'] ?? '',
            'vendorId': queryParams['vendorId'] ?? '',
          };
        });
        print(
            'Product data set from query params: $_productData'); // Debug print
      } else {
        // Fallback to arguments method
        final args = ModalRoute.of(context)?.settings.arguments;
        print('Fallback - Received arguments: $args'); // Debug print
        if (args != null && args is Map<String, dynamic>) {
          setState(() {
            _productData = args;
          });
          print(
              'Product data set from arguments: $_productData'); // Debug print
        } else {
          print('No data received via any method'); // Debug print
        }
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _reportReasonController.dispose();
    super.dispose();
  }

  // Helper methods to safely get product data with null safety
  String get documentId => _productData?['documentId']?.toString() ?? '';
  String get productId =>
      _productData?['itemId']?.toString() ??
      _productData?['documentId']?.toString() ??
      '';
  String get productName => _productData?['name']?.toString() ?? 'Product Name';
  String get productDescription =>
      _productData?['description']?.toString() ?? 'No description available';
  String get productPrice => _productData?['price']?.toString() ?? '\$0.00';
  String get productImageUrl => _productData?['imagePath']?.toString() ?? '';
  String get productCategory => _productData?['category']?.toString() ?? '';
  String get productUrl => _productData?['productUrl']?.toString() ?? '';
  String get vendorId => _productData?['vendorId']?.toString() ?? '';

  List<String> get styleTags {
    if (_productData?['styleTags'] != null) {
      final tags = _productData!['styleTags'];
      if (tags is List) {
        return tags.map((e) => e.toString()).toList();
      }
    }
    return [];
  }

  List<String> get weatherSuitability {
    if (_productData?['weatherSuitability'] != null) {
      final weather = _productData!['weatherSuitability'];
      if (weather is List) {
        return weather.map((e) => e.toString()).toList();
      }
    }
    return [];
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
                  if (styleTags.isNotEmpty) _buildStyleTags(),
                  if (weatherSuitability.isNotEmpty) _buildWeatherInfo(),
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
              fontFamily: GoogleFonts.inter().fontFamily,
              color: FlutterFlowTheme.of(context).white,
              fontSize: 20.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: true,
      elevation: 2.0,
      actions: [
        FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.flag_outlined,
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () {
            _showReportDialog();
          },
        ),
      ],
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
          child: Hero(
            tag: 'item-$productId',
            transitionOnUserGestures: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: productImageUrl.isNotEmpty
                  ? Image.network(
                      productImageUrl,
                      width: 350.0,
                      height: 350.0,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 350.0,
                          height: 350.0,
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
                    )
                  : Container(
                      width: 350.0,
                      height: 350.0,
                      color: FlutterFlowTheme.of(context).alternate,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 60.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
            ),
          ),
        ),
      ),
    ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation']!);
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category and Product ID
          if (productCategory.isNotEmpty || productId.isNotEmpty) ...[
            Row(
              children: [
                if (productCategory.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .underground
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context)
                            .underground
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      productCategory.toUpperCase(),
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            color: FlutterFlowTheme.of(context).underground,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
                if (productId.isNotEmpty)
                  Text(
                    'ID: $productId',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'monospace',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0,
                        ),
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
          ],

          // Product Name
          Text(
            productName,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation']!),

          const SizedBox(height: 16.0),

          // Price
          Text(
            productPrice,
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  color: FlutterFlowTheme.of(context).underground,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0,
                ),
          ),

          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _buildProductDescription() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
          ),
          const SizedBox(height: 12.0),
          Text(
            productDescription,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 16.0,
                  letterSpacing: 0.2,
                ),
          ),
        ],
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
  }

  Widget _buildStyleTags() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Style Tags',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: styleTags
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weather Suitability',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: weatherSuitability
                .map((weather) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .underground
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context)
                              .underground
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getWeatherIcon(weather),
                            size: 16.0,
                            color: FlutterFlowTheme.of(context).underground,
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            weather,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  color:
                                      FlutterFlowTheme.of(context).underground,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String weather) {
    switch (weather.toLowerCase()) {
      case 'summer':
      case 'hot':
        return Icons.wb_sunny;
      case 'winter':
      case 'cold':
        return Icons.ac_unit;
      case 'rain':
      case 'rainy':
        return Icons.umbrella;
      case 'spring':
      case 'fall':
      case 'autumn':
        return Icons.park;
      default:
        return Icons.wb_cloudy;
    }
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
                        fontFamily: GoogleFonts.interTight().fontFamily,
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

            // Visit Store Button
            Expanded(
              flex: 1,
              child: FFButtonWidget(
                onPressed: () {
                  _openProductUrl();
                },
                text: 'Visit Store',
                icon: Icon(
                  Icons.open_in_new,
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
                        fontFamily: GoogleFonts.interTight().fontFamily,
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

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Row(
            children: [
              Icon(
                Icons.flag,
                color: Colors.red,
                size: 28.0,
              ),
              const SizedBox(width: 12.0),
              Text(
                'Report Content',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: GoogleFonts.interTight().fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Name = ',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                    ),
                    Expanded(
                      child: Text(
                        productName,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                              fontSize: 16.0,
                            ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),

                // Item ID
                if (productId.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item ID = ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                      ),
                      Text(
                        productId,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'monospace',
                              fontSize: 16.0,
                              color: FlutterFlowTheme.of(context).underground,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],

                // Vendor ID (if available)
                if (vendorId.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vendor ID = ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                      ),
                      Text(
                        vendorId,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'monospace',
                              fontSize: 16.0,
                              color: FlutterFlowTheme.of(context).underground,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],

                // Reason
                Text(
                  'Reason',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _reportReasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        'Please describe why you are reporting this product...',
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).underground,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    contentPadding: const EdgeInsets.all(16.0),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _reportReasonController.clear();
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _submitReport();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
              ),
              child: Text(
                'Submit Report',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submitReport() async {
    if (_reportReasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide a reason for reporting.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );
      return;
    }

    try {
      // Show loading indicator
      Navigator.of(context).pop(); // Close the dialog first

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12.0),
              Text(
                'Submitting report...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          backgroundColor: FlutterFlowTheme.of(context).underground,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Generate a unique report ID
      final reportId = DateTime.now().millisecondsSinceEpoch.toString();

      // Get current user ID (assuming you have authentication set up)
      final currentUserId = currentUserUid ?? 'anonymous';

      // Create the report data
      final reportData = createContentReportsRecordData(
        reportId: reportId,
        itemId: productId,
        reporterId: currentUserId,
        reason: _reportReasonController.text.trim(),
        status: 'pending', // Initial status
        timestamp: getCurrentTimestamp,
      );

      // Add to Firestore
      await ContentReportsRecord.collection.add(reportData);

      // Clear the text field
      _reportReasonController.clear();

      // Remove loading snackbar and show success message
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
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
                      'Report Submitted Successfully',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'Thank you for helping keep our community safe.',
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
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          duration: const Duration(seconds: 4),
        ),
      );

      print('Report submitted successfully:');
      print('Report ID: $reportId');
      print('Item ID: $productId');
      print('Reporter ID: $currentUserId');
      print('Reason: ${_reportReasonController.text.trim()}');
    } catch (e) {
      print('Error submitting report: $e');

      // Clear the text field even on error
      _reportReasonController.clear();

      // Remove loading snackbar and show error message
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error,
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
                      'Failed to Submit Report',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'Please try again later.',
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
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // ✅ UPDATED: Enhanced _copyPromoCode method with usage_count increment
  void _copyPromoCode() async {
    final currentVendorId = vendorId;

    if (currentVendorId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Vendor information not available for promo code lookup.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );
      return;
    }

    print('\n🔥 === STARTING _copyPromoCode ===');
    print('📋 Searching promo codes for vendor: $currentVendorId');
    print('👤 Current User ID: $currentUserUid');

    try {
      // Check authentication
      if (currentUserUid == null || currentUserUid.isEmpty) {
        print('❌ CRITICAL: User not authenticated');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please log in to use promo codes'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12.0),
              Text(
                'Finding promo codes...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          backgroundColor: FlutterFlowTheme.of(context).underground,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      // Query for active promo codes for this vendor
      print('\n🔍 Searching for promo codes...');
      final promoQuery = await FirebaseFirestore.instance
          .collection('discount_codes')
          .where('vendor_id', isEqualTo: currentVendorId)
          .where('is_active', isEqualTo: true)
          .limit(1)
          .get();

      print('Query completed. Found ${promoQuery.docs.length} documents');

      // Remove loading snackbar
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      if (promoQuery.docs.isEmpty) {
        print('❌ No active promo codes found for vendor: $currentVendorId');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No promo codes available for this vendor.'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        );
        return;
      }

      final promoDoc = promoQuery.docs.first;
      final promoDocumentId = promoDoc.id;
      final currentData = promoDoc.data();

      print('✅ Found promo code document');
      print('📄 Document ID: $promoDocumentId');
      print('📊 Current document data: $currentData');

      // Validate promo code
      if (!_isPromoCodeValid(currentData, DateTime.now())) {
        print('❌ Promo code validation failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Promo code found but is expired or reached usage limit.'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        );
        return;
      }

      print('✅ Promo code is valid');

      final promoCode = currentData['code'] ?? '';
      final discountType = currentData['discount_type'] ?? 'percentage';
      final discountValue =
          (currentData['discount_value'] as num?)?.toDouble() ?? 0.0;

      if (promoCode.isEmpty) {
        print('❌ Promo code field is empty');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Promo code found but code is empty.'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        );
        return;
      }

      // Copy to clipboard
      print('\n📋 Copying promo code to clipboard: $promoCode');
      await Clipboard.setData(ClipboardData(text: promoCode));

      // Increment usage count
      print('\n📈 Incrementing usage count...');
      final docRef = FirebaseFirestore.instance
          .collection('discount_codes')
          .doc(promoDocumentId);

      await docRef.update({
        'usage_count': FieldValue.increment(1),
      });

      print('✅ Usage count incremented successfully');

      // Determine discount text
      String discountText;
      if (discountType == 'percentage') {
        discountText = '${discountValue.toInt()}% OFF';
      } else if (discountType == 'fixed') {
        discountText = '\$${discountValue.toStringAsFixed(2)} OFF';
      } else {
        discountText = 'DISCOUNT APPLIED';
      }

      // Show success message
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
                      'Promo Code Copied! 🎉',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      '$promoCode - $discountText',
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
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          duration: const Duration(seconds: 4),
        ),
      );

      print('🎉 === _copyPromoCode COMPLETED SUCCESSFULLY ===\n');
    } catch (e, stackTrace) {
      print('\n💥 === _copyPromoCode FAILED ===');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Error message: $e');
      print('📍 Stack trace: $stackTrace');

      // Remove loading snackbar
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text('Failed to copy promo code: ${e.toString()}'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      print('💥 === _copyPromoCode ERROR END ===\n');
    }
  }

  // ✅ NEW: Promo code validation method
  bool _isPromoCodeValid(Map<String, dynamic> data, DateTime now) {
    print('\n🔍 === VALIDATING PROMO CODE ===');

    try {
      // Check if promo code is active
      final isActive = data['is_active'] ?? false;
      print('🔍 is_active: $isActive');
      if (!isActive) {
        print('❌ Promo code is not active');
        return false;
      }

      // Check usage limits
      final usageCount = data['usage_count'] ?? 0;
      final maxUsage = data['max_usage'] ?? 0;
      print('🔍 usage_count: $usageCount');
      print('🔍 max_usage: $maxUsage');

      if (maxUsage > 0 && usageCount >= maxUsage) {
        print('❌ Promo code has reached usage limit ($usageCount/$maxUsage)');
        return false;
      }

      // Check start date
      if (data['start_date'] != null) {
        final startDate = (data['start_date'] as Timestamp).toDate();
        print('🔍 start_date: $startDate');
        print('🔍 current_date: $now');
        if (now.isBefore(startDate)) {
          print('❌ Promo code has not started yet');
          return false;
        }
      }

      // Check end date
      if (data['end_date'] != null) {
        final endDate = (data['end_date'] as Timestamp).toDate();
        print('🔍 end_date: $endDate');
        if (now.isAfter(endDate)) {
          print('❌ Promo code has expired');
          return false;
        }
      }

      print('✅ Promo code validation passed');
      return true;
    } catch (e) {
      print('❌ Error validating promo code: $e');
      return false;
    }
  }

  void _openProductUrl() {
    if (productUrl.isNotEmpty) {
      launchURL(productUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.open_in_new,
                color: Colors.white,
                size: 24.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Opening product page...',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Fallback: copy product info to clipboard
      String productInfo = 'Product: $productName\nPrice: $productPrice';
      if (productCategory.isNotEmpty) {
        productInfo += '\nCategory: $productCategory';
      }

      Clipboard.setData(ClipboardData(text: productInfo));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.content_copy,
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
                      'Product Info Copied!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'Product details copied to clipboard',
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
        ),
      );
    }
  }
}
