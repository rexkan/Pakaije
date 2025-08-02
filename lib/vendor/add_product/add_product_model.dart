import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
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

  // State field(s) for ItemId widget.
  FocusNode? itemIdFocusNode;
  TextEditingController? itemIdTextController;
  String? Function(BuildContext, String?)? itemIdTextControllerValidator;

  // State field(s) for Category dropdown widget.
  String? categoryDropDownValue;
  FormFieldController<String>? categoryDropDownValueController;

  // State field(s) for Price widget.
  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;

  // State field(s) for BuyLink widget.
  FocusNode? buyLinkFocusNode;
  TextEditingController? buyLinkTextController;
  String? Function(BuildContext, String?)? buyLinkTextControllerValidator;

  // State field(s) for Description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;

  // State field(s) for Color ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController1;
  String? get choiceChipsValue1 =>
      choiceChipsValueController1?.value?.firstOrNull;
  set choiceChipsValue1(String? val) =>
      choiceChipsValueController1?.value = val != null ? [val] : [];

  // State field(s) for Occasion ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController2;
  String? get choiceChipsValue2 =>
      choiceChipsValueController2?.value?.firstOrNull;
  set choiceChipsValue2(String? val) =>
      choiceChipsValueController2?.value = val != null ? [val] : [];

  // State field(s) for image upload
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    // Dispose existing controllers
    itemNameFocusNode?.dispose();
    itemNameTextController?.dispose();

    // Dispose ItemId controllers
    itemIdFocusNode?.dispose();
    itemIdTextController?.dispose();

    // Dispose other controllers
    priceFocusNode?.dispose();
    priceTextController?.dispose();

    buyLinkFocusNode?.dispose();
    buyLinkTextController?.dispose();

    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();
  }
}
