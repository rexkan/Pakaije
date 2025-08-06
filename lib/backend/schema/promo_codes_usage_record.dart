import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PromoCodeUsageRecord extends FirestoreRecord {
  PromoCodeUsageRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "usage_id" field.
  String? _usageId;
  String get usageId => _usageId ?? '';
  bool hasUsageId() => _usageId != null;

  // "promo_code" field.
  String? _promoCode;
  String get promoCode => _promoCode ?? '';
  bool hasPromoCode() => _promoCode != null;

  // "promo_code_doc_id" field.
  String? _promoCodeDocId;
  String get promoCodeDocId => _promoCodeDocId ?? '';
  bool hasPromoCodeDocId() => _promoCodeDocId != null;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  bool hasUserId() => _userId != null;

  // "vendor_id" field.
  String? _vendorId;
  String get vendorId => _vendorId ?? '';
  bool hasVendorId() => _vendorId != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  void _initializeFields() {
    _usageId = snapshotData['usage_id'] as String?;
    _promoCode = snapshotData['promo_code'] as String?;
    _promoCodeDocId = snapshotData['promo_code_doc_id'] as String?;
    _userId = snapshotData['user_id'] as String?;
    _vendorId = snapshotData['vendor_id'] as String?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('promo_code_usage');

  static Stream<PromoCodeUsageRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PromoCodeUsageRecord.fromSnapshot(s));

  static Future<PromoCodeUsageRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PromoCodeUsageRecord.fromSnapshot(s));

  static PromoCodeUsageRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PromoCodeUsageRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PromoCodeUsageRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PromoCodeUsageRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PromoCodeUsageRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PromoCodeUsageRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPromoCodeUsageRecordData({
  String? usageId,
  String? promoCode,
  String? promoCodeDocId,
  String? userId,
  String? vendorId,
  DateTime? timestamp,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'usage_id': usageId,
      'promo_code': promoCode,
      'promo_code_doc_id': promoCodeDocId,
      'user_id': userId,
      'vendor_id': vendorId,
      'timestamp': timestamp,
    }.withoutNulls,
  );

  return firestoreData;
}

class PromoCodeUsageRecordDocumentEquality
    implements Equality<PromoCodeUsageRecord> {
  const PromoCodeUsageRecordDocumentEquality();

  @override
  bool equals(PromoCodeUsageRecord? e1, PromoCodeUsageRecord? e2) {
    return e1?.usageId == e2?.usageId &&
        e1?.promoCode == e2?.promoCode &&
        e1?.promoCodeDocId == e2?.promoCodeDocId &&
        e1?.userId == e2?.userId &&
        e1?.vendorId == e2?.vendorId &&
        e1?.timestamp == e2?.timestamp;
  }

  @override
  int hash(PromoCodeUsageRecord? e) => const ListEquality().hash([
        e?.usageId,
        e?.promoCode,
        e?.promoCodeDocId,
        e?.userId,
        e?.vendorId,
        e?.timestamp
      ]);

  @override
  bool isValidKey(Object? o) => o is PromoCodeUsageRecord;
}
