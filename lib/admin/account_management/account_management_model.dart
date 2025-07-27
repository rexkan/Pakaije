import '/flutter_flow/flutter_flow_util.dart';
import 'account_management_widget.dart' show AccountManagementWidget;
import 'package:flutter/material.dart';

class AccountManagementModel extends FlutterFlowModel<AccountManagementWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for searchBar widget.
  FocusNode? searchBarFocusNode1;
  TextEditingController? searchBarTextController1;
  String? Function(BuildContext, String?)? searchBarTextController1Validator;
  // State field(s) for searchBar widget.
  FocusNode? searchBarFocusNode2;
  TextEditingController? searchBarTextController2;
  String? Function(BuildContext, String?)? searchBarTextController2Validator;
  // State field(s) for searchBar widget.
  FocusNode? searchBarFocusNode3;
  TextEditingController? searchBarTextController3;
  String? Function(BuildContext, String?)? searchBarTextController3Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    searchBarFocusNode1?.dispose();
    searchBarTextController1?.dispose();

    searchBarFocusNode2?.dispose();
    searchBarTextController2?.dispose();

    searchBarFocusNode3?.dispose();
    searchBarTextController3?.dispose();
  }
}
