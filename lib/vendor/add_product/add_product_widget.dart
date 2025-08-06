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

// ================================================================================
// SECTION 1: MAIN WIDGET CLASS DECLARATION
// ================================================================================
// 🔴 CORE COMPONENT - This is the main widget class structure
// PURPOSE: Defines the main StatefulWidget for the add product page
// REMOVAL IMPACT: Cannot remove - this is the core widget structure
// COMPONENTS: StatefulWidget class, route names, and state creation
// ================================================================================

class AddProductWidget extends StatefulWidget {
  const AddProductWidget({super.key});

  static String routeName = 'AddProduct';
  static String routePath = '/addProduct';

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

// ================================================================================
// SECTION 2: STATE CLASS AND INITIALIZATION
// ================================================================================
// 🔴 CORE COMPONENT - Contains essential state management and form controllers
// PURPOSE: Manages page state, form controllers, and widget lifecycle
// REMOVAL IMPACT: Cannot remove - required for page functionality
// COMPONENTS: State class, text controllers, focus nodes, form field controllers
// ================================================================================

class _AddProductWidgetState extends State<AddProductWidget> {
  late AddProductModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddProductModel());

    // Initialize Text Controllers and Focus Nodes
    _model.itemNameTextController ??= TextEditingController();
    _model.itemNameFocusNode ??= FocusNode();

    _model.itemIdTextController ??= TextEditingController();
    _model.itemIdFocusNode ??= FocusNode();

    _model.priceTextController ??= TextEditingController();
    _model.priceFocusNode ??= FocusNode();

    _model.buyLinkTextController ??= TextEditingController();
    _model.buyLinkFocusNode ??= FocusNode();

    _model.descriptionTextController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();

    // Initialize Form Field Controllers
    _model.categoryDropDownValueController = FormFieldController<String>(null);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

// ================================================================================
// SECTION 3: IMAGE SELECTION HELPER METHOD
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Image selection and upload handling
// PURPOSE: Handles image selection from device gallery/camera with validation
// REMOVAL IMPACT: Can be removed - will disable image upload functionality
// COMPONENTS: Media selection, file validation, upload state management
// ================================================================================

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

// ================================================================================
// SECTION 4: MAIN BUILD METHOD
// ================================================================================
// 🔴 CORE COMPONENT - Main page layout structure
// PURPOSE: Builds the main scaffold and page structure
// REMOVAL IMPACT: Cannot remove - this is the core page structure
// COMPONENTS: Scaffold with AppBar, Form sections, and Bottom Navigation
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
        // SUB-SECTION 4A: APP BAR
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
        // SUB-SECTION 4B: BODY LAYOUT
        // ========================================================================
        // 🔴 CORE COMPONENT - Main content area layout with form
        // PURPOSE: Contains all form sections in scrollable format
        // REMOVAL IMPACT: Cannot remove - essential for content display
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
                        // Image Upload Section
                        _buildImageUploadSection(),

                        SizedBox(height: 24.0),

                        // Product Details Section
                        _buildProductDetailsSection(),

                        SizedBox(height: 24.0),

                        // Color Selection Section
                        _buildColorSection(),

                        SizedBox(height: 24.0),

                        // Occasion Tags Section
                        _buildOccasionTagsSection(),

                        SizedBox(height: 32.0),

                        // Save Button Section
                        _buildSaveButton(),

                        SizedBox(height: 80.0), // Space for bottom navigation
                      ],
                    ),
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
// SECTION 5: IMAGE UPLOAD SECTION
// ================================================================================
// 🟡 MEDIUM COMPLEXITY - Image upload interface with preview and controls
// PURPOSE: Provides image upload, preview, edit, and remove functionality
// REMOVAL IMPACT: Can be removed - will disable image upload feature
// COMPONENTS: Upload area, image preview, loading overlay, edit/remove buttons
// ================================================================================

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'Product Image',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16.0),

        // Image Upload Card
        _buildSingleImageUploadCard(),
      ],
    );
  }

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
          // Image Display Area
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

          // Loading Overlay
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

          // Edit Button (when image is selected)
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

          // Remove Button (when image is selected)
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

          // Tap Area for Image Selection (when no image)
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

// ================================================================================
// SECTION 6: PRODUCT DETAILS SECTION
// ================================================================================
// 🔴 CORE COMPONENT - Main product information form fields
// PURPOSE: Provides essential product information input fields
// REMOVAL IMPACT: Major impact - core product data entry functionality
// COMPONENTS: Product name, item ID, category, price, buy link, description fields
// ================================================================================

  Widget _buildProductDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'Product Details',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 16.0),

        // Product Name Field (Required)
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

        // Item ID Field (Required)
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

        // Category Dropdown Field (Required)
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

        // Price Field (Required)
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

        // Buy Link Field (Optional)
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

        // Description Field (Optional)
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

// ================================================================================
// SECTION 7: COLOR SELECTION SECTION
// ================================================================================
// 🟢 EASY TO REMOVE - Color choice chips for product color selection
// PURPOSE: Provides color selection interface using choice chips
// REMOVAL IMPACT: Can be removed - will disable color selection feature
// COMPONENTS: Section header, FlutterFlowChoiceChips with color options
// ================================================================================

  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'Color',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 12.0),

        // Color Choice Chips
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

// ================================================================================
// SECTION 8: OCCASION TAGS SECTION
// ================================================================================
// 🟢 EASY TO REMOVE - Occasion choice chips for product categorization
// PURPOSE: Provides occasion/style tag selection interface using choice chips
// REMOVAL IMPACT: Can be removed - will disable occasion tag selection feature
// COMPONENTS: Section header, FlutterFlowChoiceChips with occasion options
// ================================================================================

  Widget _buildOccasionTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'Occasion Tags',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                fontFamily: 'Inter Tight',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 12.0),

        // Occasion Choice Chips
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

// ================================================================================
// SECTION 9: SAVE BUTTON SECTION
// ================================================================================
// 🔴 CORE COMPONENT - Product save functionality with Firebase integration
// PURPOSE: Handles form validation, image upload, and product creation in Firebase
// REMOVAL IMPACT: Cannot remove - essential for product creation functionality
// COMPONENTS: Form validation, Firebase Storage upload, Firestore document creation
// ================================================================================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: FFButtonWidget(
        onPressed: () async {
          // Form Validation
          if (_model.formKey.currentState == null ||
              !_model.formKey.currentState!.validate()) {
            return;
          }

          // Show Loading Dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );

          try {
            String? imageUrl;

            // Upload Image to Firebase Storage (if selected)
            if (_model.uploadedLocalFile != null &&
                _model.uploadedLocalFile.bytes?.isNotEmpty == true) {
              final storageRef = FirebaseStorage.instance.ref().child(
                  'product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

              final uploadTask =
                  await storageRef.putData(_model.uploadedLocalFile.bytes!);
              imageUrl = await uploadTask.ref.getDownloadURL();
            }

            // Create Product Document in Firestore
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
              // Update with Additional Metadata
              await docRef.update({
                'style_tags': [_model.choiceChipsValue2 ?? 'Casual'],
                'weather_suitability': [],
              });
            });

            Navigator.pop(context); // Close loading dialog

            // Success Feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Product saved successfully!'),
                backgroundColor: FlutterFlowTheme.of(context).primary,
              ),
            );

            context.pop(); // Navigate back to previous screen
          } catch (e) {
            Navigator.pop(context); // Close loading dialog

            // Error Feedback
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

// ================================================================================
// SECTION 10: BOTTOM NAVIGATION WIDGET
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

          // Discount Codes Navigation Item
          _buildNavItem(Icons.discount_outlined, 'Code', false,
              () => context.pushNamed('ManageDiscountCodes')),

          // Virtual Try-On Navigation Item
          _buildNavItem(Icons.tv_rounded, 'Virtual', false,
              () => context.pushNamed('VirtualTryOnSetting')),

          // Buy Links Navigation Item
          _buildNavItem(Icons.settings_sharp, 'Link', false,
              () => context.pushNamed('SettingBuyLinks')),

          // Add Product Navigation Item (Current Page)
          _buildNavItem(Icons.add, 'Add', true, () => {}),
        ],
      ),
    );
  }

// ================================================================================
// SECTION 11: NAVIGATION ITEM HELPER WIDGET
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

// ================================================================================
// END OF ADD PRODUCT WIDGET
// ================================================================================

/*
===============================================================================
PRESENTATION REMOVAL GUIDE FOR YOUR LECTURER DEMO
===============================================================================

🟢 EASIEST TO REMOVE (Independent components):
1. SECTION 10 & 11: Bottom Navigation (Lines ~700-800) - Complete navigation system
2. SECTION 7: Color Selection Section (Lines ~500-580) - Color choice chips
3. SECTION 8: Occasion Tags Section (Lines ~580-660) - Occasion choice chips
4. SECTION 5: Image Upload Section (Lines ~200-350) - Complete image upload functionality
5. Optional Fields in SECTION 6: Buy Link and Description fields

🟡 MEDIUM COMPLEXITY (Feature removal):
6. SECTION 3: Image Selection Method (Lines ~60-120) - Image selection logic
7. Image Upload Logic in SECTION 9 (Firebase Storage upload)
8. Form Validation in SECTION 6 (Individual field validators)
9. Loading States and Error Handling in SECTION 9

🔴 CORE COMPONENTS (Keep for basic functionality):
- SECTION 1: Main Widget Class - Essential structure
- SECTION 2: State Class - Required controllers and state
- SECTION 4: Main Build Method - Core page layout
- SECTION 6: Product Details Section - Essential form fields (name, ID, category, price)
- SECTION 9: Save Button Section - Core save functionality (simplified version)

PRESENTATION STRATEGY:
1. Start by removing SECTION 10 & 11 (Bottom Navigation) - Clean removal
2. Remove SECTION 7 & 8 (Color and Occasion sections) - Simplifies form
3. Remove SECTION 5 (Image Upload) - Removes complex upload interface
4. Remove SECTION 3 (Image Selection Method) - Cleanup unused methods
5. Simplify SECTION 6 by removing optional fields (buy link, description)
6. Simplify SECTION 9 by removing image upload logic and keeping basic save

UNIQUE FEATURES TO HIGHLIGHT:
- Comprehensive form validation
- Image upload with preview and controls
- Choice chips for selection interfaces
- Firebase Storage integration
- Real-time form validation
- Professional loading states and error handling

CORE FUNCTIONALITY RETAINED:
- Product name, ID, category, price input
- Basic form validation
- Simple Firebase document creation
- Success/error feedback

The Add Product page demonstrates a complete CRUD operation with file uploads!
Each section is clearly marked with numbered headers and difficulty indicators.
===============================================================================
*/
