import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'user_profile_model.dart';
export 'user_profile_model.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({super.key});

  static String routeName = 'UserProfile';
  static String routePath = '/userProfile';

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  late UserProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserProfileModel());

    // Model's initState will load user data automatically

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Method to handle image upload from gallery
  Future<void> _uploadImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _model.setUploadedImage(image.path);
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Image uploaded successfully! Click Save to confirm.'),
            backgroundColor: FlutterFlowTheme.of(context).underground,
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image. Please try again.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  // Method to save the uploaded image
  void _saveImage() async {
    try {
      await _model.saveUploadedImage();
      setState(() {});

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Body view image saved successfully!'),
            backgroundColor: FlutterFlowTheme.of(context).underground,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save image: ${e.toString()}'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  // Method to handle profile update
  void _updateProfile() async {
    try {
      await _model.updateUserProfile();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: FlutterFlowTheme.of(context).underground,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
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
            FFLocalizations.of(context).getText(
              'zwwzyv36' /* User Profile */,
            ),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: _model.isLoadingUser
              ? Center(
                  child: CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).underground,
                  ),
                )
              : _model.errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.0,
                            color: FlutterFlowTheme.of(context).error,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Error loading profile',
                            style: FlutterFlowTheme.of(context).headlineSmall,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _model.errorMessage!,
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.0),
                          FFButtonWidget(
                            onPressed: () {
                              setState(() {
                                _model.loadCurrentUserData();
                              });
                            },
                            text: 'Retry',
                            options: FFButtonOptions(
                              width: 120.0,
                              height: 40.0,
                              color: FlutterFlowTheme.of(context).underground,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.interTight(),
                                    color: Colors.white,
                                  ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                30.0, 15.0, 30.0, 0.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Information Section
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 5.0, 0.0),
                                        child: FlutterFlowIconButton(
                                          borderRadius: 8.0,
                                          buttonSize: 40.0,
                                          icon: FaIcon(
                                            FontAwesomeIcons.addressCard,
                                            color: FlutterFlowTheme.of(context)
                                                .underground,
                                            size: 24.0,
                                          ),
                                          onPressed: () {
                                            print('IconButton pressed ...');
                                          },
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: Text(
                                          FFLocalizations.of(context).getText(
                                            'kzujog58' /* Information */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .underground,
                                                fontSize: 20.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 2.0),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          15.0, 15.0, 15.0, 15.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'yy7glkn6' /* Username: */,
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  _model.getDisplayName(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .underground,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.0),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'ylpfyxj0' /* Gender: */,
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  _model.getUserGender(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .underground,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.0),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  'f825olxn' /* Email: */,
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    _model.getUserEmail(),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .underground,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Body View Section
                                  SizedBox(height: 35.0),
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        'ki7tg1yu' /* Body View: */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .underground,
                                            fontSize: 20.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  // Single centered image - now showing user's image
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: _model.isLocalImage()
                                          ? Image.file(
                                              File(_model.uploadedImagePath!),
                                              width: 180.0,
                                              height: 300.0,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              _model.getUserProfileImage(),
                                              width: 180.0,
                                              height: 300.0,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  width: 180.0,
                                                  height: 300.0,
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 64.0,
                                                    color: Colors.grey[600],
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  // Updated button section with both Upload and Save buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Upload Button
                                      FFButtonWidget(
                                        onPressed: _uploadImageFromGallery,
                                        text:
                                            FFLocalizations.of(context).getText(
                                          'om941oto' /* Upload */,
                                        ),
                                        options: FFButtonOptions(
                                          width: 100.0,
                                          height: 30.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .underground,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      // Save Button
                                      FFButtonWidget(
                                        onPressed: _model.hasUploadedNewImage
                                            ? _saveImage
                                            : null,
                                        text: 'Save',
                                        options: FFButtonOptions(
                                          width: 100.0,
                                          height: 30.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: _model.hasUploadedNewImage
                                              ? FlutterFlowTheme.of(context)
                                                  .waxFlower
                                              : Colors.grey[400],
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Update Profile Details Section (Card Design)
                                  SizedBox(height: 35.0),
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        'eu6fuvgb' /* Update Profile Details: */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .underground,
                                            fontSize: 20.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 2.0),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20.0, 20.0, 20.0, 20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Username Field
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Username',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                              SizedBox(height: 8.0),
                                              TextFormField(
                                                controller: _model
                                                    .usernameTextController,
                                                focusNode:
                                                    _model.usernameFocusNode,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  hintText:
                                                      'Enter your username',
                                                  hintStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .labelMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.inter(),
                                                        color: Colors.grey[600],
                                                        letterSpacing: 0.0,
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.grey[300]!,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(12.0, 12.0,
                                                              12.0, 12.0),
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      letterSpacing: 0.0,
                                                    ),
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .underground,
                                                validator: _model
                                                    .usernameTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20.0),
                                          // Password Field
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Password',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                              SizedBox(height: 8.0),
                                              TextFormField(
                                                controller: _model
                                                    .passwordTextController,
                                                focusNode:
                                                    _model.passwordFocusNode,
                                                autofocus: false,
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  hintText:
                                                      'Enter new password',
                                                  hintStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .labelMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.inter(),
                                                        color: Colors.grey[600],
                                                        letterSpacing: 0.0,
                                                      ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.grey[300]!,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  contentPadding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(12.0, 12.0,
                                                              12.0, 12.0),
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      letterSpacing: 0.0,
                                                    ),
                                                cursorColor:
                                                    FlutterFlowTheme.of(context)
                                                        .underground,
                                                validator: _model
                                                    .passwordTextControllerValidator
                                                    .asValidator(context),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 25.0),
                                          // Update Button - Enhanced styling and text
                                          Align(
                                            alignment:
                                                AlignmentDirectional(1.0, 0.0),
                                            child: FFButtonWidget(
                                              onPressed: _updateProfile,
                                              text: 'Update',
                                              options: FFButtonOptions(
                                                width: 120.0,
                                                height: 40.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 0.0, 16.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .underground,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                                elevation: 2.0,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          100.0), // Add bottom spacing for nav bar
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
        // Modern Bottom Navigation Bar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).underground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.0,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.home_rounded,
                    label: FFLocalizations.of(context)
                        .getText('hk89n3i3' /* Home */),
                    isActive: false,
                    onTap: () => context.pushNamed(HomePageWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.checkroom_rounded,
                    label: FFLocalizations.of(context)
                        .getText('6zqt65w8' /* Wardrobe */),
                    isActive: false,
                    onTap: () => context.pushNamed(MyWardrodeWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.style_rounded,
                    label: FFLocalizations.of(context)
                        .getText('lro74946' /* Match */),
                    isActive: false,
                    onTap: () => context.pushNamed(OutfitMatchWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.shopping_bag_rounded,
                    label: FFLocalizations.of(context)
                        .getText('zb5cyhgc' /* Shop */),
                    isActive: false,
                    onTap: () => context.pushNamed(BuyClothesWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.calendar_month_rounded,
                    label: FFLocalizations.of(context)
                        .getText('3odu0pvd' /* Calendar */),
                    isActive: false,
                    onTap: () =>
                        context.pushNamed(OutfitPlanner2Widget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.person_rounded,
                    label: FFLocalizations.of(context)
                        .getText('120dmwbn' /* Profile */),
                    isActive: true, // This is the current page
                    onTap: () {
                      // Already on profile page
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: isActive
              ? FlutterFlowTheme.of(context).waxFlower.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.0,
              color: isActive
                  ? FlutterFlowTheme.of(context).waxFlower
                  : FlutterFlowTheme.of(context).info,
            ),
            SizedBox(height: 4.0),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.inter(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                    color: isActive
                        ? FlutterFlowTheme.of(context).waxFlower
                        : FlutterFlowTheme.of(context).info,
                    fontSize: 11.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
