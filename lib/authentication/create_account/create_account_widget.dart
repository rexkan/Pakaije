import 'dart:io';
import 'package:flutter/gestures.dart';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pakaije/flutter_flow/flutter_flow_theme.dart';
import 'package:pakaije/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pakaije/authentication/login_page/login_page_widget.dart';
import 'package:pakaije/flutter_flow/flutter_flow_util.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pakaije/authentication/login_page/login_page_widget.dart';
import 'package:pakaije/flutter_flow/flutter_flow_util.dart';

import 'create_account_model.dart';

class CreateAccountWidget extends StatefulWidget {
  const CreateAccountWidget({super.key});

  static const String routeName = 'CreateAccount';
  static const String routePath = '/createAccount';

  @override
  State<CreateAccountWidget> createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  late CreateAccountModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = CreateAccountModel();
    _model.initState(context);
    _model = CreateAccountModel();
    _model.initState(context);

    _model.usernameTextController = TextEditingController();
    _model.usernameFocusNode = FocusNode();
    _model.usernameTextController = TextEditingController();
    _model.usernameFocusNode = FocusNode();

    _model.phoneNumberTextController = TextEditingController();
    _model.phoneNumberFocusNode = FocusNode();
    _model.phoneNumberTextController = TextEditingController();
    _model.phoneNumberFocusNode = FocusNode();

    _model.emailAddressTextController = TextEditingController();
    _model.emailAddressFocusNode = FocusNode();
    _model.emailAddressTextController = TextEditingController();
    _model.emailAddressFocusNode = FocusNode();

    _model.passwordTextController = TextEditingController();
    _model.passwordFocusNode = FocusNode();
    _model.passwordTextController = TextEditingController();
    _model.passwordFocusNode = FocusNode();

    _model.passwordConfirmTextController = TextEditingController();
    _model.passwordConfirmFocusNode = FocusNode();
    _model.passwordConfirmTextController = TextEditingController();
    _model.passwordConfirmFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Colors and styles
  Color get primaryColor => const Color(0xFF4B39EF);
  Color get backgroundColor => FlutterFlowTheme.of(context).secondaryBackground;
  Color get cardColor => Colors.white;
  Color get textColor => const Color(0xFF14181B);
  Color get secondaryTextColor => const Color(0xFF57636C);

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File imageFile = File(image.path);

      setState(() {
        _model.isDataUploading = true;
      });

      try {
        final String fileName =
            'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profile_images')
            .child(fileName);

        final UploadTask uploadTask = storageRef.putFile(imageFile);
        final TaskSnapshot snapshot = await uploadTask;
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _model.uploadedFileUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image uploaded successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      } finally {
        setState(() {
          _model.isDataUploading = false;
        });
      }
    }
  }

  // Helper method to determine account status based on role
  String _getAccountStatusForRole(String role) {
    final normalizedRole = role.toLowerCase();
    switch (normalizedRole) {
      case 'user':
        return 'active';
      case 'vendor':
      case 'admin':
        return 'pending';
      default:
        return 'active'; // Default fallback
    }
  }

  // Helper method to get appropriate success message based on role
  String _getSuccessMessageForRole(String role) {
    final normalizedRole = role.toLowerCase();
    switch (normalizedRole) {
      case 'user':
        return 'Account created successfully! You can now sign in.';
      case 'vendor':
        return 'Vendor account created! Please wait for admin approval before signing in.';
      case 'admin':
        return 'Admin account created! Please wait for approval before signing in.';
      default:
        return 'Account created successfully!';
    }
  }

  Future<void> _createAccount() async {
    if (_model.passwordTextController!.text !=
        _model.passwordConfirmTextController!.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords don\'t match!')),
      );
      return;
    }

    if (!_model.isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _model.emailAddressTextController!.text,
        password: _model.passwordTextController!.text,
      );

      if (credential.user != null) {
        await credential.user!.sendEmailVerification();

        // Determine account status based on role
        final selectedRole = _model.choiceChipsValue1 ?? 'User';
        final accountStatus = _getAccountStatusForRole(selectedRole);

        // Create user document in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'email': _model.emailAddressTextController!.text,
          'display_name': _model.usernameTextController!.text,
          'uid': credential.user!.uid,
          'created_time': Timestamp.now(),
          'role': selectedRole,
          'account_status': accountStatus, // New field instead of is_approved
          'gender': _model.choiceChipsValue2,
          'phone_number': _model.phoneNumberTextController!.text,
          'photo_url': _model.uploadedFileUrl.isNotEmpty
              ? _model.uploadedFileUrl
              : 'https://firebasestorage.googleapis.com/v0/b/pakaije-89pzxl.firebasestorage.app/o/user_848006.png?alt=media&token=1b4c4e8e-31b7-459a-936f-3452f57b1da4',
        });

        // Show success dialog with role-specific message
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Account Created Successfully'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'We sent a verification link to your email. Please verify before logging in.'),
                SizedBox(height: 12),
                Text(
                  _getSuccessMessageForRole(selectedRole),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: accountStatus == 'pending'
                        ? Colors.orange[700]
                        : Colors.green[700],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog first
                  Future.delayed(Duration.zero, () {
                    context.pushNamed(LoginPageWidget.routeName);
                  });
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_getSuccessMessageForRole(selectedRole))),
          );

          await Future.delayed(const Duration(seconds: 1));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating account: $e')),
        );
      }
    }
  }

  Widget _buildChoiceChips(List<String> options, String? selectedValue,
      Function(String?) onChanged) {
    return Wrap(
      spacing: 8.0,
      children: options.map((option) {
        final isSelected = selectedValue == option;
        return ChoiceChip(
          label: Text(
            option,
            style: TextStyle(
              color: isSelected
                  ? FlutterFlowTheme.of(context).info
                  : FlutterFlowTheme.of(context).secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) => onChanged(selected ? option : null),
          backgroundColor: FlutterFlowTheme.of(context).blankCanvas,
          selectedColor: FlutterFlowTheme.of(context).underground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(context).labelMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                ),
                letterSpacing: 0.0,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).primaryBackground,
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
          fillColor: FlutterFlowTheme.of(context).blankCanvas,
          suffixIcon: suffixIcon,
        ),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
              ),
              letterSpacing: 0.0,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Create an account',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).underground,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: GestureDetector(
                    onTap: _selectImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: _model.uploadedFileUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                _model.uploadedFileUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipOval(
                              child: Image.asset(
                                'assets/images/default_profile.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Select a role',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                _buildChoiceChips(
                  ['User', 'Vendor', 'Admin'],
                  _model.choiceChipsValue1,
                  (value) => setState(() => _model.choiceChipsValue1 = value),
                ),
                // Add helpful text for role selection
                if (_model.choiceChipsValue1 != null &&
                    _model.choiceChipsValue1 != 'User')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _model.choiceChipsValue1 == 'Vendor'
                          ? '⚠️ Vendor accounts require admin approval before you can sign in.'
                          : '⚠️ Admin accounts require approval before you can sign in.',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _model.usernameTextController!,
                  focusNode: _model.usernameFocusNode!,
                  labelText: 'Username',
                ),
                _buildTextField(
                  controller: _model.phoneNumberTextController!,
                  focusNode: _model.phoneNumberFocusNode!,
                  labelText: 'Phone number',
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  controller: _model.emailAddressTextController!,
                  focusNode: _model.emailAddressFocusNode!,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  controller: _model.passwordTextController!,
                  focusNode: _model.passwordFocusNode!,
                  labelText: 'Password',
                  obscureText: !_model.passwordVisibility,
                  suffixIcon: InkWell(
                    onTap: () => setState(() =>
                        _model.passwordVisibility = !_model.passwordVisibility),
                    child: Icon(
                      _model.passwordVisibility
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: secondaryTextColor,
                    ),
                  ),
                ),
                _buildTextField(
                  controller: _model.passwordConfirmTextController!,
                  focusNode: _model.passwordConfirmFocusNode!,
                  labelText: 'Confirm Password',
                  obscureText: !_model.passwordConfirmVisibility,
                  suffixIcon: InkWell(
                    onTap: () => setState(() =>
                        _model.passwordConfirmVisibility =
                            !_model.passwordConfirmVisibility),
                    child: Icon(
                      _model.passwordConfirmVisibility
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: secondaryTextColor,
                    ),
                  ),
                ),
                Text(
                  'Gender',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                _buildChoiceChips(
                  ['Woman', 'Man', 'Others'],
                  _model.choiceChipsValue2,
                  (value) => setState(() => _model.choiceChipsValue2 = value),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _createAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).underground,
                      minimumSize: const Size(200, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 3.0,
                    ),
                    child: Text(
                      'Create',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign In here',
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).underground,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.pushNamed(LoginPageWidget.routeName);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
