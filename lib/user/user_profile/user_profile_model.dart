import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'user_profile_widget.dart' show UserProfileWidget;
import 'package:flutter/material.dart';

class UserProfileModel extends FlutterFlowModel<UserProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Emailadress widget.
  FocusNode? emailadressFocusNode;
  TextEditingController? emailadressTextController;
  String? Function(BuildContext, String?)? emailadressTextControllerValidator;
  // State field(s) for Password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;

  // State for body view image upload
  bool hasUploadedNewImage = false;
  String? uploadedImagePath;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailadressFocusNode?.dispose();
    emailadressTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }

  // Method to handle image upload
  void setUploadedImage(String? imagePath) {
    uploadedImagePath = imagePath;
    hasUploadedNewImage = imagePath != null;
  }

  // Method to save the uploaded image
  void saveUploadedImage() {
    if (hasUploadedNewImage && uploadedImagePath != null) {
      // Here you would typically save to your backend/database
      // For now, we'll just reset the upload state
      hasUploadedNewImage = false;
      // Keep the image path so it shows as the current image
    }
  }
}
