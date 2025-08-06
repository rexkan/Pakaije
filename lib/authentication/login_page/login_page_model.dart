import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'login_page_widget.dart' show LoginPageWidget;
import 'package:flutter/material.dart';

// Enhanced validation result class
class LoginValidationResult {
  final bool isValid;
  final String? errorMessage;

  LoginValidationResult({required this.isValid, this.errorMessage});

  static LoginValidationResult valid() => LoginValidationResult(isValid: true);
  static LoginValidationResult invalid(String message) =>
      LoginValidationResult(isValid: false, errorMessage: message);
}

class LoginPageModel extends FlutterFlowModel<LoginPageWidget> {
  // State fields for form widgets
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;

  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;

  // Enhanced state management
  bool isLoading = false;

  // Real-time validation states
  LoginValidationResult? emailValidation;
  LoginValidationResult? passwordValidation;

  // User data
  UsersRecord? currentUserDoc;

  // Validation constants
  static const String emailRegexPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  /// Enhanced email validation
  LoginValidationResult validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return LoginValidationResult.invalid('Email is required');
    }

    final trimmed = value.trim();

    if (!RegExp(emailRegexPattern).hasMatch(trimmed)) {
      return LoginValidationResult.invalid(
          'Please enter a valid email address');
    }

    return LoginValidationResult.valid();
  }

  /// Enhanced password validation
  LoginValidationResult validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LoginValidationResult.invalid('Password is required');
    }

    if (value.length < 6) {
      return LoginValidationResult.invalid(
          'Password must be at least 6 characters');
    }

    return LoginValidationResult.valid();
  }

  /// Real-time validation methods
  void validateEmailRealTime() {
    emailValidation = validateEmail(emailAddressTextController?.text);
  }

  void validatePasswordRealTime() {
    passwordValidation = validatePassword(passwordTextController?.text);
  }

  /// Check if form is valid
  bool get isFormValid {
    return emailValidation?.isValid == true &&
        passwordValidation?.isValid == true;
  }

  /// Get user-friendly error message (simplified without enumeration prevention)
  String getUserFriendlyErrorMessage(String error) {
    final errorLower = error.toLowerCase();

    if (errorLower.contains('user-not-found')) {
      return 'No account found with this email address.';
    } else if (errorLower.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (errorLower.contains('too-many-requests')) {
      return 'Too many failed attempts. Please try again later.';
    } else if (errorLower.contains('network')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorLower.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else {
      return 'Login failed: ' + error;
    }
  }

  /// Validate form before submission
  bool validateForm() {
    validateEmailRealTime();
    validatePasswordRealTime();
    return isFormValid;
  }

  /// Get trimmed email
  String get trimmedEmail => emailAddressTextController?.text.trim() ?? '';

  /// Get password
  String get password => passwordTextController?.text ?? '';

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;

    // Initialize controllers if not already done
    emailAddressTextController ??= TextEditingController();
    passwordTextController ??= TextEditingController();

    emailAddressFocusNode ??= FocusNode();
    passwordFocusNode ??= FocusNode();

    // Add real-time validation listeners
    emailAddressTextController?.addListener(validateEmailRealTime);
    passwordTextController?.addListener(validatePasswordRealTime);
  }

  @override
  void dispose() {
    // Remove listeners before disposing
    emailAddressTextController?.removeListener(validateEmailRealTime);
    passwordTextController?.removeListener(validatePasswordRealTime);

    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
