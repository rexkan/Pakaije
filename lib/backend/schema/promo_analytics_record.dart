import 'dart:async';

import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class PromoAnalyticsRecord extends FirestoreRecord {
  PromoAnalyticsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "discount_code_id" field.
  String? _discountCodeId;
  String get discountCodeId => _discountCodeId ?? '';
  bool hasDiscountCodeId() => _discountCodeId != null;

  // "event_type" field.
  String? _eventType;
  String get eventType => _eventType ?? '';
  bool hasEventType() => _eventType != null;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  bool hasUserId() => _userId != null;

  // "vendor_id" field.
  String? _vendorId;
  String get vendorId => _vendorId ?? '';
  bool hasVendorId() => _vendorId != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _discountCodeId = snapshotData['discount_code_id'] as String?;
    _eventType = snapshotData['event_type'] as String?;
    _userId = snapshotData['user_id'] as String?;
    _vendorId = snapshotData['vendor_id'] as String?;
    _createdAt = snapshotData['created_at'] is Timestamp
        ? (snapshotData['created_at'] as Timestamp).toDate()
        : snapshotData['created_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('promo_analytics');

  static Stream<PromoAnalyticsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PromoAnalyticsRecord.fromSnapshot(s));

  static Future<PromoAnalyticsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PromoAnalyticsRecord.fromSnapshot(s));

  static PromoAnalyticsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PromoAnalyticsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PromoAnalyticsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PromoAnalyticsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PromoAnalyticsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PromoAnalyticsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPromoAnalyticsRecordData({
  String? discountCodeId,
  String? eventType,
  String? userId,
  String? vendorId,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'discount_code_id': discountCodeId,
      'event_type': eventType,
      'user_id': userId,
      'vendor_id': vendorId,
      'created_at': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class PromoAnalyticsRecordDocumentEquality
    implements Equality<PromoAnalyticsRecord> {
  const PromoAnalyticsRecordDocumentEquality();

  @override
  bool equals(PromoAnalyticsRecord? e1, PromoAnalyticsRecord? e2) {
    return e1?.discountCodeId == e2?.discountCodeId &&
        e1?.eventType == e2?.eventType &&
        e1?.userId == e2?.userId &&
        e1?.vendorId == e2?.vendorId &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(PromoAnalyticsRecord? e) => const ListEquality().hash(
      [e?.discountCodeId, e?.eventType, e?.userId, e?.vendorId, e?.createdAt]);

  @override
  bool isValidKey(Object? o) => o is PromoAnalyticsRecord;
}
