import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'setting_buy_links_widget.dart' show SettingBuyLinksWidget;
import 'package:flutter/material.dart';

class SettingBuyLinksModel extends FlutterFlowModel<SettingBuyLinksWidget> {
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
