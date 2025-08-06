import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ContentReportsRecord extends FirestoreRecord {
  ContentReportsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "report_id" field.
  String? _reportId;
  String get reportId => _reportId ?? '';
  bool hasReportId() => _reportId != null;

  // "item_id" field.
  String? _itemId;
  String get itemId => _itemId ?? '';
  bool hasItemId() => _itemId != null;

  // "reporter_id" field.
  String? _reporterId;
  String get reporterId => _reporterId ?? '';
  bool hasReporterId() => _reporterId != null;

  // "reason" field.
  String? _reason;
  String get reason => _reason ?? '';
  bool hasReason() => _reason != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  void _initializeFields() {
    _reportId = snapshotData['report_id'] as String?;
    _itemId = snapshotData['item_id'] as String?;
    _reporterId = snapshotData['reporter_id'] as String?;
    _reason = snapshotData['reason'] as String?;
    _status = snapshotData['status'] as String?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('content_reports');

  static Stream<ContentReportsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ContentReportsRecord.fromSnapshot(s));

  static Future<ContentReportsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ContentReportsRecord.fromSnapshot(s));

  static ContentReportsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ContentReportsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ContentReportsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ContentReportsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ContentReportsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ContentReportsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createContentReportsRecordData({
  String? reportId,
  String? itemId,
  String? reporterId,
  String? reason,
  String? status,
  DateTime? timestamp,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'report_id': reportId,
      'item_id': itemId,
      'reporter_id': reporterId,
      'reason': reason,
      'status': status,
      'timestamp': timestamp,
    }.withoutNulls,
  );

  return firestoreData;
}

class ContentReportsRecordDocumentEquality
    implements Equality<ContentReportsRecord> {
  const ContentReportsRecordDocumentEquality();

  @override
  bool equals(ContentReportsRecord? e1, ContentReportsRecord? e2) {
    return e1?.reportId == e2?.reportId &&
        e1?.itemId == e2?.itemId &&
        e1?.reporterId == e2?.reporterId &&
        e1?.reason == e2?.reason &&
        e1?.status == e2?.status &&
        e1?.timestamp == e2?.timestamp;
  }

  @override
  int hash(ContentReportsRecord? e) => const ListEquality().hash([
        e?.reportId,
        e?.itemId,
        e?.reporterId,
        e?.reason,
        e?.status,
        e?.timestamp
      ]);

  @override
  bool isValidKey(Object? o) => o is ContentReportsRecord;
}
