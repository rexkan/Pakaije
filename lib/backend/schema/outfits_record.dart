import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OutfitsRecord extends FirestoreRecord {
  OutfitsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  bool hasUserId() => _userId != null;

  // "top_item_id" field.
  String? _topItemId;
  String get topItemId => _topItemId ?? '';
  bool hasTopItemId() => _topItemId != null;

  // "bottom_item_id" field.
  String? _bottomItemId;
  String get bottomItemId => _bottomItemId ?? '';
  bool hasBottomItemId() => _bottomItemId != null;

  // "shoes_item_id" field.
  String? _shoesItemId;
  String get shoesItemId => _shoesItemId ?? '';
  bool hasShoesItemId() => _shoesItemId != null;

  // "accessory_ids" field.
  List<String>? _accessoryIds;
  List<String> get accessoryIds => _accessoryIds ?? const [];
  bool hasAccessoryIds() => _accessoryIds != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "is_suggested" field.
  bool? _isSuggested;
  bool get isSuggested => _isSuggested ?? false;
  bool hasIsSuggested() => _isSuggested != null;

  void _initializeFields() {
    _userId = snapshotData['user_id'] as String?;
    _topItemId = snapshotData['top_item_id'] as String?;
    _bottomItemId = snapshotData['bottom_item_id'] as String?;
    _shoesItemId = snapshotData['shoes_item_id'] as String?;
    _accessoryIds = getDataList(snapshotData['accessory_ids']);
    _name = snapshotData['name'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _isSuggested = snapshotData['is_suggested'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('outfits');

  static Stream<OutfitsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OutfitsRecord.fromSnapshot(s));

  static Future<OutfitsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OutfitsRecord.fromSnapshot(s));

  static OutfitsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OutfitsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OutfitsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OutfitsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OutfitsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OutfitsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOutfitsRecordData({
  String? userId,
  String? topItemId,
  String? bottomItemId,
  String? shoesItemId,
  String? name,
  DateTime? createdTime,
  bool? isSuggested,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_id': userId,
      'top_item_id': topItemId,
      'bottom_item_id': bottomItemId,
      'shoes_item_id': shoesItemId,
      'name': name,
      'created_time': createdTime,
      'is_suggested': isSuggested,
    }.withoutNulls,
  );

  return firestoreData;
}

class OutfitsRecordDocumentEquality implements Equality<OutfitsRecord> {
  const OutfitsRecordDocumentEquality();

  @override
  bool equals(OutfitsRecord? e1, OutfitsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.userId == e2?.userId &&
        e1?.topItemId == e2?.topItemId &&
        e1?.bottomItemId == e2?.bottomItemId &&
        e1?.shoesItemId == e2?.shoesItemId &&
        listEquality.equals(e1?.accessoryIds, e2?.accessoryIds) &&
        e1?.name == e2?.name &&
        e1?.createdTime == e2?.createdTime &&
        e1?.isSuggested == e2?.isSuggested;
  }

  @override
  int hash(OutfitsRecord? e) => const ListEquality().hash([
        e?.userId,
        e?.topItemId,
        e?.bottomItemId,
        e?.shoesItemId,
        e?.accessoryIds,
        e?.name,
        e?.createdTime,
        e?.isSuggested
      ]);

  @override
  bool isValidKey(Object? o) => o is OutfitsRecord;
}
