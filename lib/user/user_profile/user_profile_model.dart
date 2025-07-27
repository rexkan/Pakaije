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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailadressFocusNode?.dispose();
    emailadressTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
