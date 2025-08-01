// Updated SuggestionSettingsRecord to include weather-based smart suggestions
// Add these new fields to your existing SuggestionSettingsRecord class

import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SuggestionSettingsRecord extends FirestoreRecord {
  SuggestionSettingsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // EXISTING FIELDS (keep as they are)
  // "style_weighting" field.
  List<StyleWeightStruct>? _styleWeighting;
  List<StyleWeightStruct> get styleWeighting => _styleWeighting ?? const [];
  bool hasStyleWeighting() => _styleWeighting != null;

  // "seasonal_bias" field.
  String? _seasonalBias;
  String get seasonalBias => _seasonalBias ?? '';
  bool hasSeasonalBias() => _seasonalBias != null;

  // "brand_integration_pct" field.
  int? _brandIntegrationPct;
  int get brandIntegrationPct => _brandIntegrationPct ?? 0;
  bool hasBrandIntegrationPct() => _brandIntegrationPct != null;

  // "last_updated" field.
  DateTime? _lastUpdated;
  DateTime? get lastUpdated => _lastUpdated;
  bool hasLastUpdated() => _lastUpdated != null;

  // NEW WEATHER-BASED FIELDS
  // "weather_temp_cold_min" field.
  int? _weatherTempColdMin;
  int get weatherTempColdMin => _weatherTempColdMin ?? 10;
  bool hasWeatherTempColdMin() => _weatherTempColdMin != null;

  // "weather_temp_cold_max" field.
  int? _weatherTempColdMax;
  int get weatherTempColdMax => _weatherTempColdMax ?? 24;
  bool hasWeatherTempColdMax() => _weatherTempColdMax != null;

  // "weather_temp_warm_min" field.
  int? _weatherTempWarmMin;
  int get weatherTempWarmMin => _weatherTempWarmMin ?? 25;
  bool hasWeatherTempWarmMin() => _weatherTempWarmMin != null;

  // "weather_temp_warm_max" field.
  int? _weatherTempWarmMax;
  int get weatherTempWarmMax => _weatherTempWarmMax ?? 29;
  bool hasWeatherTempWarmMax() => _weatherTempWarmMax != null;

  // "weather_temp_hot_min" field.
  int? _weatherTempHotMin;
  int get weatherTempHotMin => _weatherTempHotMin ?? 30;
  bool hasWeatherTempHotMin() => _weatherTempHotMin != null;

  // "weather_humidity_alert" field.
  bool? _weatherHumidityAlert;
  bool get weatherHumidityAlert => _weatherHumidityAlert ?? false;
  bool hasWeatherHumidityAlert() => _weatherHumidityAlert != null;

  // "weather_rain_detection" field.
  bool? _weatherRainDetection;
  bool get weatherRainDetection => _weatherRainDetection ?? true;
  bool hasWeatherRainDetection() => _weatherRainDetection != null;

  // "weather_strong_wind" field.
  bool? _weatherStrongWind;
  bool get weatherStrongWind => _weatherStrongWind ?? false;
  bool hasWeatherStrongWind() => _weatherStrongWind != null;

  // "weather_uv_protection" field.
  bool? _weatherUvProtection;
  bool get weatherUvProtection => _weatherUvProtection ?? true;
  bool hasWeatherUvProtection() => _weatherUvProtection != null;

  // "weather_settings_active" field.
  bool? _weatherSettingsActive;
  bool get weatherSettingsActive => _weatherSettingsActive ?? true;
  bool hasWeatherSettingsActive() => _weatherSettingsActive != null;

  void _initializeFields() {
    // Existing fields initialization
    _styleWeighting = getStructList(
      snapshotData['style_weighting'],
      StyleWeightStruct.fromMap,
    );
    _seasonalBias = snapshotData['seasonal_bias'] as String?;
    _brandIntegrationPct =
        castToType<int>(snapshotData['brand_integration_pct']);
    _lastUpdated = snapshotData['last_updated'] as DateTime?;

    // New weather fields initialization
    _weatherTempColdMin =
        castToType<int>(snapshotData['weather_temp_cold_min']);
    _weatherTempColdMax =
        castToType<int>(snapshotData['weather_temp_cold_max']);
    _weatherTempWarmMin =
        castToType<int>(snapshotData['weather_temp_warm_min']);
    _weatherTempWarmMax =
        castToType<int>(snapshotData['weather_temp_warm_max']);
    _weatherTempHotMin = castToType<int>(snapshotData['weather_temp_hot_min']);
    _weatherHumidityAlert = snapshotData['weather_humidity_alert'] as bool?;
    _weatherRainDetection = snapshotData['weather_rain_detection'] as bool?;
    _weatherStrongWind = snapshotData['weather_strong_wind'] as bool?;
    _weatherUvProtection = snapshotData['weather_uv_protection'] as bool?;
    _weatherSettingsActive = snapshotData['weather_settings_active'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('suggestion_settings');

  static Stream<SuggestionSettingsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SuggestionSettingsRecord.fromSnapshot(s));

  static Future<SuggestionSettingsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => SuggestionSettingsRecord.fromSnapshot(s));

  static SuggestionSettingsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SuggestionSettingsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SuggestionSettingsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SuggestionSettingsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SuggestionSettingsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SuggestionSettingsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

// Updated createSuggestionSettingsRecordData function
Map<String, dynamic> createSuggestionSettingsRecordData({
  String? seasonalBias,
  int? brandIntegrationPct,
  DateTime? lastUpdated,
  // New weather parameters
  int? weatherTempColdMin,
  int? weatherTempColdMax,
  int? weatherTempWarmMin,
  int? weatherTempWarmMax,
  int? weatherTempHotMin,
  bool? weatherHumidityAlert,
  bool? weatherRainDetection,
  bool? weatherStrongWind,
  bool? weatherUvProtection,
  bool? weatherSettingsActive,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'seasonal_bias': seasonalBias,
      'brand_integration_pct': brandIntegrationPct,
      'last_updated': lastUpdated,
      // New weather fields
      'weather_temp_cold_min': weatherTempColdMin,
      'weather_temp_cold_max': weatherTempColdMax,
      'weather_temp_warm_min': weatherTempWarmMin,
      'weather_temp_warm_max': weatherTempWarmMax,
      'weather_temp_hot_min': weatherTempHotMin,
      'weather_humidity_alert': weatherHumidityAlert,
      'weather_rain_detection': weatherRainDetection,
      'weather_strong_wind': weatherStrongWind,
      'weather_uv_protection': weatherUvProtection,
      'weather_settings_active': weatherSettingsActive,
    }.withoutNulls,
  );

  return firestoreData;
}

// Updated equality class
class SuggestionSettingsRecordDocumentEquality
    implements Equality<SuggestionSettingsRecord> {
  const SuggestionSettingsRecordDocumentEquality();

  @override
  bool equals(SuggestionSettingsRecord? e1, SuggestionSettingsRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.styleWeighting, e2?.styleWeighting) &&
        e1?.seasonalBias == e2?.seasonalBias &&
        e1?.brandIntegrationPct == e2?.brandIntegrationPct &&
        e1?.lastUpdated == e2?.lastUpdated &&
        // New weather field comparisons
        e1?.weatherTempColdMin == e2?.weatherTempColdMin &&
        e1?.weatherTempColdMax == e2?.weatherTempColdMax &&
        e1?.weatherTempWarmMin == e2?.weatherTempWarmMin &&
        e1?.weatherTempWarmMax == e2?.weatherTempWarmMax &&
        e1?.weatherTempHotMin == e2?.weatherTempHotMin &&
        e1?.weatherHumidityAlert == e2?.weatherHumidityAlert &&
        e1?.weatherRainDetection == e2?.weatherRainDetection &&
        e1?.weatherStrongWind == e2?.weatherStrongWind &&
        e1?.weatherUvProtection == e2?.weatherUvProtection &&
        e1?.weatherSettingsActive == e2?.weatherSettingsActive;
  }

  @override
  int hash(SuggestionSettingsRecord? e) => const ListEquality().hash([
        e?.styleWeighting,
        e?.seasonalBias,
        e?.brandIntegrationPct,
        e?.lastUpdated,
        // New weather field hashes
        e?.weatherTempColdMin,
        e?.weatherTempColdMax,
        e?.weatherTempWarmMin,
        e?.weatherTempWarmMax,
        e?.weatherTempHotMin,
        e?.weatherHumidityAlert,
        e?.weatherRainDetection,
        e?.weatherStrongWind,
        e?.weatherUvProtection,
        e?.weatherSettingsActive,
      ]);

  @override
  bool isValidKey(Object? o) => o is SuggestionSettingsRecord;
}
