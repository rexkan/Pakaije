import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'add_product_widget.dart' show AddProductWidget;
import 'package:flutter/material.dart';

class AddProductModel extends FlutterFlowModel<AddProductWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for ItemName widget.
  FocusNode? itemNameFocusNode;
  TextEditingController? itemNameTextController;
  String? Function(BuildContext, String?)? itemNameTextControllerValidator;
  // State field(s) for Category widget.
  FocusNode? categoryFocusNode;
  TextEditingController? categoryTextController;
  String? Function(BuildContext, String?)? categoryTextControllerValidator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController1;
  String? get choiceChipsValue1 =>
      choiceChipsValueController1?.value?.firstOrNull;
  set choiceChipsValue1(String? val) =>
      choiceChipsValueController1?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController2;
  String? get choiceChipsValue2 =>
      choiceChipsValueController2?.value?.firstOrNull;
  set choiceChipsValue2(String? val) =>
      choiceChipsValueController2?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    itemNameFocusNode?.dispose();
    itemNameTextController?.dispose();

    categoryFocusNode?.dispose();
    categoryTextController?.dispose();
  }
}
