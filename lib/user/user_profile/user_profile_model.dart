import 'package:pakaije/backend/schema/users_record.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'user_profile_widget.dart' show UserProfileWidget;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel extends FlutterFlowModel<UserProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Username widget.
  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  String? Function(BuildContext, String?)? usernameTextControllerValidator;

  // State field(s) for Password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;

  // State for body view image upload
  bool hasUploadedNewImage = false;
  String? uploadedImagePath;

  // User data state
  UsersRecord? currentUser;
  bool isLoadingUser = true;
  String? errorMessage;

  @override
  void initState(BuildContext context) {
    // Initialize with empty controllers
    usernameTextController = TextEditingController();
    usernameFocusNode = FocusNode();
    passwordTextController = TextEditingController();
    passwordFocusNode = FocusNode();

    // Load current user data when model initializes
    loadCurrentUserData();
  }

  @override
  void dispose() {
    usernameFocusNode?.dispose();
    usernameTextController?.dispose();
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }

  // Method to load current user data
  Future<void> loadCurrentUserData() async {
    try {
      isLoadingUser = true;
      errorMessage = null;

      // Get current Firebase user
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        throw Exception('No user is currently logged in');
      }

      // Get user document from Firestore
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid);

      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        throw Exception('User data not found in database');
      }

      // Create UsersRecord from document data
      currentUser = UsersRecord.fromSnapshot(userDoc);

      // Update text controllers with user data
      usernameTextController?.text = currentUser?.displayName ?? '';
      // Don't pre-fill password for security reasons

      isLoadingUser = false;
    } catch (e) {
      errorMessage = e.toString();
      isLoadingUser = false;
      print('Error loading user data: $e');
    }
  }

  // Method to handle image upload
  void setUploadedImage(String? imagePath) {
    uploadedImagePath = imagePath;
    hasUploadedNewImage = imagePath != null;
  }

  // Method to save the uploaded image to Firestore
  Future<void> saveUploadedImage() async {
    if (!hasUploadedNewImage ||
        uploadedImagePath == null ||
        currentUser == null) {
      return;
    }

    try {
      // Here you would typically upload the image to Firebase Storage first
      // and get the download URL, then update the user document

      // For now, we'll just update the local state
      // In a real implementation, you would:
      // 1. Upload image to Firebase Storage
      // 2. Get the download URL
      // 3. Update the user document with the new image URL

      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);

      // Update the document (replace with actual image URL from Firebase Storage)
      await userDocRef.update({
        'front_body_image_url':
            uploadedImagePath, // This should be the Firebase Storage URL
      });

      // Update local state
      hasUploadedNewImage = false;

      // Reload user data to reflect changes
      await loadCurrentUserData();
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  // Method to update user profile information
  Future<void> updateUserProfile() async {
    if (currentUser == null) {
      throw Exception('No user data available');
    }

    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);

      // Prepare update data
      final updateData = <String, dynamic>{};

      // Update display name if changed
      if (usernameTextController?.text.isNotEmpty == true &&
          usernameTextController!.text != currentUser!.displayName) {
        updateData['display_name'] = usernameTextController!.text;
      }

      // Update password if provided (this should be done through Firebase Auth)
      if (passwordTextController?.text.isNotEmpty == true) {
        // Update Firebase Auth user password
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          await firebaseUser.updatePassword(passwordTextController!.text);
        }
      }

      // Update Firestore document if there are changes
      if (updateData.isNotEmpty) {
        await userDocRef.update(updateData);

        // Reload user data
        await loadCurrentUserData();
      }

      // Clear password field for security
      passwordTextController?.clear();
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Helper method to get user's profile image
  String getUserProfileImage() {
    if (hasUploadedNewImage && uploadedImagePath != null) {
      return uploadedImagePath!;
    }

    if (currentUser?.frontBodyImageUrl.isNotEmpty == true) {
      return currentUser!.frontBodyImageUrl;
    }

    // Default image
    return 'https://thumbs.dreamstime.com/b/minimal-black-outline-icon-standing-adult-man-front-view-isolated-white-background-concept-human-body-shape-anatomy-figure-386293482.jpg';
  }

  // Helper method to check if image is from local file
  bool isLocalImage() {
    return hasUploadedNewImage && uploadedImagePath != null;
  }

  // Helper method to get user email
  String getUserEmail() {
    return currentUser?.email ?? 'Not available';
  }

  // Helper method to get user gender
  String getUserGender() {
    return currentUser?.gender ?? 'Not specified';
  }

  // Helper method to get display name
  String getDisplayName() {
    return currentUser?.displayName ?? 'User';
  }
}
