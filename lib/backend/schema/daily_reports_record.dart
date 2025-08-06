import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DailyReportsRecord extends FirestoreRecord {
  DailyReportsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "users_today" field.
  int? _usersToday;
  int get usersToday => _usersToday ?? 0;
  bool hasUsersToday() => _usersToday != null;

  // "active_sessions" field.
  int? _activeSessions;
  int get activeSessions => _activeSessions ?? 0;
  bool hasActiveSessions() => _activeSessions != null;

  // "most_used_tags" field.
  List<String>? _mostUsedTags;
  List<String> get mostUsedTags => _mostUsedTags ?? const [];
  bool hasMostUsedTags() => _mostUsedTags != null;

  // "user_growth_rate" field.
  double? _userGrowthRate;
  double get userGrowthRate => _userGrowthRate ?? 0.0;
  bool hasUserGrowthRate() => _userGrowthRate != null;

  void _initializeFields() {
    _date = snapshotData['date'] as DateTime?;
    _usersToday = castToType<int>(snapshotData['users_today']);
    _activeSessions = castToType<int>(snapshotData['active_sessions']);
    _mostUsedTags = getDataList(snapshotData['most_used_tags']);
    _userGrowthRate = castToType<double>(snapshotData['user_growth_rate']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('daily_reports');

  static Stream<DailyReportsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DailyReportsRecord.fromSnapshot(s));

  static Future<DailyReportsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DailyReportsRecord.fromSnapshot(s));

  static DailyReportsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DailyReportsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DailyReportsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DailyReportsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DailyReportsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DailyReportsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDailyReportsRecordData({
  DateTime? date,
  int? usersToday,
  int? activeSessions,
  double? userGrowthRate,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'date': date,
      'users_today': usersToday,
      'active_sessions': activeSessions,
      'user_growth_rate': userGrowthRate,
    }.withoutNulls,
  );

  return firestoreData;
}

class DailyReportsRecordDocumentEquality
    implements Equality<DailyReportsRecord> {
  const DailyReportsRecordDocumentEquality();

  @override
  bool equals(DailyReportsRecord? e1, DailyReportsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.date == e2?.date &&
        e1?.usersToday == e2?.usersToday &&
        e1?.activeSessions == e2?.activeSessions &&
        listEquality.equals(e1?.mostUsedTags, e2?.mostUsedTags) &&
        e1?.userGrowthRate == e2?.userGrowthRate;
  }

  @override
  int hash(DailyReportsRecord? e) => const ListEquality().hash([
        e?.date,
        e?.usersToday,
        e?.activeSessions,
        e?.mostUsedTags,
        e?.userGrowthRate
      ]);

  @override
  bool isValidKey(Object? o) => o is DailyReportsRecord;
}
