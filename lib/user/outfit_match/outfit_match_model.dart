import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'outfit_match_widget.dart' show OutfitMatchWidget;
import 'package:flutter/material.dart';

class OutfitMatchModel extends FlutterFlowModel<OutfitMatchWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
