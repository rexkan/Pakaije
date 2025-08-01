import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pakaije/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = CreateAccountModel();
    _model.initState(context);
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

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Profile image uploaded successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _model.isDataUploading = false;
          });
        }
      }
    }
  }

  /// Helper method to determine account status based on role
  String _getAccountStatusForRole(String role) {
    final normalizedRole = role.toLowerCase();
    switch (normalizedRole) {
      case 'user':
        return 'active';
      case 'vendor':
      case 'admin':
        return 'pending';
      default:
        return 'active';
    }
  }

  /// Helper method to get appropriate success message based on role
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
    // Trigger final validation
    setState(() {
      _model.validateUsernameRealTime();
      _model.validatePhoneRealTime();
      _model.validateEmailRealTime();
      _model.validatePasswordRealTime();
      _model.validatePasswordConfirmRealTime();
    });

    // Check if form is valid
    if (!_model.isFormValid) {
      _showErrorSnackBar('Please fix all validation errors before continuing');
      return;
    }

    try {
      // Create user with Firebase Auth
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _model.getTrimmedText(_model.emailAddressTextController),
        password: _model.passwordTextController.text,
      );

      if (credential.user != null) {
        // Send email verification
        await credential.user!.sendEmailVerification();

        // Determine account status based on role
        final selectedRole = _model.choiceChipsValue1 ?? 'User';
        final accountStatus = _getAccountStatusForRole(selectedRole);

        // Create user document in Firestore
        await _createUserDocument(
            credential.user!, selectedRole, accountStatus);

        // Show success dialog
        await _showSuccessDialog(selectedRole, accountStatus);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error creating account: $e');
      }
    }
  }

  /// Create user document in Firestore
  Future<void> _createUserDocument(
      User user, String selectedRole, String accountStatus) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': _model.getTrimmedText(_model.emailAddressTextController),
      'display_name': _model.getTrimmedText(_model.usernameTextController),
      'uid': user.uid,
      'created_time': Timestamp.now(),
      'role': selectedRole,
      'account_status': accountStatus,
      'gender': _model.choiceChipsValue2,
      'phone_number': _model.getTrimmedText(_model.phoneNumberTextController),
      'photo_url': _model.uploadedFileUrl.isNotEmpty
          ? _model.uploadedFileUrl
          : 'https://firebasestorage.googleapis.com/v0/b/pakaije-89pzxl.firebasestorage.app/o/user_848006.png?alt=media&token=1b4c4e8e-31b7-459a-936f-3452f57b1da4',
    });
  }

  /// Show success dialog with role-specific message
  Future<void> _showSuccessDialog(
      String selectedRole, String accountStatus) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Account Created Successfully'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'We sent a verification link to your email. Please verify before logging in.'),
            const SizedBox(height: 12),
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
              Navigator.of(context).pop();
              Future.delayed(Duration.zero, () {
                context.pushNamed(LoginPageWidget.routeName);
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    _showSuccessSnackBar(_getSuccessMessageForRole(selectedRole));
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Helper method to show error snackbar
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  /// Helper method to show success snackbar
  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green[600],
        ),
      );
    }
  }

  Widget _buildChoiceChips(
    List<String> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
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

  /// Enhanced text field with real-time validation
  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required ValidationResult? validation,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? helperText,
    Widget? customSuffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
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
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
                    letterSpacing: 0.0,
                  ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _getBorderColor(validation),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _getFocusedBorderColor(validation),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red[600]!,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red[600]!,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).blankCanvas,
              suffixIcon: customSuffix ??
                  suffixIcon ??
                  _buildValidationIcon(validation),
              // Remove helperText from InputDecoration to avoid overflow
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  ),
                  letterSpacing: 0.0,
                ),
          ),
          // Add helper text as separate widget with proper wrapping
          if (helperText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 12.0, right: 12.0),
              child: Text(
                helperText,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  height: 1.3, // Better line height for readability
                ),
                maxLines: 3, // Allow up to 3 lines
                overflow: TextOverflow.visible, // Don't truncate text
                softWrap: true, // Enable text wrapping
              ),
            ),
          if (validation?.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 12.0, right: 12.0),
              child: Text(
                validation!.errorMessage!,
                style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 12,
                  height: 1.3,
                ),
                maxLines: 2, // Allow error messages to wrap
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
        ],
      ),
    );
  }

  Color _getBorderColor(ValidationResult? validation) {
    if (validation == null)
      return FlutterFlowTheme.of(context).primaryBackground;
    if (validation.isValid) return Colors.green[400]!;
    return Colors.red[400]!;
  }

  Color _getFocusedBorderColor(ValidationResult? validation) {
    if (validation == null) return FlutterFlowTheme.of(context).primary;
    if (validation.isValid) return Colors.green[600]!;
    return Colors.red[600]!;
  }

  Widget? _buildValidationIcon(ValidationResult? validation) {
    if (validation == null) return null;

    if (validation.isValid) {
      return Icon(
        Icons.check_circle,
        color: Colors.green[600],
      );
    } else {
      return Icon(
        Icons.error,
        color: Colors.red[600],
      );
    }
  }

  /// Password field with strength indicator
  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required ValidationResult? validation,
    required bool obscureText,
    required VoidCallback onVisibilityToggle,
    bool showStrengthIndicator = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEnhancedTextField(
          controller: controller,
          focusNode: focusNode,
          labelText: labelText,
          validation: validation,
          obscureText: obscureText,
          customSuffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (validation?.isValid == true && !showStrengthIndicator)
                Icon(Icons.check_circle, color: Colors.green[600])
              else if (validation?.isValid == false)
                Icon(Icons.error, color: Colors.red[600]),
              const SizedBox(width: 8),
              InkWell(
                onTap: onVisibilityToggle,
                child: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
          helperText: showStrengthIndicator
              ? 'Password must contain: uppercase, lowercase,\nnumber, and special character'
              : null,
        ),
        if (showStrengthIndicator && validation?.passwordStrength != null)
          _buildPasswordStrengthIndicator(validation!.passwordStrength!),
      ],
    );
  }

  /// Password strength indicator widget
  Widget _buildPasswordStrengthIndicator(PasswordStrength strength) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Password strength: ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                _model.getPasswordStrengthText(strength),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _model.getPasswordStrengthColor(strength),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: _getStrengthValue(strength),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _model.getPasswordStrengthColor(strength),
            ),
          ),
        ],
      ),
    );
  }

  double _getStrengthValue(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return 0.2;
      case PasswordStrength.weak:
        return 0.4;
      case PasswordStrength.fair:
        return 0.6;
      case PasswordStrength.good:
        return 0.8;
      case PasswordStrength.strong:
        return 1.0;
    }
  }

  Widget _buildProfileImageSelector() {
    return Center(
      child: GestureDetector(
        onTap: _selectImage,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
            border: Border.all(
              color: _model.uploadedFileUrl.isNotEmpty
                  ? Colors.green[400]!
                  : Colors.grey[400]!,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              _model.uploadedFileUrl.isNotEmpty
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
              if (_model.isDataUploading)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FlutterFlowTheme.of(context).underground,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a role *',
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
        if (_model.choiceChipsValue1 != null &&
            _model.choiceChipsValue1 != 'User')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[700], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _model.choiceChipsValue1 == 'Vendor'
                          ? 'Vendor accounts require admin approval before you can sign in.'
                          : 'Admin accounts require approval before you can sign in.',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_model.choiceChipsValue1 == null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text(
              'Please select a role',
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGenderSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender *',
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
        if (_model.choiceChipsValue2 == null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0),
            child: Text(
              'Please select a gender',
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCreateButton() {
    final isFormValid = _model.isFormValid;

    return Center(
      child: ElevatedButton(
        onPressed: isFormValid ? _createAccount : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid
              ? FlutterFlowTheme.of(context).underground
              : Colors.grey[400],
          minimumSize: const Size(200, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: isFormValid ? 3.0 : 0.0,
        ),
        child: Text(
          'Create Account',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
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
          child: Form(
            key: _formKey,
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
                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      'Join us today! Please fill in your details below.',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildProfileImageSelector(),
                  const SizedBox(height: 32),

                  _buildRoleSelectionSection(),
                  const SizedBox(height: 16),

                  _buildEnhancedTextField(
                    controller: _model.usernameTextController,
                    focusNode: _model.usernameFocusNode,
                    labelText: 'Username *',
                    validation: _model.usernameValidation,
                    helperText:
                        'Username must be 3-30 characters with letters, numbers, dots, hyphens, or underscores',
                  ),

                  _buildEnhancedTextField(
                    controller: _model.phoneNumberTextController,
                    focusNode: _model.phoneNumberFocusNode,
                    labelText: 'Phone number *',
                    validation: _model.phoneValidation,
                    keyboardType: TextInputType.phone,
                    helperText:
                        'Enter your phone number with country code\n(e.g., +1234567890)',
                  ),

                  _buildEnhancedTextField(
                    controller: _model.emailAddressTextController,
                    focusNode: _model.emailAddressFocusNode,
                    labelText: 'Email *',
                    validation: _model.emailValidation,
                    keyboardType: TextInputType.emailAddress,
                    helperText:
                        'We\'ll use this email for account verification\nand notifications',
                  ),

                  _buildPasswordField(
                    controller: _model.passwordTextController,
                    focusNode: _model.passwordFocusNode,
                    labelText: 'Password *',
                    validation: _model.passwordValidation,
                    obscureText: !_model.passwordVisibility,
                    onVisibilityToggle: () => setState(() =>
                        _model.passwordVisibility = !_model.passwordVisibility),
                    showStrengthIndicator: true,
                  ),

                  _buildPasswordField(
                    controller: _model.passwordConfirmTextController,
                    focusNode: _model.passwordConfirmFocusNode,
                    labelText: 'Confirm Password *',
                    validation: _model.passwordConfirmValidation,
                    obscureText: !_model.passwordConfirmVisibility,
                    onVisibilityToggle: () => setState(() =>
                        _model.passwordConfirmVisibility =
                            !_model.passwordConfirmVisibility),
                  ),

                  _buildGenderSelectionSection(),
                  const SizedBox(height: 32),

                  _buildCreateButton(),
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

                  const SizedBox(height: 16),

                  // Form validation summary
                  if (_model.usernameValidation != null ||
                      _model.phoneValidation != null ||
                      _model.emailValidation != null ||
                      _model.passwordValidation != null ||
                      _model.passwordConfirmValidation != null)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: _model.isFormValid
                            ? Colors.green[50]
                            : Colors.red[50],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: _model.isFormValid
                              ? Colors.green[200]!
                              : Colors.red[200]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _model.isFormValid
                                ? Icons.check_circle
                                : Icons.error,
                            color: _model.isFormValid
                                ? Colors.green[700]
                                : Colors.red[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _model.isFormValid
                                  ? 'All fields are valid! You can create your account.'
                                  : 'Please fix the validation errors above.',
                              style: TextStyle(
                                color: _model.isFormValid
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
