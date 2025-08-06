// STEP 1: Create this file in your project
// File: lib/services/session_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Update user session activity
  static Future<void> updateUserActivity({String? action}) async {
    final user = _auth.currentUser;
    if (user == null) {
      print('⚠️ No authenticated user found');
      return;
    }

    try {
      await _firestore.collection('user_sessions').doc(user.uid).set({
        'user_id': user.uid,
        'last_active': FieldValue.serverTimestamp(), // Use server timestamp
        'last_action': action ?? 'general_activity',
        'session_date':
            DateTime.now().toIso8601String().split('T')[0], // YYYY-MM-DD
      }, SetOptions(merge: true));

      print(
          '✅ Session updated for user: ${user.uid}, action: ${action ?? 'general_activity'}');
    } catch (e) {
      print('❌ Error updating user session: $e');
    }
  }

  /// Track specific user actions with optional metadata
  static Future<void> trackUserAction({
    required String action,
    Map<String, dynamic>? metadata,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      print('⚠️ No authenticated user found for action: $action');
      return;
    }

    try {
      // Update main session
      await updateUserActivity(action: action);

      // Optional: Create detailed activity log entry
      await _firestore.collection('user_activity_log').add({
        'user_id': user.uid,
        'action': action,
        'timestamp': FieldValue.serverTimestamp(),
        'metadata': metadata ?? {},
      });

      print('✅ Action tracked: $action for user: ${user.uid}');
    } catch (e) {
      print('❌ Error tracking user action: $e');
    }
  }

  /// Test method to verify session tracking is working
  static Future<bool> testSessionTracking() async {
    try {
      await updateUserActivity(action: 'test_session_tracking');

      final user = _auth.currentUser;
      if (user != null) {
        final doc =
            await _firestore.collection('user_sessions').doc(user.uid).get();

        if (doc.exists) {
          print('✅ Session tracking test successful!');
          print('📄 Document data: ${doc.data()}');
          return true;
        } else {
          print('❌ Session document not found');
          return false;
        }
      }
      return false;
    } catch (e) {
      print('❌ Session tracking test failed: $e');
      return false;
    }
  }
}
