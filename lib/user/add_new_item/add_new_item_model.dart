import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'add_new_item_widget.dart' show AddNewItemWidget;
import 'package:flutter/material.dart';

class AddNewItemModel extends FlutterFlowModel<AddNewItemWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  
  // State field(s) for ItemName widget.
  FocusNode? itemNameFocusNode;
  TextEditingController? itemNameTextController;
  String? Function(BuildContext, String?)? itemNameTextControllerValidator;
  
  // State field(s) for Category dropdown.
  String? categoryDropDownValue;
  FormFieldController<String>? categoryDropDownValueController;
  
  // State field(s) for Color dropdown.
  String? colorDropDownValue;
  FormFieldController<String>? colorDropDownValueController;

  // State field(s) for Weather Suitability dropdown.
  String? weatherDropDownValue;
  FormFieldController<String>? weatherDropDownValueController;

  // State field(s) for image upload.
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  // State field(s) for style tag selection (single choice).
  String? selectedStyleTag;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    itemNameFocusNode?.dispose();
    itemNameTextController?.dispose();
  }

  // Method to set selected style tag (single choice)
  void setSelectedStyleTag(String tag) {
    if (selectedStyleTag == tag) {
      selectedStyleTag = null; // Deselect if same tag is pressed
    } else {
      selectedStyleTag = tag;
    }
  }
}