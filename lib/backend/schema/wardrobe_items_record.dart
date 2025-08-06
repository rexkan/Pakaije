import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WardrobeItemsRecord extends FirestoreRecord {
  WardrobeItemsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  bool hasUserId() => _userId != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  bool hasImageUrl() => _imageUrl != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "color" field.
  String? _color;
  String get color => _color ?? '';
  bool hasColor() => _color != null;

  // "style_tags" field.
  List<String>? _styleTags;
  List<String> get styleTags => _styleTags ?? const [];
  bool hasStyleTags() => _styleTags != null;

  // "occasion" field.
  List<String>? _occasion;
  List<String> get occasion => _occasion ?? const [];
  bool hasOccasion() => _occasion != null;

  // "weather_suitability" field.
  List<String>? _weatherSuitability;
  List<String> get weatherSuitability => _weatherSuitability ?? const [];
  bool hasWeatherSuitability() => _weatherSuitability != null;

  // "date_added" field.
  DateTime? _dateAdded;
  DateTime? get dateAdded => _dateAdded;
  bool hasDateAdded() => _dateAdded != null;

  // "is_favourite" field.
  bool? _isFavourite;
  bool get isFavourite => _isFavourite ?? false;
  bool hasIsFavourite() => _isFavourite != null;

  void _initializeFields() {
    _userId = snapshotData['user_id'] as String?;
    _imageUrl = snapshotData['image_url'] as String?;
    _name = snapshotData['name'] as String?;
    _category = snapshotData['category'] as String?;
    _color = snapshotData['color'] as String?;
    _styleTags = getDataList(snapshotData['style_tags']);
    _occasion = getDataList(snapshotData['occasion']);
    _weatherSuitability = getDataList(snapshotData['weather_suitability']);
    _dateAdded = snapshotData['date_added'] as DateTime?;
    _isFavourite = snapshotData['is_favourite'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('wardrobe_items');

  static Stream<WardrobeItemsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => WardrobeItemsRecord.fromSnapshot(s));

  static Future<WardrobeItemsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => WardrobeItemsRecord.fromSnapshot(s));

  static WardrobeItemsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      WardrobeItemsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static WardrobeItemsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      WardrobeItemsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'WardrobeItemsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is WardrobeItemsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createWardrobeItemsRecordData({
  String? userId,
  String? imageUrl,
  String? name,
  String? category,
  String? color,
  DateTime? dateAdded,
  bool? isFavourite,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_id': userId,
      'image_url': imageUrl,
      'name': name,
      'category': category,
      'color': color,
      'date_added': dateAdded,
      'is_favourite': isFavourite,
    }.withoutNulls,
  );

  return firestoreData;
}

class WardrobeItemsRecordDocumentEquality
    implements Equality<WardrobeItemsRecord> {
  const WardrobeItemsRecordDocumentEquality();

  @override
  bool equals(WardrobeItemsRecord? e1, WardrobeItemsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.userId == e2?.userId &&
        e1?.imageUrl == e2?.imageUrl &&
        e1?.name == e2?.name &&
        e1?.category == e2?.category &&
        e1?.color == e2?.color &&
        listEquality.equals(e1?.styleTags, e2?.styleTags) &&
        listEquality.equals(e1?.occasion, e2?.occasion) &&
        listEquality.equals(e1?.weatherSuitability, e2?.weatherSuitability) &&
        e1?.dateAdded == e2?.dateAdded &&
        e1?.isFavourite == e2?.isFavourite;
  }

  @override
  int hash(WardrobeItemsRecord? e) => const ListEquality().hash([
        e?.userId,
        e?.imageUrl,
        e?.name,
        e?.category,
        e?.color,
        e?.styleTags,
        e?.occasion,
        e?.weatherSuitability,
        e?.dateAdded,
        e?.isFavourite
      ]);

  @override
  bool isValidKey(Object? o) => o is WardrobeItemsRecord;
}
