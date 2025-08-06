// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class StyleWeightStruct extends FFFirebaseStruct {
  StyleWeightStruct({
    String? style,
    double? weight,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _style = style,
        _weight = weight,
        super(firestoreUtilData);

  // "style" field.
  String? _style;
  String get style => _style ?? '';
  set style(String? val) => _style = val;

  bool hasStyle() => _style != null;

  // "weight" field.
  double? _weight;
  double get weight => _weight ?? 0.0;
  set weight(double? val) => _weight = val;

  void incrementWeight(double amount) => weight = weight + amount;

  bool hasWeight() => _weight != null;

  static StyleWeightStruct fromMap(Map<String, dynamic> data) =>
      StyleWeightStruct(
        style: data['style'] as String?,
        weight: castToType<double>(data['weight']),
      );

  static StyleWeightStruct? maybeFromMap(dynamic data) => data is Map
      ? StyleWeightStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'style': _style,
        'weight': _weight,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'style': serializeParam(
          _style,
          ParamType.String,
        ),
        'weight': serializeParam(
          _weight,
          ParamType.double,
        ),
      }.withoutNulls;

  static StyleWeightStruct fromSerializableMap(Map<String, dynamic> data) =>
      StyleWeightStruct(
        style: deserializeParam(
          data['style'],
          ParamType.String,
          false,
        ),
        weight: deserializeParam(
          data['weight'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'StyleWeightStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StyleWeightStruct &&
        style == other.style &&
        weight == other.weight;
  }

  @override
  int get hashCode => const ListEquality().hash([style, weight]);
}

StyleWeightStruct createStyleWeightStruct({
  String? style,
  double? weight,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    StyleWeightStruct(
      style: style,
      weight: weight,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

StyleWeightStruct? updateStyleWeightStruct(
  StyleWeightStruct? styleWeight, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    styleWeight
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addStyleWeightStructData(
  Map<String, dynamic> firestoreData,
  StyleWeightStruct? styleWeight,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (styleWeight == null) {
    return;
  }
  if (styleWeight.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && styleWeight.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final styleWeightData =
      getStyleWeightFirestoreData(styleWeight, forFieldValue);
  final nestedData =
      styleWeightData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = styleWeight.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getStyleWeightFirestoreData(
  StyleWeightStruct? styleWeight, [
  bool forFieldValue = false,
]) {
  if (styleWeight == null) {
    return {};
  }
  final firestoreData = mapToFirestore(styleWeight.toMap());

  // Add any Firestore field values
  styleWeight.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getStyleWeightListFirestoreData(
  List<StyleWeightStruct>? styleWeights,
) =>
    styleWeights?.map((e) => getStyleWeightFirestoreData(e, true)).toList() ??
    [];
