import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BrandedItemsRecord extends FirestoreRecord {
  BrandedItemsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "vendor_id" field.
  String? _vendorId;
  String get vendorId => _vendorId ?? '';
  bool hasVendorId() => _vendorId != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  bool hasImageUrl() => _imageUrl != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "item_id" field.
  String? _itemId;
  String get itemId => _itemId ?? '';
  bool hasItemId() => _itemId != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "style_tags" field.
  List<String>? _styleTags;
  List<String> get styleTags => _styleTags ?? const [];
  bool hasStyleTags() => _styleTags != null;

  // "weather_suitability" field.
  List<String>? _weatherSuitability;
  List<String> get weatherSuitability => _weatherSuitability ?? const [];
  bool hasWeatherSuitability() => _weatherSuitability != null;

  // "date_added" field.
  DateTime? _dateAdded;
  DateTime? get dateAdded => _dateAdded;
  bool hasDateAdded() => _dateAdded != null;

  // "product_url" field.
  String? _productUrl;
  String get productUrl => _productUrl ?? '';
  bool hasProductUrl() => _productUrl != null;

  // "promo_code_ids" field.
  List<String>? _promoCodeIds;
  List<String> get promoCodeIds => _promoCodeIds ?? const [];
  bool hasPromoCodeIds() => _promoCodeIds != null;

  void _initializeFields() {
    _vendorId = snapshotData['vendor_id'] as String?;
    _imageUrl = snapshotData['image_url'] as String?;
    _name = snapshotData['name'] as String?;
    _itemId = snapshotData['item_id'] as String?;
    _description = snapshotData['description'] as String?;
    _price = castToType<double>(snapshotData['price']);
    _category = snapshotData['category'] as String?;
    _styleTags = getDataList(snapshotData['style_tags']);
    _weatherSuitability = getDataList(snapshotData['weather_suitability']);
    _dateAdded = snapshotData['date_added'] as DateTime?;
    _productUrl = snapshotData['product_url'] as String?;
    _promoCodeIds = getDataList(snapshotData['promo_code_ids']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('branded_items');

  static Stream<BrandedItemsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BrandedItemsRecord.fromSnapshot(s));

  static Future<BrandedItemsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BrandedItemsRecord.fromSnapshot(s));

  static BrandedItemsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BrandedItemsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BrandedItemsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BrandedItemsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BrandedItemsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BrandedItemsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBrandedItemsRecordData({
  String? vendorId,
  String? imageUrl,
  String? name,
  String? itemId,
  String? description,
  double? price,
  String? category,
  DateTime? dateAdded,
  String? productUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'vendor_id': vendorId,
      'image_url': imageUrl,
      'name': name,
      'item_id': itemId,
      'description': description,
      'price': price,
      'category': category,
      'date_added': dateAdded,
      'product_url': productUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class BrandedItemsRecordDocumentEquality
    implements Equality<BrandedItemsRecord> {
  const BrandedItemsRecordDocumentEquality();

  @override
  bool equals(BrandedItemsRecord? e1, BrandedItemsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.vendorId == e2?.vendorId &&
        e1?.imageUrl == e2?.imageUrl &&
        e1?.name == e2?.name &&
        e1?.description == e2?.description &&
        e1?.price == e2?.price &&
        e1?.category == e2?.category &&
        listEquality.equals(e1?.styleTags, e2?.styleTags) &&
        listEquality.equals(e1?.weatherSuitability, e2?.weatherSuitability) &&
        e1?.dateAdded == e2?.dateAdded &&
        e1?.productUrl == e2?.productUrl &&
        listEquality.equals(e1?.promoCodeIds, e2?.promoCodeIds);
  }

  @override
  int hash(BrandedItemsRecord? e) => const ListEquality().hash([
        e?.vendorId,
        e?.imageUrl,
        e?.name,
        e?.description,
        e?.price,
        e?.category,
        e?.styleTags,
        e?.weatherSuitability,
        e?.dateAdded,
        e?.productUrl,
        e?.promoCodeIds
      ]);

  @override
  bool isValidKey(Object? o) => o is BrandedItemsRecord;
}
