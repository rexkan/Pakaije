import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'manage_discount_codes_model.dart';
export 'manage_discount_codes_model.dart';

class ManageDiscountCodesWidget extends StatefulWidget {
  const ManageDiscountCodesWidget({super.key});

  static String routeName = 'ManageDiscountCodes';
  static String routePath = '/manageDiscountCodes';

  @override
  State<ManageDiscountCodesWidget> createState() =>
      _ManageDiscountCodesWidgetState();
}

class _ManageDiscountCodesWidgetState extends State<ManageDiscountCodesWidget>
    with TickerProviderStateMixin {
  late ManageDiscountCodesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManageDiscountCodesModel());

    _model.switchValue1 = true;
    _model.switchValue2 = true;
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    animationsMap.addAll({
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(1.05, 1.05),
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
            'Manage Discount Codes',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: GoogleFonts.interTight().fontFamily,
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
                      // Active Promo Codes Section
                      _buildActivePromoCodesSection(),

                      SizedBox(height: 32.0),

                      // Performance Stats
                      _buildPerformanceStats(),

                      SizedBox(height: 32.0),

                      // Create New Promo Code Section
                      _buildCreatePromoCodeSection(),

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

  Widget _buildActivePromoCodesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Promo Codes',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: GoogleFonts.interTight().fontFamily,
                fontSize: 24.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8.0),
        Text(
          'Manage your current discount codes',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: GoogleFonts.inter().fontFamily,
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),

        SizedBox(height: 20.0),

        // Promo Code Cards
        _buildPromoCodeCard(
          'PAKAIJE50',
          '50% Discount',
          'Valid until Dec 31, 2024',
          _model.switchValue1!,
          (value) => setState(() => _model.switchValue1 = value),
        ),

        SizedBox(height: 16.0),

        _buildPromoCodeCard(
          'PAKAIJE20',
          '20% Discount',
          'Valid until Jan 15, 2025',
          _model.switchValue2!,
          (value) => setState(() => _model.switchValue2 = value),
        ),
      ],
    );
  }

  Widget _buildPromoCodeCard(String code, String discount, String validity,
      bool isActive, Function(bool) onChanged) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isActive
              ? FlutterFlowTheme.of(context).primary.withOpacity(0.3)
              : FlutterFlowTheme.of(context).alternate,
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          code,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      if (isActive)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            'ACTIVE',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  color: Colors.green,
                                  fontSize: 10.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    discount,
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    validity,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Switch.adaptive(
                  value: isActive,
                  onChanged: onChanged,
                  activeColor: FlutterFlowTheme.of(context).primary,
                  inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
                  inactiveThumbColor:
                      FlutterFlowTheme.of(context).secondaryText,
                ),
                SizedBox(height: 8.0),
                FFButtonWidget(
                  onPressed: () =>
                      _showEditPromoDialog(code, discount, validity),
                  text: 'Edit',
                  options: FFButtonOptions(
                    width: 60.0,
                    height: 32.0,
                    padding: EdgeInsets.zero,
                    iconPadding: EdgeInsets.zero,
                    color: FlutterFlowTheme.of(context).underground,
                    textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: Colors.white,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promo Code Performance',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: GoogleFonts.interTight().fontFamily,
                fontSize: 20.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child:
                  _buildStatCard('Redemptions', '255', '32.2%', Icons.redeem),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child:
                  _buildStatCard('Click-throughs', '67', '45.5%', Icons.mouse),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, String percentage, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              Icon(
                icon,
                color: FlutterFlowTheme.of(context).primary,
                size: 20.0,
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                      fontFamily: GoogleFonts.interTight().fontFamily,
                      fontSize: 28.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(width: 8.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.green,
                      size: 12.0,
                    ),
                    Text(
                      percentage,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            color: Colors.green,
                            fontSize: 10.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreatePromoCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create New Promo Code',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: GoogleFonts.interTight().fontFamily,
                fontSize: 20.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),

        SizedBox(height: 20.0),

        // Code Name Field
        _buildTextField(
          controller: _model.textController1!,
          focusNode: _model.textFieldFocusNode1!,
          hintText: 'Code Name (e.g., SUMMER2024)',
          icon: Icons.code,
        ),

        SizedBox(height: 16.0),

        // Discount Amount Field
        _buildTextField(
          controller: _model.textController2!,
          focusNode: _model.textFieldFocusNode2!,
          hintText: 'Discount Amount (e.g., 25%)',
          icon: Icons.percent,
        ),

        SizedBox(height: 16.0),

        // Date Range Fields
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _model.textController3!,
                focusNode: _model.textFieldFocusNode3!,
                hintText: 'Start Date',
                icon: Icons.calendar_today,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: _buildTextField(
                controller: _model.textController4!,
                focusNode: _model.textFieldFocusNode4!,
                hintText: 'End Date',
                icon: Icons.calendar_today,
              ),
            ),
          ],
        ),

        SizedBox(height: 24.0),

        // Create Button
        FFButtonWidget(
          onPressed: () {
            if ((_model.textController1?.text.isEmpty ?? true) ||
                (_model.textController2?.text.isEmpty ?? true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please fill in all required fields'),
                  backgroundColor: FlutterFlowTheme.of(context).error,
                ),
              );
              return;
            }

            // Handle create logic here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Promo code created successfully!'),
                backgroundColor: FlutterFlowTheme.of(context).primary,
              ),
            );

            // Clear fields
            _model.textController1?.clear();
            _model.textController2?.clear();
            _model.textController3?.clear();
            _model.textController4?.clear();
          },
          text: 'Create Promo Code',
          options: FFButtonOptions(
            width: double.infinity,
            height: 50.0,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            iconPadding: EdgeInsets.zero,
            color: FlutterFlowTheme.of(context).underground,
            textStyle: FlutterFlowTheme.of(context).titleMedium.override(
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
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
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
        prefixIcon: Icon(
          icon,
          color: FlutterFlowTheme.of(context).secondaryText,
          size: 20.0,
        ),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: GoogleFonts.inter().fontFamily,
            letterSpacing: 0.0,
          ),
    );
  }

  void _showEditPromoDialog(String code, String discount, String validity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Promo Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Editing promo code: $code'),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: discount,
                decoration: InputDecoration(
                  labelText: 'Discount Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: validity,
                decoration: InputDecoration(
                  labelText: 'Validity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
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
                // Handle save logic
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Promo code updated successfully!'),
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
              ),
              child: Text('Save', style: TextStyle(color: Colors.white)),
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
          _buildNavItem(Icons.discount_outlined, 'Code', true, () => {}),
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
