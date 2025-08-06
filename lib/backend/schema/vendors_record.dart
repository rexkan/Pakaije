import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VendorsRecord extends FirestoreRecord {
  VendorsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "brand_name" field.
  String? _brandName;
  String get brandName => _brandName ?? '';
  bool hasBrandName() => _brandName != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updated_at" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  // "is_active" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  bool hasIsActive() => _isActive != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _brandName = snapshotData['brand_name'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _updatedAt = snapshotData['updated_at'] as DateTime?;
    _isActive = snapshotData['is_active'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('vendors');

  static Stream<VendorsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => VendorsRecord.fromSnapshot(s));

  static Future<VendorsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => VendorsRecord.fromSnapshot(s));

  static VendorsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      VendorsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static VendorsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      VendorsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'VendorsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is VendorsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createVendorsRecordData({
  String? email,
  String? brandName,
  DateTime? createdAt,
  DateTime? updatedAt,
  bool? isActive,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'brand_name': brandName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_active': isActive,
    }.withoutNulls,
  );

  return firestoreData;
}

class VendorsRecordDocumentEquality implements Equality<VendorsRecord> {
  const VendorsRecordDocumentEquality();

  @override
  bool equals(VendorsRecord? e1, VendorsRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.brandName == e2?.brandName &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt &&
        e1?.isActive == e2?.isActive;
  }

  @override
  int hash(VendorsRecord? e) => const ListEquality()
      .hash([e?.email, e?.brandName, e?.createdAt, e?.updatedAt, e?.isActive]);

  @override
  bool isValidKey(Object? o) => o is VendorsRecord;
}
