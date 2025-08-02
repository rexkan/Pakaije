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
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();

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

  // Show delete confirmation dialog
  void _showDeleteConfirmation(DiscountCodesRecord discountCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: FlutterFlowTheme.of(context).error,
                size: 28.0,
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Delete Discount Code',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Inter Tight',
                        color: FlutterFlowTheme.of(context).error,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete discount code "${discountCode.code}"?',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 12.0),
              Text(
                'This action cannot be undone. The discount code will be permanently removed.',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              ),
              child: Text(
                'Cancel',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteDiscountCode(discountCode);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).error,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  SizedBox(width: 6.0),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Delete discount code from Firebase
  Future<void> _deleteDiscountCode(DiscountCodesRecord discountCode) async {
    try {
      await discountCode.reference.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20.0,
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  '${discountCode.code} deleted successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
                size: 20.0,
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  'Error deleting discount code: ${e.toString()}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );
    }
  }

  // Toggle discount code active status
  Future<void> _toggleDiscountCodeStatus(
      DiscountCodesRecord discountCode, bool newStatus) async {
    try {
      await discountCode.reference.update({
        'is_active': newStatus,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${discountCode.code} ${newStatus ? 'activated' : 'deactivated'}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: ${e.toString()}'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
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

                      // Performance Stats (using real data)
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            // Discount code count
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('discount_codes')
                  .where('vendor_id', isEqualTo: currentUserUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final discountCodes = snapshot.data!.docs
                      .map((doc) => DiscountCodesRecord.fromSnapshot(doc))
                      .toList();
                  final activeCount =
                      discountCodes.where((code) => code.isActive).length;
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      '$activeCount active',
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

        // Promo Codes from Firebase
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('discount_codes')
              .where('vendor_id', isEqualTo: currentUserUid)
              .orderBy('created_at', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            // Loading state
            if (!snapshot.hasData) {
              return Center(
                child: Column(
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
                      'Loading discount codes...',
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

            List<DiscountCodesRecord> discountCodes = snapshot.data!.docs
                .map((doc) => DiscountCodesRecord.fromSnapshot(doc))
                .toList();

            // Empty state
            if (discountCodes.isEmpty) {
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
                    Icon(
                      Icons.discount_outlined,
                      size: 64.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'No discount codes yet',
                      style: FlutterFlowTheme.of(context)
                          .headlineSmall
                          .override(
                            fontFamily: 'Inter Tight',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Create your first discount code to boost sales',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Display discount codes
            return Column(
              children: discountCodes.map((discountCode) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: _buildPromoCodeCard(discountCode),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPromoCodeCard(DiscountCodesRecord discountCode) {
    String discountText = discountCode.discountType == 'percentage'
        ? '${discountCode.discountValue.toStringAsFixed(0)}% Discount'
        : '\$${discountCode.discountValue.toStringAsFixed(2)} Off';

    String validityText = discountCode.endDate != null
        ? 'Valid until ${DateFormat('MMM dd, yyyy').format(discountCode.endDate!)}'
        : 'No expiry date';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: discountCode.isActive
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
                          discountCode.code,
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
                      if (discountCode.isActive)
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
                    discountText,
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: GoogleFonts.interTight().fontFamily,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 4.0),
                  if (discountCode.itemId.isNotEmpty)
                    Text(
                      'Item ID: ${discountCode.itemId}',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  SizedBox(height: 4.0),
                  Text(
                    validityText,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Used: ${discountCode.usageCount}${discountCode.maxUsage > 0 ? ' / ${discountCode.maxUsage}' : ''}',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
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
                  value: discountCode.isActive,
                  onChanged: (value) =>
                      _toggleDiscountCodeStatus(discountCode, value),
                  activeColor: FlutterFlowTheme.of(context).primary,
                  inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
                  inactiveThumbColor:
                      FlutterFlowTheme.of(context).secondaryText,
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    FFButtonWidget(
                      onPressed: () => _showEditPromoDialog(discountCode),
                      text: 'Edit',
                      options: FFButtonOptions(
                        width: 50.0,
                        height: 32.0,
                        padding: EdgeInsets.zero,
                        iconPadding: EdgeInsets.zero,
                        color: FlutterFlowTheme.of(context).underground,
                        textStyle:
                            FlutterFlowTheme.of(context).bodySmall.override(
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
                    SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () => _showDeleteConfirmation(discountCode),
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .error
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context)
                                .error
                                .withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: FlutterFlowTheme.of(context).error,
                          size: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceStats() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('discount_codes')
          .where('vendor_id', isEqualTo: currentUserUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        List<DiscountCodesRecord> discountCodes = snapshot.data!.docs
            .map((doc) => DiscountCodesRecord.fromSnapshot(doc))
            .toList();
        int totalRedemptions =
            discountCodes.fold(0, (sum, code) => sum + code.usageCount);
        int activeCodesCount =
            discountCodes.where((code) => code.isActive).length;

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
                  child: _buildStatCard('Total Redemptions',
                      totalRedemptions.toString(), '+12.3%', Icons.redeem),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: _buildStatCard('Active Codes',
                      activeCodesCount.toString(), '+5.2%', Icons.local_offer),
                ),
              ],
            ),
          ],
        );
      },
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
          hintText: 'Discount Amount (e.g., 25)',
          icon: Icons.percent,
        ),

        SizedBox(height: 16.0),

        // Item ID Field
        _buildTextField(
          controller: _model.textController3!,
          focusNode: _model.textFieldFocusNode3!,
          hintText: 'Item ID (Optional - links to branded item)',
          icon: Icons.inventory_2,
        ),

        SizedBox(height: 16.0),

        // Date Range Fields
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _model.textController4!,
                focusNode: _model.textFieldFocusNode4!,
                hintText: 'Start Date (Optional)',
                icon: Icons.calendar_today,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: _buildTextField(
                controller: _model.textController5!,
                focusNode: _model.textFieldFocusNode5!,
                hintText: 'End Date (Optional)',
                icon: Icons.calendar_today,
              ),
            ),
          ],
        ),

        SizedBox(height: 24.0),

        // Create Button
        FFButtonWidget(
          onPressed: () async {
            if ((_model.textController1?.text.isEmpty ?? true) ||
                (_model.textController2?.text.isEmpty ?? true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Please fill in the code name and discount amount'),
                  backgroundColor: FlutterFlowTheme.of(context).error,
                ),
              );
              return;
            }

            // Create new discount code
            try {
              await FirebaseFirestore.instance
                  .collection('discount_codes')
                  .add({
                'vendor_id': currentUserUid,
                'code': _model.textController1!.text.toUpperCase(),
                'discount_type': 'percentage',
                'discount_value':
                    double.tryParse(_model.textController2!.text) ?? 0.0,
                'item_id': _model.textController3!.text.trim().isEmpty
                    ? ''
                    : _model.textController3!.text.trim(),
                'start_date': DateTime.now(),
                'end_date': null,
                'is_active': true,
                'usage_count': 0,
                'max_usage': 0,
                'created_at': DateTime.now(),
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20.0),
                      SizedBox(width: 8.0),
                      Text('Promo code created successfully!'),
                    ],
                  ),
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              );

              // Clear fields
              _model.textController1?.clear();
              _model.textController2?.clear();
              _model.textController3?.clear();
              _model.textController4?.clear();
              _model.textController5?.clear();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error creating promo code: ${e.toString()}'),
                  backgroundColor: FlutterFlowTheme.of(context).error,
                ),
              );
            }
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

  void _showEditPromoDialog(DiscountCodesRecord discountCode) {
    final TextEditingController discountController =
        TextEditingController(text: discountCode.discountValue.toString());
    final TextEditingController maxUsageController =
        TextEditingController(text: discountCode.maxUsage.toString());
    final TextEditingController itemIdController =
        TextEditingController(text: discountCode.itemId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.edit,
                color: FlutterFlowTheme.of(context).primary,
                size: 24.0,
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Edit Promo Code',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Inter Tight',
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Code: ${discountCode.code}',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: discountController,
                decoration: InputDecoration(
                  labelText: 'Discount Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.percent),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: itemIdController,
                decoration: InputDecoration(
                  labelText: 'Item ID (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.inventory_2),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: maxUsageController,
                decoration: InputDecoration(
                  labelText: 'Max Usage (0 = unlimited)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.repeat),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              ),
              child: Text(
                'Cancel',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await discountCode.reference.update({
                    'discount_value':
                        double.tryParse(discountController.text) ??
                            discountCode.discountValue,
                    'item_id': itemIdController.text.trim(),
                    'max_usage': int.tryParse(maxUsageController.text) ??
                        discountCode.maxUsage,
                  });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.white, size: 20.0),
                          SizedBox(width: 8.0),
                          Text('Promo code updated successfully!'),
                        ],
                      ),
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Error updating promo code: ${e.toString()}'),
                      backgroundColor: FlutterFlowTheme.of(context).error,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save, color: Colors.white, size: 18.0),
                  SizedBox(width: 6.0),
                  Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
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
