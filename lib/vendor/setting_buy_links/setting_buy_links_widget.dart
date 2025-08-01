import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'setting_buy_links_model.dart';
export 'setting_buy_links_model.dart';

class SettingBuyLinksWidget extends StatefulWidget {
  const SettingBuyLinksWidget({super.key});

  static String routeName = 'SettingBuyLinks';
  static String routePath = '/settingBuyLinks';

  @override
  State<SettingBuyLinksWidget> createState() => _SettingBuyLinksWidgetState();
}

class _SettingBuyLinksWidgetState extends State<SettingBuyLinksWidget>
    with TickerProviderStateMixin {
  late SettingBuyLinksModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingBuyLinksModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 50.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
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
            begin: Offset(0.0, 50.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
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
  void dispose() {
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
            'Setting Buy Links',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
                  color: Colors.white,
                  fontSize: 24.0,
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
                              fontFamily: GoogleFonts.interTight().fontFamily,
                              fontSize: 24.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Update buy links for your products to redirect customers to your store',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),

                      SizedBox(height: 24.0),

                      // Products List
                      LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount =
                              constraints.maxWidth > 600 ? 2 : 1;

                          return GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: crossAxisCount == 2 ? 1.2 : 1.0,
                            children: [
                              _buildProductCard(
                                'Basic Black Tee',
                                'https://example.com/black-tee',
                                animationsMap['containerOnPageLoadAnimation1']!,
                              ),
                              _buildProductCard(
                                'White Sneakers',
                                'https://example.com/white-sneakers',
                                animationsMap['containerOnPageLoadAnimation2']!,
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 32.0),

                      Divider(
                        height: 40.0,
                        thickness: 2.0,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),

                      // Update Link Section
                      _buildUpdateLinkSection(),

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
      String productName, String currentLink, AnimationInfo animation) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  child: Image.asset(
                    'assets/images/basic_black_tee.jpg',
                    fit: BoxFit.cover,
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
                  Text(
                    productName,
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  SizedBox(height: 8.0),

                  Text(
                    'Current Link:',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),

                  Text(
                    currentLink,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          decoration: TextDecoration.underline,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Spacer(),

                  // Update Link Button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        _showUpdateLinkDialog(productName, currentLink);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'Update Link',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: GoogleFonts.inter().fontFamily,
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animation);
  }

  Widget _buildUpdateLinkSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Product Link',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: GoogleFonts.interTight().fontFamily,
                    fontSize: 20.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Product URL',
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _model.textController!,
              focusNode: _model.textFieldFocusNode!,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'e.g., https://shopee.com/your-product-link',
                hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                contentPadding:
                    EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                prefixIcon: Icon(
                  Icons.link,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 20.0,
                ),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    letterSpacing: 0.0,
                  ),
              keyboardType: TextInputType.url,
              validator: _model.textControllerValidator.asValidator(context),
            ),
            SizedBox(height: 24.0),
            FFButtonWidget(
              onPressed: () {
                if (_model.textController?.text.isEmpty ?? true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid URL'),
                      backgroundColor: FlutterFlowTheme.of(context).error,
                    ),
                  );
                  return;
                }

                // Handle update logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product link updated successfully!'),
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                  ),
                );
                _model.textController?.clear();
              },
              text: 'Update Link',
              icon: Icon(
                Icons.upload,
                size: 16.0,
              ),
              options: FFButtonOptions(
                width: double.infinity,
                height: 48.0,
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: GoogleFonts.interTight().fontFamily,
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                elevation: 3.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ],
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation3']!);
  }

  void _showUpdateLinkDialog(String productName, String currentLink) {
    final TextEditingController dialogController =
        TextEditingController(text: currentLink);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Link for $productName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter the new buy link for this product:',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: dialogController,
                decoration: InputDecoration(
                  hintText: 'https://your-store.com/product',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle update logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Link updated for $productName'),
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
              ),
              child: Text('Update', style: TextStyle(color: Colors.white)),
            ),
          ],
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
          _buildNavItem(Icons.tv_rounded, 'Virtual', false,
              () => context.pushNamed(VirtualTryOnSettingWidget.routeName)),
          _buildNavItem(Icons.settings_sharp, 'Link', true, () => {}),
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
                  fontFamily: GoogleFonts.inter().fontFamily,
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
