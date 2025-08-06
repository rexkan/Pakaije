import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_product_model.dart';
export 'add_product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';

// ============================================================================
// MAIN WIDGET CLASS - Add Product Page
// ============================================================================
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

  // ============================================================================
  // INITIALIZATION SECTION - Controller and Focus Node Setup
  // ============================================================================
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddProductModel());

    // Initialize existing text controllers
    _model.itemNameTextController ??= TextEditingController();
    _model.itemNameFocusNode ??= FocusNode();

    // Initialize ItemId text controllers
    _model.itemIdTextController ??= TextEditingController();
    _model.itemIdFocusNode ??= FocusNode();

    // Initialize category dropdown
    _model.categoryDropDownValueController = FormFieldController<String>(null);

    // Initialize other text controllers
    _model.priceTextController ??= TextEditingController();
    _model.priceFocusNode ??= FocusNode();

    _model.buyLinkTextController ??= TextEditingController();
    _model.buyLinkFocusNode ??= FocusNode();

    _model.descriptionTextController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();
  }

  // ============================================================================
  // CLEANUP SECTION - Dispose Resources
  // ============================================================================
  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ============================================================================
  // MAIN BUILD METHOD - Page Layout Structure
  // ============================================================================
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
        // APP BAR SECTION - Top Navigation Bar
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

        // ========================================================================
        // BODY SECTION - Main Content Area
        // ========================================================================
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
                        // ================================================================
                        // IMAGE UPLOAD SECTION - Product Image Selection
                        // ================================================================
                        _buildImageUploadSection(),

                        SizedBox(height: 24.0),

                        // ================================================================
                        // PRODUCT DETAILS SECTION - Basic Product Information
                        // ================================================================
                        _buildProductDetailsSection(),

                        SizedBox(height: 24.0),

                        // ================================================================
                        // COLOR SELECTION SECTION - Color Choice Chips
                        // ================================================================
                        _buildColorSection(),

                        SizedBox(height: 24.0),

                        // ================================================================
                        // OCCASION TAGS SECTION - Occasion Choice Chips
                        // ================================================================
                        _buildOccasionTagsSection(),

                        SizedBox(height: 32.0),

                        // ================================================================
                        // SAVE BUTTON SECTION - Submit Button
                        // ================================================================
                        _buildSaveButton(),

                        SizedBox(height: 80.0), // Space for bottom navigation
                      ],
                    ),
                  ),
                ),
              ),

              // ==================================================================
              // BOTTOM NAVIGATION SECTION - Fixed Bottom Navigation Bar
              // ==================================================================
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // IMAGE UPLOAD WIDGET SECTION - Product Image Upload Component
  // ============================================================================
  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for Image Upload Section
        Text(
          'Product Image',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16.0),
        // Image Upload Card Component
        _buildSingleImageUploadCard(),
      ],
    );
  }

  // ============================================================================
  // SINGLE IMAGE UPLOAD CARD - Image Selection Interface
  // ============================================================================
  Widget _buildSingleImageUploadCard() {
    return Container(
      width: double.infinity,
      height: 250.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
      ),
      child: Stack(
        children: [
          // Image Display Area - Shows selected image or placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: _model.uploadedLocalFile != null &&
                    _model.uploadedLocalFile.bytes?.isNotEmpty == true
                ? Image.memory(
                    _model.uploadedLocalFile.bytes!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 64.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Add Product Image',
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                fontFamily: 'Inter',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Tap to select an image',
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Inter',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                  ),
          ),

          // Loading Overlay - Shows during image upload
          if (_model.isDataUploading)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Uploading...',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ),

          // Edit Button - Allows changing the selected image
          if (_model.uploadedLocalFile != null &&
              _model.uploadedLocalFile.bytes?.isNotEmpty == true)
            Positioned(
              top: 12.0,
              right: 12.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.white, size: 20.0),
                  onPressed: _selectImage,
                ),
              ),
            ),

          // Remove Button - Deletes the selected image
          if (_model.uploadedLocalFile != null &&
              _model.uploadedLocalFile.bytes?.isNotEmpty == true)
            Positioned(
              top: 12.0,
              left: 12.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white, size: 20.0),
                  onPressed: () {
                    setState(() {
                      _model.uploadedLocalFile = FFUploadedFile(
                        name: '',
                        bytes: Uint8List.fromList([]),
                      );
                    });
                  },
                ),
              ),
            ),

          // Tap Area for Image Selection - Makes the entire area clickable
          if (_model.uploadedLocalFile == null ||
              _model.uploadedLocalFile.bytes?.isEmpty == true)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14.0),
                  onTap: _selectImage,
                  child: Container(),
                ),
              ),
            ),
        ],
      ),
    );
  }

// ============================================================================
// IMAGE SELECTION HELPER METHOD - Handles Image Picking
// ============================================================================
  Future<void> _selectImage() async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      allowPhoto: true,
      allowVideo: false,
    );

    if (selectedMedia != null &&
        selectedMedia
            .every((m) => validateFileFormat(m.storagePath, context))) {
      setState(() => _model.isDataUploading = true);

      var selectedUploadedFiles = <FFUploadedFile>[];

      try {
        selectedUploadedFiles = selectedMedia
            .map((m) => FFUploadedFile(
                  name: m.storagePath.split('/').last,
                  bytes: m.bytes,
                  height: m.dimensions?.height,
                  width: m.dimensions?.width,
                  blurHash: m.blurHash,
                ))
            .toList();
      } finally {
        _model.isDataUploading = false;
      }

      if (selectedUploadedFiles.isNotEmpty) {
        setState(() {
          _model.uploadedLocalFile = selectedUploadedFiles.first;
        });
      }
    }
  }

  // ============================================================================
  // PRODUCT DETAILS WIDGET SECTION - Form Fields for Product Information
  // ============================================================================
  Widget _buildProductDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Details Section Title
        Text(
          'Product Details',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16.0),

        // Product Name Field - Text input for product name
        TextFormField(
          controller: _model.itemNameTextController,
          focusNode: _model.itemNameFocusNode,
          autofocus: false,
          textCapitalization: TextCapitalization.words,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Product Name',
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Product name is required';
            }
            if (value.length < 2) {
              return 'Product name must be at least 2 characters';
            }
            return null;
          },
        ),

        SizedBox(height: 16.0),

        // Item ID Field - Text input for unique product identifier
        TextFormField(
          controller: _model.itemIdTextController,
          focusNode: _model.itemIdFocusNode,
          autofocus: false,
          textCapitalization: TextCapitalization.characters,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Item ID',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                ),
            hintText: 'Enter unique item ID (e.g., SKU123)',
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Item ID is required';
            }
            if (value.length < 3) {
              return 'Item ID must be at least 3 characters';
            }
            return null;
          },
        ),

        SizedBox(height: 16.0),

        // Category Field - Dropdown for product category selection
        Container(
          width: double.infinity,
          child: DropdownButtonFormField<String>(
            value: _model.categoryDropDownValue,
            hint: Text(
              'Select product category',
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
            ),
            items: ['Tops', 'Bottoms', 'Shoes']
                .map((String category) => DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ))
                .toList(),
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
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
            onChanged: (String? newValue) {
              setState(() {
                _model.categoryDropDownValue = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Category is required';
              }
              return null;
            },
            dropdownColor: FlutterFlowTheme.of(context).secondaryBackground,
            elevation: 8,
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 24,
            ),
          ),
        ),

        SizedBox(height: 16.0),

        // Price Field - Numeric input for product price
        TextFormField(
          controller: _model.priceTextController,
          focusNode: _model.priceFocusNode,
          autofocus: false,
          obscureText: false,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Price',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                ),
            hintText: 'Enter product price',
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Price is required';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid price';
            }
            return null;
          },
        ),

        SizedBox(height: 16.0),

        // Buy Link Field - Optional URL input for purchase link
        TextFormField(
          controller: _model.buyLinkTextController,
          focusNode: _model.buyLinkFocusNode,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Buy Link (Optional)',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                ),
            hintText: 'Enter purchase link',
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
        ),

        SizedBox(height: 16.0),

        // Description Field - Multi-line text input for product description
        TextFormField(
          controller: _model.descriptionTextController,
          focusNode: _model.descriptionFocusNode,
          autofocus: false,
          textCapitalization: TextCapitalization.sentences,
          obscureText: false,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description (Optional)',
            labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                ),
            hintText: 'Enter product description',
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
        ),
      ],
    );
  }

  // ============================================================================
  // COLOR SELECTION WIDGET SECTION - Color Choice Chips
  // ============================================================================
  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color Section Title
        Text(
          'Color',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 12.0),
        // Color Choice Chips - Interactive color selection
        FlutterFlowChoiceChips(
          options: [
            ChipData('Black'),
            ChipData('Grey'),
            ChipData('White'),
            ChipData('Red'),
            ChipData('Blue'),
            ChipData('Green'),
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

  // ============================================================================
  // OCCASION TAGS WIDGET SECTION - Occasion Choice Chips
  // ============================================================================
  Widget _buildOccasionTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Occasion Tags Section Title
        Text(
          'Occasion Tags',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 12.0),
        // Occasion Choice Chips - Interactive occasion selection
        FlutterFlowChoiceChips(
          options: [
            ChipData('Casual'),
            ChipData('Formal'),
            ChipData('Party'),
            ChipData('Work'),
            ChipData('Sport'),
            ChipData('Evening'),
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

  // ============================================================================
  // SAVE BUTTON WIDGET SECTION - Submit Button with Firebase Integration
  // ============================================================================
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: FFButtonWidget(
        onPressed: () async {
          // Form Validation - Check if all required fields are filled
          if (_model.formKey.currentState == null ||
              !_model.formKey.currentState!.validate()) {
            return;
          }

          // Loading Dialog - Show progress indicator during save operation
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );

          try {
            String? imageUrl;

            // Image Upload to Firebase Storage - Upload selected image
            if (_model.uploadedLocalFile != null &&
                _model.uploadedLocalFile.bytes?.isNotEmpty == true) {
              // Upload to Firebase Storage
              final storageRef = FirebaseStorage.instance.ref().child(
                  'product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

              final uploadTask =
                  await storageRef.putData(_model.uploadedLocalFile.bytes!);
              imageUrl = await uploadTask.ref.getDownloadURL();
            }

            // Firestore Save Operation - Create new product document
            await BrandedItemsRecord.collection
                .add(createBrandedItemsRecordData(
              vendorId: currentUserUid,
              name: _model.itemNameTextController?.text ?? '',
              itemId: _model.itemIdTextController?.text ?? '',
              category: _model.categoryDropDownValue ?? '',
              price: double.tryParse(_model.priceTextController?.text ?? '0') ??
                  0.0,
              productUrl: _model.buyLinkTextController?.text ?? '',
              description: _model.descriptionTextController?.text ?? '',
              imageUrl: imageUrl ?? '',
              dateAdded: getCurrentTimestamp,
            ))
                .then((docRef) async {
              // Additional Field Updates - Add style tags and weather data
              await docRef.update({
                'style_tags': [_model.choiceChipsValue2 ?? 'Casual'],
                'weather_suitability': [],
              });
            });

            Navigator.pop(context); // Close loading dialog

            // Success Feedback - Show success message to user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Product saved successfully!'),
                backgroundColor: FlutterFlowTheme.of(context).primary,
              ),
            );

            context.pop(); // Go back to previous screen
          } catch (e) {
            Navigator.pop(context); // Close loading dialog

            // Error Handling - Show error message if save fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: FlutterFlowTheme.of(context).error,
              ),
            );
          }
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

  // ============================================================================
  // BOTTOM NAVIGATION WIDGET SECTION - Fixed Bottom Navigation Bar
  // ============================================================================
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
          // Profile Navigation Item - Links to vendor dashboard
          _buildNavItem(Icons.person, 'Profile', false,
              () => context.pushNamed('VendorDashboard')),
          // Discount Code Navigation Item - Links to discount management
          _buildNavItem(Icons.discount_outlined, 'Code', false,
              () => context.pushNamed('ManageDiscountCodes')),
          // Virtual Try-On Navigation Item - Links to virtual try-on settings
          _buildNavItem(Icons.tv_rounded, 'Virtual', false,
              () => context.pushNamed('VirtualTryOnSetting')),
          // Buy Links Navigation Item - Links to buy link settings
          _buildNavItem(Icons.settings_sharp, 'Link', false,
              () => context.pushNamed('SettingBuyLinks')),
          // Add Product Navigation Item - Current active page (no action)
          _buildNavItem(Icons.add, 'Add', true, () => {}),
        ],
      ),
    );
  }

  // ============================================================================
  // NAVIGATION ITEM HELPER WIDGET - Individual Navigation Button Component
  // ============================================================================
  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Navigation Icon - Icon for the navigation item
          Icon(
            icon,
            color:
                isActive ? FlutterFlowTheme.of(context).primary : Colors.white,
            size: 24.0,
          ),
          SizedBox(height: 4.0),
          // Navigation Label - Text label for the navigation item
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

// ============================================================================
// END OF ADD PRODUCT WIDGET CLASS
// ============================================================================

/*
===============================================================================
COMPONENT BREAKDOWN FOR PRESENTATION - EASY REMOVAL GUIDE
===============================================================================

REMOVABLE SECTIONS (from easiest to hardest):

🟢 EASY TO REMOVE (Independent sections):
1. Bottom Navigation Section (Lines ~650-730) - Complete navigation bar
2. Occasion Tags Section (Lines ~590-640) - Choice chips for occasions  
3. Color Selection Section (Lines ~550-590) - Choice chips for colors
4. Description Field (Lines ~520-550) - Optional multi-line text input
5. Buy Link Field (Lines ~480-520) - Optional URL input field

🟡 MEDIUM COMPLEXITY (Form fields with validation):
6. Price Field (Lines ~440-480) - Required numeric input
7. Category Dropdown (Lines ~380-440) - Required dropdown selection
8. Item ID Field (Lines ~340-380) - Required text input with validation
9. Image Upload Section (Lines ~180-340) - Complex image handling

🔴 CORE COMPONENTS (Keep for functionality):
- App Bar Section (Lines ~80-100) - Top navigation
- Product Name Field (Lines ~300-340) - Essential product info
- Save Button Section (Lines ~640-650) - Form submission
- Form structure and validation logic

===============================================================================
HELPER METHODS:
- _selectImage() (Lines ~340-370) - Image selection functionality
- _buildNavItem() (Lines ~730-760) - Navigation item builder

Each section is clearly marked with comment headers using === symbols
and can be easily identified and removed during your presentation.
===============================================================================
*/
