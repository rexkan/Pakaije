import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'virtual_try_on_setting_model.dart';
export 'virtual_try_on_setting_model.dart';

class VirtualTryOnSettingWidget extends StatefulWidget {
  const VirtualTryOnSettingWidget({super.key});

  static String routeName = 'VirtualTryOnSetting';
  static String routePath = '/virtualTryOnSetting';

  @override
  State<VirtualTryOnSettingWidget> createState() =>
      _VirtualTryOnSettingWidgetState();
}

class _VirtualTryOnSettingWidgetState extends State<VirtualTryOnSettingWidget> {
  late VirtualTryOnSettingModel _model;

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
                            childAspectRatio: crossAxisCount == 2 ? 1.0 : 0.8,
                            children: [
                              _buildProductCard(
                                'Basic Black Tee',
                                'Casual',
                                _model.switchValue1!,
                                (value) =>
                                    setState(() => _model.switchValue1 = value),
                              ),
                              _buildProductCard(
                                'White Sneakers',
                                'Casual, Sports',
                                _model.switchValue2!,
                                (value) =>
                                    setState(() => _model.switchValue2 = value),
                              ),
                              _buildProductCard(
                                'Formal Blazer',
                                'Formal',
                                _model.switchValue3!,
                                (value) =>
                                    setState(() => _model.switchValue3 = value),
                              ),
                              _buildProductCard(
                                'Summer Dress',
                                'Casual, Party',
                                _model.switchValue4!,
                                (value) =>
                                    setState(() => _model.switchValue4 = value),
                              ),
                            ],
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

  Widget _buildProductCard(String productName, String tags, bool isEnabled,
      Function(bool) onChanged) {
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
                          fontFamily: 'Inter Tight',
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

                  // Virtual Try-On Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Virtual Try-On',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Switch.adaptive(
                        value: isEnabled,
                        onChanged: onChanged,
                        activeColor: FlutterFlowTheme.of(context).primary,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor:
                            FlutterFlowTheme.of(context).secondaryText,
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
