import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_product_model.dart';
export 'add_product_model.dart';

class AddProductWidget extends StatefulWidget {
  const AddProductWidget({super.key});

  static String routeName = 'AddProduct';
  static String routePath = '/addProduct';

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  late AddProductModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddProductModel());

    _model.itemNameTextController ??= TextEditingController();
    _model.itemNameFocusNode ??= FocusNode();

    _model.categoryTextController ??= TextEditingController();
    _model.categoryFocusNode ??= FocusNode();
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
            'Add Product',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Inter Tight',
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
                  child: Form(
                    key: _model.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Upload Section
                        _buildImageUploadSection(),

                        SizedBox(height: 24.0),

                        // Product Details Section
                        _buildProductDetailsSection(),

                        SizedBox(height: 24.0),

                        // Color Selection
                        _buildColorSection(),

                        SizedBox(height: 24.0),

                        // Occasion Tags
                        _buildOccasionTagsSection(),

                        SizedBox(height: 32.0),

                        // Save Button
                        _buildSaveButton(),

                        SizedBox(height: 80.0), // Space for bottom navigation
                      ],
                    ),
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

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Images',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: _buildImageUploadCard(isMain: true),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: _buildImageUploadCard(isMain: false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageUploadCard({required bool isMain}) {
    return Container(
      height: 200.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              'assets/images/white_shoes.jpeg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          if (isMain)
            Positioned(
              top: 8.0,
              left: 8.0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  'Main',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontSize: 10.0,
                      ),
                ),
              ),
            ),
          Positioned(
            bottom: 8.0,
            right: 8.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: IconButton(
                icon: Icon(Icons.edit, color: Colors.white, size: 20.0),
                onPressed: () {
                  // Handle image upload
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Details',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16.0),

        // Item Name Field
        TextFormField(
          controller: _model.itemNameTextController,
          focusNode: _model.itemNameFocusNode,
          autofocus: false,
          textCapitalization: TextCapitalization.words,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Item Name',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                ),
            hintText: 'Enter product name',
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Inter',
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
                EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 20.0),
          ),
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                fontFamily: 'Inter',
                letterSpacing: 0.0,
              ),
          validator:
              _model.itemNameTextControllerValidator.asValidator(context),
        ),

        SizedBox(height: 16.0),

        // Category Field
        TextFormField(
          controller: _model.categoryTextController,
          focusNode: _model.categoryFocusNode,
          autofocus: false,
          textCapitalization: TextCapitalization.words,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Category',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                ),
            hintText: 'Enter product category',
            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Inter',
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
                EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 20.0),
          ),
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                fontFamily: 'Inter',
                letterSpacing: 0.0,
              ),
          validator:
              _model.categoryTextControllerValidator.asValidator(context),
        ),
      ],
    );
  }

  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 12.0),
        FlutterFlowChoiceChips(
          options: [
            ChipData('Black'),
            ChipData('Grey'),
            ChipData('White'),
          ],
          onChanged: (val) =>
              setState(() => _model.choiceChipsValue1 = val?.firstOrNull),
          selectedChipStyle: ChipStyle(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
            iconColor: Colors.white,
            iconSize: 18.0,
            elevation: 2.0,
            borderColor: FlutterFlowTheme.of(context).primary,
            borderWidth: 1.0,
            borderRadius: BorderRadius.circular(8.0),
          ),
          unselectedChipStyle: ChipStyle(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            iconColor: FlutterFlowTheme.of(context).secondaryText,
            iconSize: 18.0,
            elevation: 0.0,
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 2.0,
            borderRadius: BorderRadius.circular(8.0),
          ),
          chipSpacing: 12.0,
          rowSpacing: 12.0,
          multiselect: false,
          initialized: _model.choiceChipsValue1 != null,
          alignment: WrapAlignment.start,
          controller: _model.choiceChipsValueController1 ??=
              FormFieldController<List<String>>(['Black']),
          wrapped: true,
        ),
      ],
    );
  }

  Widget _buildOccasionTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Occasion Tags',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 12.0),
        FlutterFlowChoiceChips(
          options: [
            ChipData('Casual'),
            ChipData('Formal'),
            ChipData('Party'),
          ],
          onChanged: (val) =>
              setState(() => _model.choiceChipsValue2 = val?.firstOrNull),
          selectedChipStyle: ChipStyle(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
            iconColor: Colors.white,
            iconSize: 18.0,
            elevation: 2.0,
            borderColor: FlutterFlowTheme.of(context).primary,
            borderWidth: 1.0,
            borderRadius: BorderRadius.circular(8.0),
          ),
          unselectedChipStyle: ChipStyle(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
            iconColor: FlutterFlowTheme.of(context).secondaryText,
            iconSize: 18.0,
            elevation: 0.0,
            borderColor: FlutterFlowTheme.of(context).alternate,
            borderWidth: 2.0,
            borderRadius: BorderRadius.circular(8.0),
          ),
          chipSpacing: 12.0,
          rowSpacing: 12.0,
          multiselect: false,
          initialized: _model.choiceChipsValue2 != null,
          alignment: WrapAlignment.start,
          controller: _model.choiceChipsValueController2 ??=
              FormFieldController<List<String>>(['Casual']),
          wrapped: true,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: FFButtonWidget(
        onPressed: () {
          if (_model.formKey.currentState == null ||
              !_model.formKey.currentState!.validate()) {
            return;
          }
          // Handle save logic here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product saved successfully!'),
              backgroundColor: FlutterFlowTheme.of(context).primary,
            ),
          );
          context.pop();
        },
        text: 'Save Product',
        options: FFButtonOptions(
          height: 50.0,
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: FlutterFlowTheme.of(context).underground,
          textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Inter Tight',
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
          _buildNavItem(Icons.settings_sharp, 'Link', false,
              () => context.pushNamed(SettingBuyLinksWidget.routeName)),
          _buildNavItem(Icons.add, 'Add', true, () => {}),
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
