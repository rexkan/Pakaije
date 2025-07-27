import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OutfitPlansRecord extends FirestoreRecord {
  OutfitPlansRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  bool hasUserId() => _userId != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "outfit_id" field.
  String? _outfitId;
  String get outfitId => _outfitId ?? '';
  bool hasOutfitId() => _outfitId != null;

  // "event" field.
  String? _event;
  String get event => _event ?? '';
  bool hasEvent() => _event != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  void _initializeFields() {
    _userId = snapshotData['user_id'] as String?;
    _date = snapshotData['date'] as DateTime?;
    _outfitId = snapshotData['outfit_id'] as String?;
    _event = snapshotData['event'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('outfit_plans');

  static Stream<OutfitPlansRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OutfitPlansRecord.fromSnapshot(s));

  static Future<OutfitPlansRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OutfitPlansRecord.fromSnapshot(s));

  static OutfitPlansRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OutfitPlansRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OutfitPlansRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OutfitPlansRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OutfitPlansRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OutfitPlansRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOutfitPlansRecordData({
  String? userId,
  DateTime? date,
  String? outfitId,
  String? event,
  DateTime? createdTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_id': userId,
      'date': date,
      'outfit_id': outfitId,
      'event': event,
      'created_time': createdTime,
    }.withoutNulls,
  );

  return firestoreData;
}

class OutfitPlansRecordDocumentEquality implements Equality<OutfitPlansRecord> {
  const OutfitPlansRecordDocumentEquality();

  @override
  bool equals(OutfitPlansRecord? e1, OutfitPlansRecord? e2) {
    return e1?.userId == e2?.userId &&
        e1?.date == e2?.date &&
        e1?.outfitId == e2?.outfitId &&
        e1?.event == e2?.event &&
        e1?.createdTime == e2?.createdTime;
  }

  @override
  int hash(OutfitPlansRecord? e) => const ListEquality()
      .hash([e?.userId, e?.date, e?.outfitId, e?.event, e?.createdTime]);

  @override
  bool isValidKey(Object? o) => o is OutfitPlansRecord;
}
