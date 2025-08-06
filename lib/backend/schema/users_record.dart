import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  bool hasRole() => _role != null;

  // "account_status" field.
  String? _accountStatus;
  String get accountStatus => _accountStatus ?? 'active';
  bool hasAccountStatus() => _accountStatus != null;

  // "gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  bool hasGender() => _gender != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "front_body_image_url" field.
  String? _frontBodyImageUrl;
  String get frontBodyImageUrl => _frontBodyImageUrl ?? '';
  bool hasFrontBodyImageUrl() => _frontBodyImageUrl != null;

  // "style_preferences" field.
  List<String>? _stylePreferences;
  List<String> get stylePreferences => _stylePreferences ?? const [];
  bool hasStylePreferences() => _stylePreferences != null;

  // "saved_outfit_ids" field.
  List<String>? _savedOutfitIds;
  List<String> get savedOutfitIds => _savedOutfitIds ?? const [];
  bool hasSavedOutfitIds() => _savedOutfitIds != null;

  // "has_completed_setup" field.
  bool? _hasCompletedSetup;
  bool get hasCompletedSetup => _hasCompletedSetup ?? false;
  bool hasHasCompletedSetup() => _hasCompletedSetup != null;

  // "brand_description" field.
  String? _brandDescription;
  String get brandDescription => _brandDescription ?? '';
  bool hasBrandDescription() => _brandDescription != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _role = snapshotData['role'] as String?;
    _accountStatus = snapshotData['account_status'] as String?;
    _gender = snapshotData['gender'] as String?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _frontBodyImageUrl = snapshotData['front_body_image_url'] as String?;
    _stylePreferences = getDataList(snapshotData['style_preferences']);
    _savedOutfitIds = getDataList(snapshotData['saved_outfit_ids']);
    _hasCompletedSetup = snapshotData['has_completed_setup'] as bool?;
    _brandDescription = snapshotData['brand_description'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? role,
  String? accountStatus,
  String? gender,
  String? phoneNumber,
  String? frontBodyImageUrl,
  bool? hasCompletedSetup,
  String? brandDescription,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'role': role,
      'account_status': accountStatus,
      'gender': gender,
      'phone_number': phoneNumber,
      'front_body_image_url': frontBodyImageUrl,
      'has_completed_setup': hasCompletedSetup,
      'brand_description': brandDescription,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.role == e2?.role &&
        e1?.accountStatus == e2?.accountStatus &&
        e1?.gender == e2?.gender &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.frontBodyImageUrl == e2?.frontBodyImageUrl &&
        listEquality.equals(e1?.stylePreferences, e2?.stylePreferences) &&
        listEquality.equals(e1?.savedOutfitIds, e2?.savedOutfitIds) &&
        e1?.hasCompletedSetup == e2?.hasCompletedSetup &&
        e1?.brandDescription == e2?.brandDescription;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.role,
        e?.accountStatus,
        e?.gender,
        e?.phoneNumber,
        e?.frontBodyImageUrl,
        e?.stylePreferences,
        e?.savedOutfitIds,
        e?.hasCompletedSetup,
        e?.brandDescription
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
