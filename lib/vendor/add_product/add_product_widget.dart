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

    // Initialize existing text controllers
    _model.itemNameTextController ??= TextEditingController();
    _model.itemNameFocusNode ??= FocusNode();

    _model.categoryTextController ??= TextEditingController();
    _model.categoryFocusNode ??= FocusNode();

    // Initialize missing text controllers
    _model.priceTextController ??= TextEditingController();
    _model.priceFocusNode ??= FocusNode();

    _model.buyLinkTextController ??= TextEditingController();
    _model.buyLinkFocusNode ??= FocusNode();

    _model.descriptionTextController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();
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
            child: _model.uploadedLocalFile != null &&
                    _model.uploadedLocalFile.bytes?.isNotEmpty == true
                ? Image.memory(
                    _model.uploadedLocalFile.bytes!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
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
                onPressed: () async {
                  final selectedMedia = await selectMediaWithSourceBottomSheet(
                    context: context,
                    allowPhoto: true,
                    allowVideo: false,
                  );

                  if (selectedMedia != null &&
                      selectedMedia.every(
                          (m) => validateFileFormat(m.storagePath, context))) {
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Item name is required';
            }
            return null;
          },
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Category is required';
            }
            return null;
          },
        ),

        SizedBox(height: 16.0),

        // Price Field
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

        // Buy Link Field
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

        // Description Field
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

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: FFButtonWidget(
        onPressed: () async {
          if (_model.formKey.currentState == null ||
              !_model.formKey.currentState!.validate()) {
            return;
          }

          // Show loading
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );

          try {
            String? imageUrl;

            // Upload image if selected
            if (_model.uploadedLocalFile != null &&
                _model.uploadedLocalFile.bytes?.isNotEmpty == true) {
              // Upload to Firebase Storage
              final storageRef = FirebaseStorage.instance.ref().child(
                  'product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

              final uploadTask =
                  await storageRef.putData(_model.uploadedLocalFile.bytes!);
              imageUrl = await uploadTask.ref.getDownloadURL();
            }

            // Create the product in Firestore
            await BrandedItemsRecord.collection
                .add(createBrandedItemsRecordData(
              vendorId: currentUserUid,
              name: _model.itemNameTextController?.text ?? '',
              category: _model.categoryTextController?.text ?? '',
              price: double.tryParse(_model.priceTextController?.text ?? '0') ??
                  0.0,
              productUrl: _model.buyLinkTextController?.text ?? '',
              description: _model.descriptionTextController?.text ?? '',
              imageUrl: imageUrl ?? '',
              dateAdded: getCurrentTimestamp,
            ))
                .then((docRef) async {
              // Update with style tags and weather suitability if needed
              await docRef.update({
                'style_tags': [_model.choiceChipsValue2 ?? 'Casual'],
                'weather_suitability': [],
              });
            });

            Navigator.pop(context); // Close loading dialog

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Product saved successfully!'),
                backgroundColor: FlutterFlowTheme.of(context).primary,
              ),
            );

            context.pop(); // Go back to previous screen
          } catch (e) {
            Navigator.pop(context); // Close loading dialog
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
              () => context.pushNamed('VendorDashboard')),
          _buildNavItem(Icons.discount_outlined, 'Code', false,
              () => context.pushNamed('ManageDiscountCodes')),
          _buildNavItem(Icons.tv_rounded, 'Virtual', false,
              () => context.pushNamed('VirtualTryOnSetting')),
          _buildNavItem(Icons.settings_sharp, 'Link', false,
              () => context.pushNamed('SettingBuyLinks')),
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
