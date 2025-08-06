import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'manage_discount_codes_model.dart';
export 'manage_discount_codes_model.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ================================================================================
// SECTION 1: MAIN WIDGET CLASS DECLARATION
// ================================================================================
// 🟢 EASY TO REMOVE - This is the main widget class structure
// PURPOSE: Defines the main StatefulWidget for the discount codes management page
// REMOVAL IMPACT: Cannot remove - this is the core widget structure
// ================================================================================

class ManageDiscountCodesWidget extends StatefulWidget {
  const ManageDiscountCodesWidget({super.key});

  static String routeName = 'ManageDiscountCodes';
  static String routePath = '/manageDiscountCodes';

  @override
  State<ManageDiscountCodesWidget> createState() =>
      _ManageDiscountCodesWidgetState();
}

// ================================================================================
// SECTION 2: STATE CLASS AND INITIALIZATION
// ================================================================================
// 🔴 CORE COMPONENT - Contains essential state management and controllers
// PURPOSE: Manages page state, text controllers, focus nodes, and animations
// REMOVAL IMPACT: Cannot remove - required for page functionality
// ================================================================================

class _ManageDiscountCodesWidgetState extends State<ManageDiscountCodesWidget>
    with TickerProviderStateMixin {
  late ManageDiscountCodesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManageDiscountCodesModel());

    // Text Controllers for Form Fields
    _model.textController1 ??= TextEditingController(); // Code Name
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(); // Discount Amount
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController(); // Item ID
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController(); // Start Date
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController(); // End Date
    _model.textFieldFocusNode5 ??= FocusNode();

    // Animation Setup
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

// ================================================================================
// SECTION 3: DELETE CONFIRMATION DIALOG
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Modal dialog for confirming discount code deletion
// PURPOSE: Shows warning dialog before deleting a discount code
// REMOVAL IMPACT: Can be removed - will disable delete confirmation safety
// COMPONENTS: AlertDialog with warning icon, confirmation text, and action buttons
// ================================================================================

  void _showDeleteConfirmation(DiscountCodesRecord discountCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Dialog Header with Warning Icon
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

          // Dialog Content with Warning Message
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

          // Dialog Action Buttons
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

// ================================================================================
// SECTION 4: DELETE DISCOUNT CODE METHOD
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Firebase deletion logic with user feedback
// PURPOSE: Handles the actual deletion of discount codes from Firebase
// REMOVAL IMPACT: Required if delete functionality is kept
// COMPONENTS: Firebase delete operation, success/error snackbars
// ================================================================================

  Future<void> _deleteDiscountCode(DiscountCodesRecord discountCode) async {
    try {
      await discountCode.reference.delete();

      // Success Feedback
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
      // Error Feedback
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

// ================================================================================
// SECTION 5: TOGGLE STATUS METHOD
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Activate/deactivate discount codes
// PURPOSE: Toggles the active status of discount codes in Firebase
// REMOVAL IMPACT: Can be removed - will disable status toggle functionality
// COMPONENTS: Firebase update operation, status feedback snackbar
// ================================================================================

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

// ================================================================================
// SECTION 6: CREATE PROMO CODE SECTION
// ================================================================================
// 🟢 EASY TO REMOVE - Complete form for creating new discount codes
// PURPOSE: Provides form interface for adding new discount codes
// REMOVAL IMPACT: Can be removed - will disable new code creation
// COMPONENTS: Form fields, validation, Firebase save operation, success feedback
// ================================================================================

  Widget _buildCreatePromoCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
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

        // Item ID Field (Optional)
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

        // Create Button with Firebase Save Logic
        FFButtonWidget(
          onPressed: () async {
            // Form Validation
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

            // Firebase Save Operation
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

              // Success Feedback
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

              // Clear Form Fields
              _model.textController1?.clear();
              _model.textController2?.clear();
              _model.textController3?.clear();
              _model.textController4?.clear();
              _model.textController5?.clear();
            } catch (e) {
              // Error Handling
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

// ================================================================================
// SECTION 7: TEXT FIELD HELPER WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Reusable form input field component
// PURPOSE: Creates consistent styled text form fields throughout the app
// REMOVAL IMPACT: Required if any form fields are kept
// COMPONENTS: TextFormField with custom styling and validation
// ================================================================================

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

// ================================================================================
// SECTION 8: EDIT PROMO DIALOG
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Modal dialog for editing existing discount codes
// PURPOSE: Provides interface to modify existing discount code properties
// REMOVAL IMPACT: Can be removed - will disable edit functionality
// COMPONENTS: AlertDialog with form fields, validation, Firebase update
// ================================================================================

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
          // Dialog Header
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

          // Dialog Content with Edit Form
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Code Display
              Text(
                'Code: ${discountCode.code}',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 16.0),

              // Discount Amount Edit Field
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

              // Item ID Edit Field
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

              // Max Usage Edit Field
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

          // Dialog Action Buttons
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
                  // Update Firebase Document
                  await discountCode.reference.update({
                    'discount_value':
                        double.tryParse(discountController.text) ??
                            discountCode.discountValue,
                    'item_id': itemIdController.text.trim(),
                    'max_usage': int.tryParse(maxUsageController.text) ??
                        discountCode.maxUsage,
                  });

                  Navigator.of(context).pop();

                  // Success Feedback
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

                  // Error Handling
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

// ================================================================================
// SECTION 9: BOTTOM NAVIGATION WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Complete bottom navigation bar
// PURPOSE: Provides navigation between different vendor dashboard sections
// REMOVAL IMPACT: Can be completely removed - page will work without navigation
// COMPONENTS: Container with navigation items, icons, labels, and navigation logic
// ================================================================================

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
          // Profile Navigation Item
          _buildNavItem(Icons.person, 'Profile', false,
              () => context.pushNamed('VendorDashboard')),

          // Discount Code Navigation Item (Current Page)
          _buildNavItem(Icons.discount_outlined, 'Code', true, () => {}),

          // Virtual Try-On Navigation Item
          _buildNavItem(Icons.tv_rounded, 'Virtual', false,
              () => context.pushNamed('VirtualTryOnSetting')),

          // Buy Links Navigation Item
          _buildNavItem(Icons.settings_sharp, 'Link', false,
              () => context.pushNamed('SettingBuyLinks')),

          // Add Product Navigation Item
          _buildNavItem(
              Icons.add, 'Add', false, () => context.pushNamed('AddProduct')),
        ],
      ),
    );
  }

// ================================================================================
// SECTION 10: NAVIGATION ITEM HELPER WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Individual navigation button component
// PURPOSE: Creates individual navigation items for the bottom navigation
// REMOVAL IMPACT: Required if bottom navigation is kept
// COMPONENTS: GestureDetector with icon, label, and active state styling
// ================================================================================

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Navigation Icon
          Icon(
            icon,
            color:
                isActive ? FlutterFlowTheme.of(context).primary : Colors.white,
            size: 24.0,
          ),
          SizedBox(height: 4.0),

          // Navigation Label
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

// ================================================================================
// SECTION 11: MAIN BUILD METHOD
// ================================================================================
// 🔴 CORE COMPONENT - Main page layout structure
// PURPOSE: Builds the main scaffold and page structure
// REMOVAL IMPACT: Cannot remove - this is the core page structure
// COMPONENTS: Scaffold with AppBar, Body sections, and Bottom Navigation
// ================================================================================

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

        // ========================================================================
        // SUB-SECTION 11A: APP BAR
        // ========================================================================
        // 🟡 MEDIUM COMPLEXITY - Top navigation bar with back button and title
        // PURPOSE: Provides page title and back navigation
        // REMOVAL IMPACT: Can be simplified but header is recommended
        // ========================================================================

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

        // ========================================================================
        // SUB-SECTION 11B: BODY LAYOUT
        // ========================================================================
        // 🔴 CORE COMPONENT - Main content area layout
        // PURPOSE: Contains all page content in scrollable format
        // REMOVAL IMPACT: Cannot remove - essential for content display
        // ========================================================================

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

                      // Performance Stats Section
                      _buildPerformanceStats(),

                      SizedBox(height: 32.0),

                      // Create New Promo Code Section
                      _buildCreatePromoCodeSection(),

                      SizedBox(height: 80.0), // Space for bottom navigation
                    ],
                  ),
                ),
              ),

              // Bottom Navigation Section
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

// ================================================================================
// SECTION 12: ACTIVE PROMO CODES SECTION
// ================================================================================
// 🔴 CORE COMPONENT - Display and manage existing discount codes
// PURPOSE: Shows list of existing discount codes with management options
// REMOVAL IMPACT: Major impact - this is the main functionality
// COMPONENTS: StreamBuilder, Firebase query, code cards, empty state
// ================================================================================

  Widget _buildActivePromoCodesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with Title and Count Badge
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

            // Active Count Badge
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

        // Section Description
        Text(
          'Manage your current discount codes',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: GoogleFonts.inter().fontFamily,
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),

        SizedBox(height: 20.0),

        // Firebase StreamBuilder for Real-time Data
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('discount_codes')
              .where('vendor_id', isEqualTo: currentUserUid)
              .orderBy('created_at', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            // Loading State
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

            // Empty State
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

            // Display Discount Codes List
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

// ================================================================================
// SECTION 13: PROMO CODE CARD WIDGET
// ================================================================================
// 🔴 CORE COMPONENT - Individual discount code display card
// PURPOSE: Displays individual discount code information and controls
// REMOVAL IMPACT: Major impact - essential for code management
// COMPONENTS: Card container, code info, toggle switch, edit/delete buttons
// ================================================================================

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
            // Left Side - Code Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Code Badge
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

                      // Active Status Badge
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

                  // Discount Amount Display
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

                  // Item ID Display (if applicable)
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

                  // Validity Period Display
                  Text(
                    validityText,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 4.0),

                  // Usage Statistics Display
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

            // Right Side - Controls and Actions
            Column(
              children: [
                // Active/Inactive Toggle Switch
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

                // Edit and Delete Action Buttons
                Row(
                  children: [
                    // Edit Button
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

                    // Delete Button
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

// ================================================================================
// SECTION 14: PERFORMANCE STATS WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Analytics and metrics display section
// PURPOSE: Shows performance statistics for discount codes
// REMOVAL IMPACT: Can be completely removed - analytics only
// COMPONENTS: StreamBuilder, stat cards, performance metrics
// ================================================================================

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
            // Performance Section Title
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

            // Performance Stats Cards Row
            Row(
              children: [
                // Total Redemptions Stat Card
                Expanded(
                  child: _buildStatCard('Total Redemptions',
                      totalRedemptions.toString(), '+12.3%', Icons.redeem),
                ),
                SizedBox(width: 16.0),

                // Active Codes Stat Card
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

// ================================================================================
// SECTION 15: STAT CARD WIDGET
// ================================================================================
// 🟢 EASY TO REMOVE - Individual performance metric card component
// PURPOSE: Creates individual stat cards for the performance section
// REMOVAL IMPACT: Required if performance stats section is kept
// COMPONENTS: Container with stat display, icon, value, and percentage change
// ================================================================================

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
          // Card Header with Title and Icon
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

          // Stat Value and Percentage Change Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Main Stat Value
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

              // Percentage Change Badge
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
}

// ================================================================================
// END OF MANAGE DISCOUNT CODES WIDGET
// ================================================================================

/*
===============================================================================
PRESENTATION REMOVAL GUIDE FOR YOUR LECTURER DEMO
===============================================================================

🟢 EASIEST TO REMOVE (Independent components):
1. SECTION 14: Performance Stats Widget (Lines ~890-950) - Complete analytics section
2. SECTION 15: Stat Card Widget (Lines ~950-1020) - Individual metric cards  
3. SECTION 9: Bottom Navigation Widget (Lines ~520-580) - Complete navigation bar
4. SECTION 8: Edit Promo Dialog (Lines ~420-520) - Modal edit functionality
5. Individual Form Fields in SECTION 6 (Lines ~290-420):
   - Item ID Field (Optional product linking)
   - Date Range Fields (Start/End date inputs)

🟡 MEDIUM COMPLEXITY (Feature removal):
6. SECTION 3: Delete Confirmation Dialog (Lines ~95-190) - Safety confirmation
7. SECTION 5: Toggle Status Method (Lines ~250-290) - Enable/disable codes
8. SECTION 4: Delete Method (Lines ~190-250) - Actual deletion logic

🔴 CORE COMPONENTS (Keep for basic functionality):
- SECTION 1: Main Widget Class - Essential structure
- SECTION 2: State Class - Required controllers and state
- SECTION 11: Main Build Method - Core page layout
- SECTION 12: Active Promo Codes Section - Main functionality
- SECTION 13: Promo Code Card Widget - Individual code display
- SECTION 6: Create Promo Code Section - New code creation

PRESENTATION STRATEGY:
1. Start by removing SECTION 14 (Performance Stats) - Clean removal, no dependencies
2. Remove SECTION 9 (Bottom Navigation) - Page becomes simpler
3. Remove individual form fields from SECTION 6 to simplify creation form
4. Remove SECTION 8 (Edit Dialog) to disable editing
5. Remove SECTION 3 (Delete Confirmation) for direct deletion

Each section is clearly marked with numbered headers and difficulty indicators!
===============================================================================
*/
