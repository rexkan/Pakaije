import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GetWeatherKualaLumpurCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'getWeatherKualaLumpur',
      apiUrl: 'https://api.openweathermap.org/data/2.5/weather',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'q': "Kuala Lumpur,MY",
        'appid': "e94a49d026651e92567ebe5d78715d81",
        'units': "metric",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static double? temperature(dynamic response) =>
      castToType<double>(getJsonField(
        response,
        r'''$.main.temp''',
      ));
  static double? feelsLike(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.main.feels_like''',
      ));
  static String? condition(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.weather[:].main''',
      ));
  static String? description(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.weather[:].description''',
      ));
  static String? iconCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.weather[:].icon''',
      ));
  static String? city(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.name''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
