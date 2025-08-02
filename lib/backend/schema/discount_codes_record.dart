import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DiscountCodesRecord extends FirestoreRecord {
  DiscountCodesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "vendor_id" field.
  String? _vendorId;
  String get vendorId => _vendorId ?? '';
  bool hasVendorId() => _vendorId != null;

  // "item_id" field.
  String? _itemId;
  String get itemId => _itemId ?? '';
  bool hasItemId() => _itemId != null;

  // "code" field.
  String? _code;
  String get code => _code ?? '';
  bool hasCode() => _code != null;

  // "discount_type" field.
  String? _discountType;
  String get discountType => _discountType ?? '';
  bool hasDiscountType() => _discountType != null;

  // "discount_value" field.
  double? _discountValue;
  double get discountValue => _discountValue ?? 0.0;
  bool hasDiscountValue() => _discountValue != null;

  // "start_date" field.
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  bool hasStartDate() => _startDate != null;

  // "end_date" field.
  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  bool hasEndDate() => _endDate != null;

  // "is_active" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  bool hasIsActive() => _isActive != null;

  // "usage_count" field.
  int? _usageCount;
  int get usageCount => _usageCount ?? 0;
  bool hasUsageCount() => _usageCount != null;

  // "max_usage" field.
  int? _maxUsage;
  int get maxUsage => _maxUsage ?? 0;
  bool hasMaxUsage() => _maxUsage != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _vendorId = snapshotData['vendor_id'] as String?;
    _itemId = snapshotData['item_id'] as String?;
    _code = snapshotData['code'] as String?;
    _discountType = snapshotData['discount_type'] as String?;
    _discountValue = castToType<double>(snapshotData['discount_value']);
    _startDate = snapshotData['start_date'] as DateTime?;
    _endDate = snapshotData['end_date'] as DateTime?;
    _isActive = snapshotData['is_active'] as bool?;
    _usageCount = castToType<int>(snapshotData['usage_count']);
    _maxUsage = castToType<int>(snapshotData['max_usage']);
    _createdAt = snapshotData['created_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('discount_codes');

  static Stream<DiscountCodesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DiscountCodesRecord.fromSnapshot(s));

  static Future<DiscountCodesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DiscountCodesRecord.fromSnapshot(s));

  static DiscountCodesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DiscountCodesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DiscountCodesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DiscountCodesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DiscountCodesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DiscountCodesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDiscountCodesRecordData({
  String? vendorId,
  String? itemId,
  String? code,
  String? discountType,
  double? discountValue,
  DateTime? startDate,
  DateTime? endDate,
  bool? isActive,
  int? usageCount,
  int? maxUsage,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'vendor_id': vendorId,
      'item_id': itemId,
      'code': code,
      'discount_type': discountType,
      'discount_value': discountValue,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': isActive,
      'usage_count': usageCount,
      'max_usage': maxUsage,
      'created_at': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class DiscountCodesRecordDocumentEquality
    implements Equality<DiscountCodesRecord> {
  const DiscountCodesRecordDocumentEquality();

  @override
  bool equals(DiscountCodesRecord? e1, DiscountCodesRecord? e2) {
    return e1?.vendorId == e2?.vendorId &&
        e1?.itemId == e2?.itemId &&
        e1?.code == e2?.code &&
        e1?.discountType == e2?.discountType &&
        e1?.discountValue == e2?.discountValue &&
        e1?.startDate == e2?.startDate &&
        e1?.endDate == e2?.endDate &&
        e1?.isActive == e2?.isActive &&
        e1?.usageCount == e2?.usageCount &&
        e1?.maxUsage == e2?.maxUsage &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(DiscountCodesRecord? e) => const ListEquality().hash([
        e?.vendorId,
        e?.itemId,
        e?.code,
        e?.discountType,
        e?.discountValue,
        e?.startDate,
        e?.endDate,
        e?.isActive,
        e?.usageCount,
        e?.maxUsage,
        e?.createdAt
      ]);

  @override
  bool isValidKey(Object? o) => o is DiscountCodesRecord;
}
