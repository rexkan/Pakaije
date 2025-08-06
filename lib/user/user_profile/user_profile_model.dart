import 'package:pakaije/backend/schema/users_record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

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

  // State field(s) for Phone Number widget.
  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberTextController;
  String? Function(BuildContext, String?)? phoneNumberTextControllerValidator;

  // State for body view image upload
  bool hasUploadedNewImage = false;
  String? uploadedImagePath;
  bool isSavingImage = false;

  // User data state
  UsersRecord? currentUser;
  bool isLoadingUser = true;
  String? errorMessage;

  // ADDED: Callback to notify widget of updates
  VoidCallback? onUserDataUpdated;

  @override
  void initState(BuildContext context) {
    // Initialize with empty controllers
    usernameTextController = TextEditingController();
    usernameFocusNode = FocusNode();
    phoneNumberTextController = TextEditingController();
    phoneNumberFocusNode = FocusNode();

    // Load current user data when model initializes
    loadCurrentUserData();
  }

  @override
  void dispose() {
    usernameFocusNode?.dispose();
    usernameTextController?.dispose();
    phoneNumberFocusNode?.dispose();
    phoneNumberTextController?.dispose();
  }

  // ADDED: Method to set update callback
  void setUpdateCallback(VoidCallback callback) {
    onUserDataUpdated = callback;
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
      phoneNumberTextController?.text = currentUser?.phoneNumber ?? '';

      isLoadingUser = false;

      // ADDED: Notify widget of data update
      onUserDataUpdated?.call();
    } catch (e) {
      errorMessage = e.toString();
      isLoadingUser = false;
      print('Error loading user data: $e');

      // ADDED: Notify widget even on error
      onUserDataUpdated?.call();
    }
  }

  // Method to handle image upload
  void setUploadedImage(String? imagePath) {
    uploadedImagePath = imagePath;
    hasUploadedNewImage = imagePath != null;
  }

  // Method to upload image to Firebase Storage and save URL to Firestore
  Future<void> saveUploadedImage() async {
    if (!hasUploadedNewImage ||
        uploadedImagePath == null ||
        currentUser == null) {
      return;
    }

    try {
      isSavingImage = true;
      // ADDED: Notify widget of saving state change
      onUserDataUpdated?.call();

      // UPDATED: Create a reference to Firebase Storage with corrected path
      final storageRef = FirebaseStorage.instance.ref();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imageRef = storageRef
          .child('users/${currentUser!.uid}/body_image_$timestamp.jpg');

      // Upload the image file to Firebase Storage
      final File imageFile = File(uploadedImagePath!);

      // Check if file exists
      if (!await imageFile.exists()) {
        throw Exception('Image file not found');
      }

      print('Uploading image to Firebase Storage...');
      final UploadTask uploadTask = imageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploaded_by': currentUser!.uid,
            'upload_time': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      final String downloadURL = await snapshot.ref.getDownloadURL();
      print('Image uploaded successfully. Download URL: $downloadURL');

      // Update the user document in Firestore with the new image URL
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);

      await userDocRef.update({
        'front_body_image_url': downloadURL,
        'updated_time': FieldValue.serverTimestamp(),
      });

      print('User document updated with new image URL');

      // Update local state
      hasUploadedNewImage = false;
      uploadedImagePath = null;
      isSavingImage = false;

      // Reload user data to reflect changes
      await loadCurrentUserData();

      print('User data reloaded successfully');
    } catch (e) {
      isSavingImage = false;
      print('Error saving image: $e');
      // ADDED: Notify widget of error state change
      onUserDataUpdated?.call();
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

      // Update phone number if provided
      if (phoneNumberTextController?.text.isNotEmpty == true &&
          phoneNumberTextController!.text != currentUser!.phoneNumber) {
        updateData['phone_number'] = phoneNumberTextController!.text;
      }

      // Update Firestore document if there are changes
      if (updateData.isNotEmpty) {
        updateData['updated_time'] = FieldValue.serverTimestamp();
        await userDocRef.update(updateData);

        // Reload user data
        await loadCurrentUserData();
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // FIXED: Helper method to get user's profile image URL (network images only)
  String getUserProfileImage() {
    // Only return valid HTTPS URLs for network images
    if (currentUser?.frontBodyImageUrl != null &&
        currentUser!.frontBodyImageUrl.isNotEmpty &&
        currentUser!.frontBodyImageUrl.startsWith('https://')) {
      return currentUser!.frontBodyImageUrl;
    }

    // Return empty string to indicate no valid network image
    return '';
  }

  // FIXED: Helper method to get local image path (for newly selected images)
  String? getLocalImagePath() {
    if (hasUploadedNewImage && uploadedImagePath != null) {
      return uploadedImagePath;
    }
    return null;
  }

  // FIXED: Helper method to check if image is from local file
  bool isLocalImage() {
    return hasUploadedNewImage && uploadedImagePath != null;
  }

  // Helper method to get user email
  String getUserEmail() {
    return currentUser?.email ?? 'Not available';
  }

  // Helper method to get user phone number
  String getUserPhoneNumber() {
    return currentUser?.phoneNumber ?? 'Not specified';
  }

  // Helper method to get user gender
  String getUserGender() {
    return currentUser?.gender ?? 'Not specified';
  }

  // Helper method to get display name
  String getDisplayName() {
    return currentUser?.displayName ?? 'User';
  }

  // FIXED: Helper method to check if there's a valid body image (network URL)
  bool hasBodyImage() {
    return currentUser?.frontBodyImageUrl != null &&
        currentUser!.frontBodyImageUrl.isNotEmpty &&
        currentUser!.frontBodyImageUrl.startsWith('https://');
  }

  // FIXED: Helper method to check if we have a newly uploaded image ready to save
  bool hasNewImageToSave() {
    return hasUploadedNewImage && uploadedImagePath != null;
  }

  // Helper method to get default placeholder image
  String getDefaultBodyImage() {
    return 'https://thumbs.dreamstime.com/b/minimal-black-outline-icon-standing-adult-man-front-view-isolated-white-background-concept-human-body-shape-anatomy-figure-386293482.jpg';
  }

  // ADDED: Helper method to clean up invalid image URLs from database
  Future<void> cleanUpInvalidImageUrl() async {
    if (currentUser == null) return;

    try {
      // Check if the current URL is a local path (invalid)
      if (currentUser!.frontBodyImageUrl.isNotEmpty &&
          !currentUser!.frontBodyImageUrl.startsWith('https://')) {
        print('Found invalid image URL: ${currentUser!.frontBodyImageUrl}');

        // Remove the invalid URL from Firestore
        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid);

        await userDocRef.update({
          'front_body_image_url': '',
          'updated_time': FieldValue.serverTimestamp(),
        });

        print('Invalid image URL cleaned up');

        // Reload user data
        await loadCurrentUserData();
      }
    } catch (e) {
      print('Error cleaning up invalid image URL: $e');
    }
  }
}
