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

class CreateAccountModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // File upload fields (if needed for profile image)
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  // State field(s) for Role ChoiceChips widget.
  String? choiceChipsValue1; // Changed from List<String>? to String?
  String? get selectedRole => choiceChipsValue1;

  // State field(s) for username widget.
  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  String? Function(BuildContext, String?)? usernameTextControllerValidator;

  // State field(s) for phoneNumber widget.
  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberTextController;
  String? Function(BuildContext, String?)? phoneNumberTextControllerValidator;

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;

  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;

  // State field(s) for passwordConfirm widget.
  FocusNode? passwordConfirmFocusNode;
  TextEditingController? passwordConfirmTextController;
  late bool passwordConfirmVisibility;
  String? Function(BuildContext, String?)?
      passwordConfirmTextControllerValidator;

  // State field(s) for Gender ChoiceChips widget.
  String? choiceChipsValue2; // Changed from List<String>? to String?
  String? get selectedGender => choiceChipsValue2;

  // Validation methods
  String? validateUsername(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? validatePhoneNumber(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Add phone number format validation if needed
    return null;
  }

  String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validatePasswordConfirm(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordTextController?.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Helper method to check if all required fields are filled
  bool get isFormValid {
    return usernameTextController?.text.isNotEmpty == true &&
        phoneNumberTextController?.text.isNotEmpty == true &&
        emailAddressTextController?.text.isNotEmpty == true &&
        passwordTextController?.text.isNotEmpty == true &&
        passwordConfirmTextController?.text.isNotEmpty == true &&
        choiceChipsValue1 != null &&
        choiceChipsValue2 != null;
  }

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
    passwordConfirmVisibility = false;

    // Set up validators
    usernameTextControllerValidator = validateUsername;
    phoneNumberTextControllerValidator = validatePhoneNumber;
    emailAddressTextControllerValidator = validateEmail;
    passwordTextControllerValidator = validatePassword;
    passwordConfirmTextControllerValidator = validatePasswordConfirm;
  }

  @override
  void dispose() {
    usernameFocusNode?.dispose();
    usernameTextController?.dispose();

    phoneNumberFocusNode?.dispose();
    phoneNumberTextController?.dispose();

    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();

    passwordConfirmFocusNode?.dispose();
    passwordConfirmTextController?.dispose();
  }
}
