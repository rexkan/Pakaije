import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PromoCodesRecord extends FirestoreRecord {
  PromoCodesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "code" field.
  String? _code;
  String get code => _code ?? '';
  bool hasCode() => _code != null;

  // "vendor_id" field.
  String? _vendorId;
  String get vendorId => _vendorId ?? '';
  bool hasVendorId() => _vendorId != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "discount_type" field.
  String? _discountType;
  String get discountType => _discountType ?? '';
  bool hasDiscountType() => _discountType != null;

  // "discount_value" field.
  int? _discountValue;
  int get discountValue => _discountValue ?? 0;
  bool hasDiscountValue() => _discountValue != null;

  // "applies_to" field.
  List<String>? _appliesTo;
  List<String> get appliesTo => _appliesTo ?? const [];
  bool hasAppliesTo() => _appliesTo != null;

  // "valid_from" field.
  DateTime? _validFrom;
  DateTime? get validFrom => _validFrom;
  bool hasValidFrom() => _validFrom != null;

  // "valid_until" field.
  DateTime? _validUntil;
  DateTime? get validUntil => _validUntil;
  bool hasValidUntil() => _validUntil != null;

  // "is_active" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  bool hasIsActive() => _isActive != null;

  void _initializeFields() {
    _code = snapshotData['code'] as String?;
    _vendorId = snapshotData['vendor_id'] as String?;
    _title = snapshotData['title'] as String?;
    _description = snapshotData['description'] as String?;
    _discountType = snapshotData['discount_type'] as String?;
    _discountValue = castToType<int>(snapshotData['discount_value']);
    _appliesTo = getDataList(snapshotData['applies_to']);
    _validFrom = snapshotData['valid_from'] as DateTime?;
    _validUntil = snapshotData['valid_until'] as DateTime?;
    _isActive = snapshotData['is_active'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('promo_codes');

  static Stream<PromoCodesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PromoCodesRecord.fromSnapshot(s));

  static Future<PromoCodesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PromoCodesRecord.fromSnapshot(s));

  static PromoCodesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PromoCodesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PromoCodesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PromoCodesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PromoCodesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PromoCodesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPromoCodesRecordData({
  String? code,
  String? vendorId,
  String? title,
  String? description,
  String? discountType,
  int? discountValue,
  DateTime? validFrom,
  DateTime? validUntil,
  bool? isActive,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'code': code,
      'vendor_id': vendorId,
      'title': title,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'valid_from': validFrom,
      'valid_until': validUntil,
      'is_active': isActive,
    }.withoutNulls,
  );

  return firestoreData;
}

class PromoCodesRecordDocumentEquality implements Equality<PromoCodesRecord> {
  const PromoCodesRecordDocumentEquality();

  @override
  bool equals(PromoCodesRecord? e1, PromoCodesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.code == e2?.code &&
        e1?.vendorId == e2?.vendorId &&
        e1?.title == e2?.title &&
        e1?.description == e2?.description &&
        e1?.discountType == e2?.discountType &&
        e1?.discountValue == e2?.discountValue &&
        listEquality.equals(e1?.appliesTo, e2?.appliesTo) &&
        e1?.validFrom == e2?.validFrom &&
        e1?.validUntil == e2?.validUntil &&
        e1?.isActive == e2?.isActive;
  }

  @override
  int hash(PromoCodesRecord? e) => const ListEquality().hash([
        e?.code,
        e?.vendorId,
        e?.title,
        e?.description,
        e?.discountType,
        e?.discountValue,
        e?.appliesTo,
        e?.validFrom,
        e?.validUntil,
        e?.isActive
      ]);

  @override
  bool isValidKey(Object? o) => o is PromoCodesRecord;
}
