import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SuggestionSettingsRecord extends FirestoreRecord {
  SuggestionSettingsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "style_weighting" field.
  List<StyleWeightStruct>? _styleWeighting;
  List<StyleWeightStruct> get styleWeighting => _styleWeighting ?? const [];
  bool hasStyleWeighting() => _styleWeighting != null;

  // "seasonal_bias" field.
  String? _seasonalBias;
  String get seasonalBias => _seasonalBias ?? '';
  bool hasSeasonalBias() => _seasonalBias != null;

  // "brand_integration_pct" field.
  int? _brandIntegrationPct;
  int get brandIntegrationPct => _brandIntegrationPct ?? 0;
  bool hasBrandIntegrationPct() => _brandIntegrationPct != null;

  // "last_updated" field.
  DateTime? _lastUpdated;
  DateTime? get lastUpdated => _lastUpdated;
  bool hasLastUpdated() => _lastUpdated != null;

  void _initializeFields() {
    _styleWeighting = getStructList(
      snapshotData['style_weighting'],
      StyleWeightStruct.fromMap,
    );
    _seasonalBias = snapshotData['seasonal_bias'] as String?;
    _brandIntegrationPct =
        castToType<int>(snapshotData['brand_integration_pct']);
    _lastUpdated = snapshotData['last_updated'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('suggestion_settings');

  static Stream<SuggestionSettingsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SuggestionSettingsRecord.fromSnapshot(s));

  static Future<SuggestionSettingsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => SuggestionSettingsRecord.fromSnapshot(s));

  static SuggestionSettingsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SuggestionSettingsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SuggestionSettingsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SuggestionSettingsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SuggestionSettingsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SuggestionSettingsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSuggestionSettingsRecordData({
  String? seasonalBias,
  int? brandIntegrationPct,
  DateTime? lastUpdated,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'seasonal_bias': seasonalBias,
      'brand_integration_pct': brandIntegrationPct,
      'last_updated': lastUpdated,
    }.withoutNulls,
  );

  return firestoreData;
}

class SuggestionSettingsRecordDocumentEquality
    implements Equality<SuggestionSettingsRecord> {
  const SuggestionSettingsRecordDocumentEquality();

  @override
  bool equals(SuggestionSettingsRecord? e1, SuggestionSettingsRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.styleWeighting, e2?.styleWeighting) &&
        e1?.seasonalBias == e2?.seasonalBias &&
        e1?.brandIntegrationPct == e2?.brandIntegrationPct &&
        e1?.lastUpdated == e2?.lastUpdated;
  }

  @override
  int hash(SuggestionSettingsRecord? e) => const ListEquality().hash([
        e?.styleWeighting,
        e?.seasonalBias,
        e?.brandIntegrationPct,
        e?.lastUpdated
      ]);

  @override
  bool isValidKey(Object? o) => o is SuggestionSettingsRecord;
}
