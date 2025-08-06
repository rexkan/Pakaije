import 'dart:typed_data';
import 'package:flutter/material.dart';

// Create a base class for FlutterFlowModel if it doesn't exist
abstract class FlutterFlowModel<T extends StatefulWidget> {
  void initState(BuildContext context);
  void dispose();
}

// Create FFUploadedFile class if it doesn't exist
class FFUploadedFile {
  final Uint8List bytes;
  final String? name;
  final double? height;
  final double? width;
  final String? blurHash;

  FFUploadedFile({
    required this.bytes,
    this.name,
    this.height,
    this.width,
    this.blurHash,
  });
}

enum PasswordStrength { veryWeak, weak, fair, good, strong }

class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final PasswordStrength? passwordStrength;

  ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.passwordStrength,
  });

  static ValidationResult valid() => ValidationResult(isValid: true);
  static ValidationResult invalid(String message) =>
      ValidationResult(isValid: false, errorMessage: message);
}

class CreateAccountModel extends FlutterFlowModel {
  // File upload fields
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  // Role and gender selection
  String? choiceChipsValue1;
  String? get selectedRole => choiceChipsValue1;
  String? choiceChipsValue2;
  String? get selectedGender => choiceChipsValue2;

  // Form field controllers and focus nodes
  late final TextEditingController usernameTextController;
  late final FocusNode usernameFocusNode;

  late final TextEditingController phoneNumberTextController;
  late final FocusNode phoneNumberFocusNode;

  late final TextEditingController emailAddressTextController;
  late final FocusNode emailAddressFocusNode;

  late final TextEditingController passwordTextController;
  late final FocusNode passwordFocusNode;
  late bool passwordVisibility;

  late final TextEditingController passwordConfirmTextController;
  late final FocusNode passwordConfirmFocusNode;
  late bool passwordConfirmVisibility;

  // Real-time validation states
  ValidationResult? usernameValidation;
  ValidationResult? phoneValidation;
  ValidationResult? emailValidation;
  ValidationResult? passwordValidation;
  ValidationResult? passwordConfirmValidation;

  // Enhanced validation constants
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxEmailLength = 254;
  static const int maxPhoneLength = 20;

  // Comprehensive email regex that supports modern email formats
  static const String emailRegexPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // Username regex - alphanumeric, underscore, hyphen, dots allowed
  static const String usernameRegexPattern = r'^[a-zA-Z0-9._-]+$';

  // Enhanced phone regex for international numbers
  static const String phoneRegexPattern =
      r'^\+?[1-9]\d{1,14}$|^[0-9\s\-\(\)\.]{10,20}$';

  // Common weak passwords list (simplified for demo)
  static const List<String> commonPasswords = [
    'password',
    '123456',
    '12345678',
    'qwerty',
    'abc123',
    'password123',
    '111111',
    '123123',
    'admin',
    'letmein'
  ];

  /// Enhanced Username Validation
  ValidationResult validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.invalid('Username is required');
    }

    final trimmed = value.trim();

    if (trimmed.length < minUsernameLength) {
      return ValidationResult.invalid(
          'Username must be at least $minUsernameLength characters');
    }

    if (trimmed.length > maxUsernameLength) {
      return ValidationResult.invalid(
          'Username must be less than $maxUsernameLength characters');
    }

    if (!RegExp(usernameRegexPattern).hasMatch(trimmed)) {
      return ValidationResult.invalid(
          'Username can only contain letters, numbers, dots, hyphens, and underscores');
    }

    if (trimmed.startsWith('.') || trimmed.endsWith('.')) {
      return ValidationResult.invalid(
          'Username cannot start or end with a dot');
    }

    if (trimmed.contains('..')) {
      return ValidationResult.invalid(
          'Username cannot contain consecutive dots');
    }

    return ValidationResult.valid();
  }

  /// Enhanced Phone Number Validation
  ValidationResult validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.invalid('Phone number is required');
    }

    final trimmed = value.trim();

    if (trimmed.length > maxPhoneLength) {
      return ValidationResult.invalid('Phone number is too long');
    }

    // Remove all non-digit characters except + for length check
    final digitsOnly = trimmed.replaceAll(RegExp(r'[^\d+]'), '');

    if (digitsOnly.length < 10) {
      return ValidationResult.invalid(
          'Phone number must have at least 10 digits');
    }

    if (!RegExp(phoneRegexPattern).hasMatch(trimmed)) {
      return ValidationResult.invalid('Please enter a valid phone number');
    }

    return ValidationResult.valid();
  }

  /// Enhanced Email Validation
  ValidationResult validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.invalid('Email is required');
    }

    final trimmed = value.trim();

    if (trimmed.length > maxEmailLength) {
      return ValidationResult.invalid('Email address is too long');
    }

    if (!RegExp(emailRegexPattern).hasMatch(trimmed)) {
      return ValidationResult.invalid('Please enter a valid email address');
    }

    // Additional email format checks
    if (trimmed.contains('..')) {
      return ValidationResult.invalid('Email cannot contain consecutive dots');
    }

    if (trimmed.startsWith('.') ||
        trimmed.contains('@.') ||
        trimmed.endsWith('.')) {
      return ValidationResult.invalid('Invalid email format');
    }

    return ValidationResult.valid();
  }

  /// Password Strength Assessment
  PasswordStrength _assessPasswordStrength(String password) {
    int score = 0;

    // Length scoring
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety scoring
    if (RegExp(r'[a-z]').hasMatch(password)) score++; // lowercase
    if (RegExp(r'[A-Z]').hasMatch(password)) score++; // uppercase
    if (RegExp(r'[0-9]').hasMatch(password)) score++; // numbers
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password))
      score++; // special chars

    // Bonus for no common patterns
    if (!RegExp(r'(.)\1{2,}').hasMatch(password)) score++; // no repeated chars
    if (!RegExp(r'(012|123|234|345|456|567|678|789|890|abc|bcd|cde)')
        .hasMatch(password.toLowerCase())) score++;

    switch (score) {
      case 0:
      case 1:
      case 2:
        return PasswordStrength.veryWeak;
      case 3:
      case 4:
        return PasswordStrength.weak;
      case 5:
        return PasswordStrength.fair;
      case 6:
        return PasswordStrength.good;
      default:
        return PasswordStrength.strong;
    }
  }

  /// Enhanced Password Validation
  ValidationResult validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.invalid('Password is required');
    }

    if (value.length < minPasswordLength) {
      return ValidationResult.invalid(
          'Password must be at least $minPasswordLength characters');
    }

    if (value.length > maxPasswordLength) {
      return ValidationResult.invalid(
          'Password must be less than $maxPasswordLength characters');
    }

    // Check for common passwords
    if (commonPasswords.contains(value.toLowerCase())) {
      return ValidationResult.invalid(
          'This password is too common. Please choose a stronger password');
    }

    // Password complexity requirements
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return ValidationResult.invalid(
          'Password must contain at least one lowercase letter');
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return ValidationResult.invalid(
          'Password must contain at least one uppercase letter');
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return ValidationResult.invalid(
          'Password must contain at least one number');
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return ValidationResult.invalid(
          'Password must contain at least one special character');
    }

    final strength = _assessPasswordStrength(value);

    if (strength == PasswordStrength.veryWeak) {
      return ValidationResult.invalid(
          'Password is too weak. Please make it stronger');
    }

    return ValidationResult(
      isValid: true,
      passwordStrength: strength,
    );
  }

  /// Enhanced Password Confirmation Validation
  ValidationResult validatePasswordConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.invalid('Please confirm your password');
    }

    if (value != passwordTextController.text) {
      return ValidationResult.invalid('Passwords do not match');
    }

    return ValidationResult.valid();
  }

  /// Real-time validation methods
  void validateUsernameRealTime() {
    usernameValidation = validateUsername(usernameTextController.text);
  }

  void validatePhoneRealTime() {
    phoneValidation = validatePhoneNumber(phoneNumberTextController.text);
  }

  void validateEmailRealTime() {
    emailValidation = validateEmail(emailAddressTextController.text);
  }

  void validatePasswordRealTime() {
    passwordValidation = validatePassword(passwordTextController.text);
    // Also re-validate password confirmation if it has content
    if (passwordConfirmTextController.text.isNotEmpty) {
      passwordConfirmValidation =
          validatePasswordConfirm(passwordConfirmTextController.text);
    }
  }

  void validatePasswordConfirmRealTime() {
    passwordConfirmValidation =
        validatePasswordConfirm(passwordConfirmTextController.text);
  }

  /// Helper method to check if all validations pass
  bool get isFormValid {
    return _isValidationPassed(usernameValidation) &&
        _isValidationPassed(phoneValidation) &&
        _isValidationPassed(emailValidation) &&
        _isValidationPassed(passwordValidation) &&
        _isValidationPassed(passwordConfirmValidation) &&
        choiceChipsValue1 != null &&
        choiceChipsValue2 != null;
  }

  bool _isValidationPassed(ValidationResult? validation) {
    return validation?.isValid == true;
  }

  /// Get trimmed text from controller
  String getTrimmedText(TextEditingController controller) {
    return controller.text.trim();
  }

  /// Get password strength text
  String getPasswordStrengthText(PasswordStrength? strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return 'Very Weak';
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
      default:
        return '';
    }
  }

  /// Get password strength color
  Color getPasswordStrengthColor(PasswordStrength? strength) {
    switch (strength) {
      case PasswordStrength.veryWeak:
        return Colors.red[700]!;
      case PasswordStrength.weak:
        return Colors.orange[700]!;
      case PasswordStrength.fair:
        return Colors.yellow[700]!;
      case PasswordStrength.good:
        return Colors.lightGreen[700]!;
      case PasswordStrength.strong:
        return Colors.green[700]!;
      default:
        return Colors.grey;
    }
  }

  /// Reset form to initial state
  void resetForm() {
    usernameTextController.clear();
    phoneNumberTextController.clear();
    emailAddressTextController.clear();
    passwordTextController.clear();
    passwordConfirmTextController.clear();

    choiceChipsValue1 = null;
    choiceChipsValue2 = null;

    uploadedFileUrl = '';
    uploadedLocalFile = FFUploadedFile(bytes: Uint8List.fromList([]));
    isDataUploading = false;

    // Reset validation states
    usernameValidation = null;
    phoneValidation = null;
    emailValidation = null;
    passwordValidation = null;
    passwordConfirmValidation = null;
  }

  @override
  void initState(BuildContext context) {
    // Initialize controllers
    usernameTextController = TextEditingController();
    phoneNumberTextController = TextEditingController();
    emailAddressTextController = TextEditingController();
    passwordTextController = TextEditingController();
    passwordConfirmTextController = TextEditingController();

    // Initialize focus nodes
    usernameFocusNode = FocusNode();
    phoneNumberFocusNode = FocusNode();
    emailAddressFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    passwordConfirmFocusNode = FocusNode();

    // Initialize password visibility
    passwordVisibility = false;
    passwordConfirmVisibility = false;

    // Add real-time validation listeners
    usernameTextController.addListener(() => validateUsernameRealTime());
    phoneNumberTextController.addListener(() => validatePhoneRealTime());
    emailAddressTextController.addListener(() => validateEmailRealTime());
    passwordTextController.addListener(() => validatePasswordRealTime());
    passwordConfirmTextController
        .addListener(() => validatePasswordConfirmRealTime());
  }

  @override
  void dispose() {
    // Remove listeners first
    usernameTextController.removeListener(validateUsernameRealTime);
    phoneNumberTextController.removeListener(validatePhoneRealTime);
    emailAddressTextController.removeListener(validateEmailRealTime);
    passwordTextController.removeListener(validatePasswordRealTime);
    passwordConfirmTextController
        .removeListener(validatePasswordConfirmRealTime);

    // Dispose controllers
    usernameTextController.dispose();
    phoneNumberTextController.dispose();
    emailAddressTextController.dispose();
    passwordTextController.dispose();
    passwordConfirmTextController.dispose();

    // Dispose focus nodes
    usernameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailAddressFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmFocusNode.dispose();
  }
}
