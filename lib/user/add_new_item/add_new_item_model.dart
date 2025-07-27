import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_new_item_widget.dart' show AddNewItemWidget;
import 'package:flutter/material.dart';

class AddNewItemModel extends FlutterFlowModel<AddNewItemWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ItemName widget.
  FocusNode? itemNameFocusNode1;
  TextEditingController? itemNameTextController1;
  String? Function(BuildContext, String?)? itemNameTextController1Validator;
  // State field(s) for ItemName widget.
  FocusNode? itemNameFocusNode2;
  TextEditingController? itemNameTextController2;
  String? Function(BuildContext, String?)? itemNameTextController2Validator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    itemNameFocusNode1?.dispose();
    itemNameTextController1?.dispose();

    itemNameFocusNode2?.dispose();
    itemNameTextController2?.dispose();
  }
}
