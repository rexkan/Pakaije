import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'smart_suggestions_model.dart';
export 'smart_suggestions_model.dart';
import '/backend/backend.dart';

class SmartSuggestionsWidget extends StatefulWidget {
  const SmartSuggestionsWidget({super.key});

  static String routeName = 'SmartSuggestions';
  static String routePath = '/smartSuggestions';

  @override
  State<SmartSuggestionsWidget> createState() => _SmartSuggestionsWidgetState();
}

class _SmartSuggestionsWidgetState extends State<SmartSuggestionsWidget> {
  late SmartSuggestionsModel _model;

  // ========================================
  // SCAFFOLD AND NAVIGATION VARIABLES
  // ========================================
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 3;

  // ========================================
  // WEATHER API VARIABLES
  // ========================================
  Map<String, dynamic>? weatherData;
  bool isLoadingWeather = true;
  String? weatherError;

  // OpenWeatherMap API configuration
  final String apiKey = 'e94a49d026651e92567ebe5d78715d81';
  final String cityName = 'Kuala Lumpur,MY';

  // ========================================
  // TEMPERATURE DROPDOWN CONTROLLERS
  // ========================================
  FormFieldController<String>? dropDownValueController6;
  FormFieldController<String>? dropDownValueController7;
  FormFieldController<String>? dropDownValueController8;
  String? dropDownValue6;
  String? dropDownValue7;
  String? dropDownValue8;

  // ========================================
  // WEATHER CONDITION SWITCH VARIABLES
  // ========================================
  bool humidityAlertSwitch = false;
  bool rainDetectionSwitch = false;
  bool strongWindSwitch = false;
  bool uvProtectionSwitch = false;

  // ========================================
  // FIREBASE INTEGRATION VARIABLES
  // ========================================
  DocumentReference? settingsDocRef;
  SuggestionSettingsRecord? currentSettings;
  bool isLoadingSettings = true;

  // ========================================
  // SAVED SETTINGS VARIABLES
  // ========================================
  Map<String, int> savedTemperatureRanges = {
    'coldMin': 10,
    'coldMax': 24,
    'warmMin': 25,
    'warmMax': 29,
    'hotMin': 30,
  };

  Map<String, bool> savedSwitchSettings = {
    'humidityAlert': false,
    'rainDetection': false,
    'strongWind': false,
    'uvProtection': false,
  };

  bool settingsAreSaved = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SmartSuggestionsModel());

    // Initialize Firebase settings document reference
    settingsDocRef = SuggestionSettingsRecord.collection.doc('global_settings');

    // Load settings from Firebase first, then fetch weather
    _loadSettingsFromFirebase().then((_) {
      _fetchWeatherData();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  // ========================================
  // FIREBASE SETTINGS LOADING METHOD
  // ========================================
  Future<void> _loadSettingsFromFirebase() async {
    try {
      print('🔄 Loading settings from Firebase...');

      currentSettings =
          await SuggestionSettingsRecord.getDocumentOnce(settingsDocRef!);

      if (currentSettings != null) {
        setState(() {
          // Load temperature ranges
          savedTemperatureRanges = {
            'coldMin': currentSettings!.weatherTempColdMin,
            'coldMax': currentSettings!.weatherTempColdMax,
            'warmMin': currentSettings!.weatherTempWarmMin,
            'warmMax': currentSettings!.weatherTempWarmMax,
            'hotMin': currentSettings!.weatherTempHotMin,
          };

          // Load weather conditions
          humidityAlertSwitch = currentSettings!.weatherHumidityAlert;
          rainDetectionSwitch = currentSettings!.weatherRainDetection;
          strongWindSwitch = currentSettings!.weatherStrongWind;
          uvProtectionSwitch = currentSettings!.weatherUvProtection;

          savedSwitchSettings = {
            'humidityAlert': humidityAlertSwitch,
            'rainDetection': rainDetectionSwitch,
            'strongWind': strongWindSwitch,
            'uvProtection': uvProtectionSwitch,
          };

          // Update dropdown controllers to match loaded settings
          _model.dropDownValue4 = '${currentSettings!.weatherTempColdMin}°C';
          _model.dropDownValue5 = '${currentSettings!.weatherTempColdMax}°C';
          dropDownValue6 = '${currentSettings!.weatherTempWarmMin}°C';
          dropDownValue7 = '${currentSettings!.weatherTempWarmMax}°C';
          dropDownValue8 = '${currentSettings!.weatherTempHotMin}°C';

          settingsAreSaved = true;
          isLoadingSettings = false;
        });

        print('✅ Settings loaded from Firebase successfully');
        print(
            'Temperature ranges: Cold(${currentSettings!.weatherTempColdMin}-${currentSettings!.weatherTempColdMax}), Warm(${currentSettings!.weatherTempWarmMin}-${currentSettings!.weatherTempWarmMax}), Hot(${currentSettings!.weatherTempHotMin}+)');
      } else {
        print('⚠️ No settings found, using defaults');
        setState(() {
          isLoadingSettings = false;
        });
      }
    } catch (e) {
      print('❌ Error loading settings from Firebase: $e');
      setState(() {
        isLoadingSettings = false;
      });
    }
  }

  // ========================================
  // WEATHER API FETCH METHOD
  // ========================================
  Future<void> _fetchWeatherData() async {
    print('🌤️ Starting weather API call...');

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=Kuala%20Lumpur%2CMY&appid=e94a49d026651e92567ebe5d78715d81&units=metric'),
      );

      print('🌤️ API Response status: ${response.statusCode}');
      print('🌤️ API Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          isLoadingWeather = false;
          weatherError = null;
        });
        print('🌤️ Weather data parsed successfully!');
      } else {
        setState(() {
          isLoadingWeather = false;
          weatherError = 'Failed to load weather data: ${response.statusCode}';
        });
        print('🌤️ API Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoadingWeather = false;
        weatherError = 'Error: $e';
      });
      print('🌤️ Exception occurred: $e');
    }
  }

  // ========================================
  // FIREBASE SETTINGS SAVE METHOD
  // ========================================
  void _saveSettings() async {
    final currentRanges = _getTemperatureRanges();

    try {
      print('💾 Saving settings to Firebase...');

      // Create the settings data using the schema
      final settingsData = createSuggestionSettingsRecordData(
        lastUpdated: DateTime.now(),
        weatherTempColdMin: currentRanges['coldMin'],
        weatherTempColdMax: currentRanges['coldMax'],
        weatherTempWarmMin: currentRanges['warmMin'],
        weatherTempWarmMax: currentRanges['warmMax'],
        weatherTempHotMin: currentRanges['hotMin'],
        weatherHumidityAlert: humidityAlertSwitch,
        weatherRainDetection: rainDetectionSwitch,
        weatherStrongWind: strongWindSwitch,
        weatherUvProtection: uvProtectionSwitch,
        weatherSettingsActive: true,
      );

      // Save to Firestore
      await settingsDocRef!.set(settingsData, SetOptions(merge: true));

      // Update local state (keep existing functionality)
      setState(() {
        savedTemperatureRanges = Map.from(currentRanges);
        savedSwitchSettings = {
          'humidityAlert': humidityAlertSwitch,
          'rainDetection': rainDetectionSwitch,
          'strongWind': strongWindSwitch,
          'uvProtection': uvProtectionSwitch,
        };
        settingsAreSaved = true;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Settings saved successfully! All users will see updated suggestions.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      print('✅ Settings saved to Firebase successfully');
    } catch (e) {
      print('❌ Error saving settings to Firebase: $e');

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving settings. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // ========================================
  // TEMPERATURE RANGES HELPER METHOD
  // ========================================
  Map<String, int> _getTemperatureRanges() {
    // Cold weather range
    int coldMin =
        int.parse((_model.dropDownValue4 ?? '10°C').replaceAll('°C', ''));
    int coldMax =
        int.parse((_model.dropDownValue5 ?? '24°C').replaceAll('°C', ''));

    // Warm weather range
    int warmMin = int.parse((dropDownValue6 ?? '25°C').replaceAll('°C', ''));
    int warmMax = int.parse((dropDownValue7 ?? '29°C').replaceAll('°C', ''));

    // Hot weather threshold
    int hotMin = int.parse((dropDownValue8 ?? '30°C').replaceAll('°C', ''));

    return {
      'coldMin': coldMin,
      'coldMax': coldMax,
      'warmMin': warmMin,
      'warmMax': warmMax,
      'hotMin': hotMin,
    };
  }

  // ========================================
  // SMART SUGGESTION GENERATION METHOD
  // ========================================
  String _generateSmartSuggestion(Map<String, dynamic> weather) {
    final temp = (weather['main']?['temp'] as num?)?.round() ?? 0;
    final humidity = (weather['main']?['humidity'] as num?) ?? 0;
    final windSpeed = ((weather['wind']?['speed'] as num?) ?? 0) * 3.6;
    final description =
        weather['weather']?[0]?['main']?.toString().toLowerCase() ?? '';

    List<String> suggestions = [];

    // Use SAVED temperature ranges instead of current dropdown values
    final tempRanges = savedTemperatureRanges;

    // Temperature-based suggestions using SAVED ranges
    if (temp <= tempRanges['coldMax']!) {
      suggestions.add(
          "🧥 Cold weather detected (${temp}°C) - consider wearing a jacket, long sleeves, and closed shoes");
    } else if (temp >= tempRanges['warmMin']! &&
        temp <= tempRanges['warmMax']!) {
      suggestions.add(
          "👕 Warm weather (${temp}°C) - light clothing and breathable fabrics recommended");
    } else if (temp >= tempRanges['hotMin']!) {
      suggestions.add(
          "☀️ Hot weather (${temp}°C) - wear light colors, UV protection, and stay hydrated");
    }

    // Humidity-based suggestions (only if enabled in SAVED settings)
    if (savedSwitchSettings['humidityAlert']! && humidity > 80) {
      suggestions.add(
          "💧 High humidity (${humidity}%) - choose moisture-wicking fabrics and avoid heavy materials");
    }

    // Wind-based suggestions (only if enabled in SAVED settings)
    if (savedSwitchSettings['strongWind']! && windSpeed > 25) {
      suggestions.add(
          "💨 Strong winds (${windSpeed.round()} km/h) - avoid loose clothing and secure accessories");
    }

    // Weather condition suggestions (only if respective settings are enabled)
    if (savedSwitchSettings['rainDetection']! && description.contains('rain')) {
      suggestions.add(
          "🌧️ Rain detected - bring an umbrella and consider waterproof clothing");
    } else if (savedSwitchSettings['uvProtection']! &&
        description.contains('clear') &&
        temp >= tempRanges['hotMin']!) {
      suggestions.add(
          "🕶️ Clear skies and hot - sunglasses, hat, and sunscreen are essential");
    }

    if (suggestions.isEmpty) {
      return "Perfect weather conditions! Dress comfortably and enjoy your day! ☀️";
    }

    // Return only the main suggestions (notification will be handled separately)
    return suggestions.join('\n\n');
  }

  // ========================================
  // NOTIFICATION MESSAGE HELPER METHOD
  // ========================================
  String _getNotificationMessage() {
    if (isLoadingSettings) {
      return "🔄 Loading saved settings...";
    }
    return settingsAreSaved
        ? "✅ Showing preview based on SAVED settings from Firebase"
        : "⚠️ Settings not saved yet - this preview uses default values. Click 'Save Settings' to apply your configuration.";
  }

  // ========================================
  // WEATHER ICON HELPER METHOD
  // ========================================
  IconData _getWeatherIcon(String? iconCode) {
    if (iconCode == null) return Icons.wb_sunny;

    switch (iconCode.substring(0, 2)) {
      case '01': // clear sky
        return Icons.wb_sunny;
      case '02': // few clouds
        return Icons.wb_cloudy;
      case '03': // scattered clouds
      case '04': // broken clouds
        return Icons.cloud;
      case '09': // shower rain
        return Icons.grain;
      case '10': // rain
        return Icons.umbrella;
      case '11': // thunderstorm
        return Icons.flash_on;
      case '13': // snow
        return Icons.ac_unit;
      case '50': // mist
        return Icons.blur_on;
      default:
        return Icons.wb_sunny;
    }
  }

  // ========================================
  // BOTTOM NAVIGATION METHOD
  // ========================================
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.pushNamed('AdminDashboard');
        break;
      case 1:
        context.pushNamed('AccountManagement');
        break;
      case 2:
        context.pushNamed('ModerateContent');
        break;
      case 3:
        // Stay on current page (Smart Suggestions)
        break;
      case 4:
        context.pushNamed('ReportsInsights');
        break;
    }
  }

  @override
  void dispose() {
    _model.dispose();

    // Dispose local controllers
    dropDownValueController6?.dispose();
    dropDownValueController7?.dispose();
    dropDownValueController8?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,

          // ========================================
          // APP BAR SECTION
          // ========================================
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).underground,
            automaticallyImplyLeading: false,
            title: Text(
              'Smart Suggestion Settings',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    font: GoogleFonts.interTight(
                      fontWeight:
                          FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).white,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                  ),
            ),
            actions: [
              // Loading indicator when settings are being loaded
              if (isLoadingSettings)
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                  child: Center(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).white,
                        ),
                        strokeWidth: 2.0,
                      ),
                    ),
                  ),
                ),
            ],
            centerTitle: false,
            elevation: 0.0,
          ),

          // ========================================
          // BOTTOM NAVIGATION BAR SECTION
          // ========================================
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: FlutterFlowTheme.of(context).underground,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: FlutterFlowTheme.of(context).blankCanvas,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: "Accounts",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.content_copy),
                label: "Contents",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.tune),
                label: "Tune",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: "Reports",
              ),
            ],
          ),

          // ========================================
          // MAIN BODY SECTION
          // ========================================
          body: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ========================================
                    // SECTION 1: CURRENT WEATHER DISPLAY
                    // ========================================
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Weather Section Title
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Text(
                              'Current Weather',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),

                        // Weather Information Container
                        Container(
                          width: double.infinity,
                          margin: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 20.0),
                          padding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 24.0, 20.0, 24.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).blankCanvas,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).underground,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ========================================
                              // SUB-SECTION 1A: MAIN WEATHER INFO ROW
                              // ========================================
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // City Name and Description Column
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // City Name Text
                                        Text(
                                          isLoadingWeather
                                              ? 'Loading...'
                                              : weatherError != null
                                                  ? 'Error'
                                                  : weatherData?['name']
                                                          ?.toString() ??
                                                      'Unknown',
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLarge
                                                        .fontStyle,
                                              ),
                                        ),
                                        // Weather Description Text
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 8.0, 0.0, 0.0),
                                          child: Text(
                                            isLoadingWeather
                                                ? 'Loading weather...'
                                                : weatherError != null
                                                    ? weatherError!
                                                    : weatherData?['weather']
                                                                    ?[0]
                                                                ?['description']
                                                            ?.toString()
                                                            .toUpperCase() ??
                                                        'N/A',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Temperature and Weather Icon Column
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // Temperature Text
                                        Text(
                                          isLoadingWeather
                                              ? '--°C'
                                              : weatherError != null
                                                  ? '--°C'
                                                  : '${(weatherData?['main']?['temp'] as num?)?.round() ?? '--'}°C',
                                          style: FlutterFlowTheme.of(context)
                                              .headlineLarge
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineLarge
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineLarge
                                                        .fontStyle,
                                              ),
                                        ),
                                        // Weather Icon
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 8.0, 0.0, 0.0),
                                          child: Icon(
                                            isLoadingWeather ||
                                                    weatherError != null
                                                ? Icons.wb_sunny
                                                : _getWeatherIcon(
                                                    weatherData?['weather']?[0]
                                                            ?['icon']
                                                        ?.toString()),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 56.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // ========================================
                              // SUB-SECTION 1B: WEATHER DETAILS ROW
                              // ========================================
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Humidity Widget
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.water_drop,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 32.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 8.0, 0.0, 0.0),
                                            child: Text(
                                              'Humidity',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontStyle,
                                                      ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 4.0, 0.0, 0.0),
                                            child: Text(
                                              isLoadingWeather ||
                                                      weatherError != null
                                                  ? '--%'
                                                  : '${weatherData?['main']?['humidity']?.toString() ?? '--'}%',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Wind Speed Widget
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.air,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 32.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 8.0, 0.0, 0.0),
                                            child: Text(
                                              'Wind Speed',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontStyle,
                                                      ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 4.0, 0.0, 0.0),
                                            child: Text(
                                              isLoadingWeather ||
                                                      weatherError != null
                                                  ? '-- km/h'
                                                  : '${((weatherData?['wind']?['speed'] as num?) != null ? (weatherData!['wind']['speed'] * 3.6).round() : '--')} km/h',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Feels Like Temperature Widget
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.thermostat,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 32.0,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 8.0, 0.0, 0.0),
                                            child: Text(
                                              'Feels Like',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .fontStyle,
                                                      ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 4.0, 0.0, 0.0),
                                            child: Text(
                                              isLoadingWeather ||
                                                      weatherError != null
                                                  ? '--°C'
                                                  : '${(weatherData?['main']?['feels_like'] as num?)?.round() ?? '--'}°C',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // ========================================
                    // SECTION 2: SMART SUGGESTIONS SETTINGS
                    // ========================================
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Settings Section Title
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 0.0),
                            child: Text(
                              'Smart Suggestion Rules',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                        // Settings Section Subtitle
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 5.0, 0.0, 20.0),
                            child: Text(
                              isLoadingSettings
                                  ? 'Loading configuration from Firebase...'
                                  : 'Configure weather-based suggestion parameters for users',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),

                        // ========================================
                        // SUB-SECTION 2A: TEMPERATURE RULES
                        // ========================================
                        Container(
                          width: double.infinity,
                          margin: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).blankCanvas,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).underground,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Temperature Categories Header
                              Row(
                                children: [
                                  Icon(
                                    Icons.thermostat,
                                    color: FlutterFlowTheme.of(context)
                                        .underground,
                                    size: 24.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Temperature Categories',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),

                              // Cold Weather Settings Widget
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '❄️ Cold Weather',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.interTight(),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    // Cold Weather Dropdown Row
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 8.0),
                                      child: Row(
                                        children: [
                                          // Cold Min Temperature Dropdown
                                          Expanded(
                                            child: FlutterFlowDropDown<String>(
                                              controller: _model
                                                      .dropDownValueController4 ??=
                                                  FormFieldController<String>(
                                                      '10°C'),
                                              options: [
                                                '5°C',
                                                '10°C',
                                                '15°C',
                                                '20°C'
                                              ],
                                              onChanged: (val) => safeSetState(
                                                  () => _model.dropDownValue4 =
                                                      val),
                                              width: double.infinity,
                                              height: 40.0,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.inter(),
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintText: 'Min temp',
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 24.0,
                                              ),
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .blankCanvas,
                                              elevation: 2.0,
                                              borderColor:
                                                  FlutterFlowTheme.of(context)
                                                      .underground,
                                              borderWidth: 1.0,
                                              borderRadius: 8.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 0.0, 8.0, 0.0),
                                            child: Text(' - ',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium),
                                          ),
                                          // Cold Max Temperature Dropdown
                                          Expanded(
                                            child: FlutterFlowDropDown<String>(
                                              controller: _model
                                                      .dropDownValueController5 ??=
                                                  FormFieldController<String>(
                                                      '24°C'),
                                              options: [
                                                '20°C',
                                                '22°C',
                                                '24°C',
                                                '26°C'
                                              ],
                                              onChanged: (val) => safeSetState(
                                                  () => _model.dropDownValue5 =
                                                      val),
                                              width: double.infinity,
                                              height: 40.0,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.inter(),
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintText: 'Max temp',
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 24.0,
                                              ),
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .blankCanvas,
                                              elevation: 2.0,
                                              borderColor:
                                                  FlutterFlowTheme.of(context)
                                                      .underground,
                                              borderWidth: 1.0,
                                              borderRadius: 8.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Cold Weather Suggestion Description
                                    Text(
                                      'Suggestions: Jacket, long sleeves, closed shoes, warm layers',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            font: GoogleFonts.inter(),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              // Warm Weather Settings Widget
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '🌤️ Warm Weather',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.interTight(),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    // Warm Weather Dropdown Row
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 8.0),
                                      child: Row(
                                        children: [
                                          // Warm Min Temperature Dropdown
                                          Expanded(
                                            child: FlutterFlowDropDown<String>(
                                              controller:
                                                  dropDownValueController6 ??=
                                                      FormFieldController<
                                                          String>('25°C'),
                                              options: [
                                                '22°C',
                                                '24°C',
                                                '25°C',
                                                '26°C',
                                                '27°C'
                                              ],
                                              onChanged: (val) => safeSetState(
                                                  () => dropDownValue6 = val),
                                              width: double.infinity,
                                              height: 40.0,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.inter(),
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintText: 'Min temp',
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 24.0,
                                              ),
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .blankCanvas,
                                              elevation: 2.0,
                                              borderColor:
                                                  FlutterFlowTheme.of(context)
                                                      .underground,
                                              borderWidth: 1.0,
                                              borderRadius: 8.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 0.0, 8.0, 0.0),
                                            child: Text(' - ',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium),
                                          ),
                                          // Warm Max Temperature Dropdown
                                          Expanded(
                                            child: FlutterFlowDropDown<String>(
                                              controller:
                                                  dropDownValueController7 ??=
                                                      FormFieldController<
                                                          String>('29°C'),
                                              options: [
                                                '27°C',
                                                '28°C',
                                                '29°C',
                                                '30°C',
                                                '31°C'
                                              ],
                                              onChanged: (val) => safeSetState(
                                                  () => dropDownValue7 = val),
                                              width: double.infinity,
                                              height: 40.0,
                                              textStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.inter(),
                                                        letterSpacing: 0.0,
                                                      ),
                                              hintText: 'Max temp',
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 24.0,
                                              ),
                                              fillColor:
                                                  FlutterFlowTheme.of(context)
                                                      .blankCanvas,
                                              elevation: 2.0,
                                              borderColor:
                                                  FlutterFlowTheme.of(context)
                                                      .underground,
                                              borderWidth: 1.0,
                                              borderRadius: 8.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Warm Weather Suggestion Description
                                    Text(
                                      'Suggestions: Light clothing, comfortable wear, breathable fabrics',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            font: GoogleFonts.inter(),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              // Hot Weather Settings Widget
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🔥 Hot Weather',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.interTight(),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  // Hot Weather Dropdown Row
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 0.0, 8.0),
                                    child: Row(
                                      children: [
                                        // Hot Temperature Threshold Dropdown
                                        Expanded(
                                          child: FlutterFlowDropDown<String>(
                                            controller:
                                                dropDownValueController8 ??=
                                                    FormFieldController<String>(
                                                        '30°C'),
                                            options: [
                                              '28°C',
                                              '29°C',
                                              '30°C',
                                              '31°C',
                                              '32°C',
                                              '33°C'
                                            ],
                                            onChanged: (val) => safeSetState(
                                                () => dropDownValue8 = val),
                                            width: double.infinity,
                                            height: 40.0,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(),
                                                      letterSpacing: 0.0,
                                                    ),
                                            hintText: 'Threshold temp',
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 24.0,
                                            ),
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .blankCanvas,
                                            elevation: 2.0,
                                            borderColor:
                                                FlutterFlowTheme.of(context)
                                                    .underground,
                                            borderWidth: 1.0,
                                            borderRadius: 8.0,
                                            margin:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12.0, 0.0, 12.0, 0.0),
                                            hidesUnderline: true,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'and above',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Hot Weather Suggestion Description
                                  Text(
                                    'Suggestions: Light colors, UV protection, sunglasses, hat, sunscreen',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.inter(),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ========================================
                        // SUB-SECTION 2B: HUMIDITY RULES
                        // ========================================
                        Container(
                          width: double.infinity,
                          margin: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).blankCanvas,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).underground,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Humidity Rules Header
                              Row(
                                children: [
                                  Icon(
                                    Icons.water_drop,
                                    color: FlutterFlowTheme.of(context)
                                        .underground,
                                    size: 24.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Humidity Rules',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.interTight(),
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              // High Humidity Alert Switch Widget
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'High Humidity Alert (>80%)',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.interTight(),
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    Switch.adaptive(
                                      value: humidityAlertSwitch,
                                      onChanged: (newValue) async {
                                        safeSetState(() =>
                                            humidityAlertSwitch = newValue);
                                      },
                                      activeTrackColor:
                                          FlutterFlowTheme.of(context)
                                              .northAtlantic,
                                      inactiveTrackColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      inactiveThumbColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                    ),
                                  ],
                                ),
                              ),
                              // Humidity Suggestion Description
                              Text(
                                'Suggestions: Moisture-wicking fabrics, avoid heavy materials, stay hydrated',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        // ========================================
                        // SUB-SECTION 2C: WEATHER CONDITIONS RULES
                        // ========================================
                        Container(
                          width: double.infinity,
                          margin: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 16.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).blankCanvas,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).underground,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Weather Conditions Header
                              Row(
                                children: [
                                  Icon(
                                    Icons.wb_cloudy,
                                    color: FlutterFlowTheme.of(context)
                                        .underground,
                                    size: 24.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Weather Conditions',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.interTight(),
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),

                              // Rain Detection Switch Widget
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '🌧️ Rain Detection',
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 4.0, 0.0, 0.0),
                                          child: Text(
                                            'Auto-suggest rain gear',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.inter(),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Switch.adaptive(
                                      value: rainDetectionSwitch,
                                      onChanged: (newValue) async {
                                        safeSetState(() =>
                                            rainDetectionSwitch = newValue);
                                      },
                                      activeTrackColor:
                                          FlutterFlowTheme.of(context)
                                              .northAtlantic,
                                      inactiveTrackColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      inactiveThumbColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                    ),
                                  ],
                                ),
                              ),

                              // Strong Wind Switch Widget
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '💨 Strong Wind (>25 km/h)',
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 4.0, 0.0, 0.0),
                                          child: Text(
                                            'Avoid loose clothing',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.inter(),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  letterSpacing: 0.0,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Switch.adaptive(
                                      value: strongWindSwitch,
                                      onChanged: (newValue) async {
                                        safeSetState(
                                            () => strongWindSwitch = newValue);
                                      },
                                      activeTrackColor:
                                          FlutterFlowTheme.of(context)
                                              .northAtlantic,
                                      inactiveTrackColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      inactiveThumbColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                    ),
                                  ],
                                ),
                              ),

                              // UV Protection Switch Widget
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '☀️ High UV Index (>6)',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.interTight(),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 4.0, 0.0, 0.0),
                                        child: Text(
                                          'Sun protection required',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.inter(),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Switch.adaptive(
                                    value: uvProtectionSwitch,
                                    onChanged: (newValue) async {
                                      safeSetState(
                                          () => uvProtectionSwitch = newValue);
                                    },
                                    activeTrackColor:
                                        FlutterFlowTheme.of(context)
                                            .northAtlantic,
                                    inactiveTrackColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    inactiveThumbColor:
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ========================================
                        // SECTION 3: SAVE SETTINGS BUTTON
                        // ========================================
                        Container(
                          width: double.infinity,
                          margin: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 20.0),
                          child: ElevatedButton(
                            onPressed: isLoadingSettings ? null : _saveSettings,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLoadingSettings
                                  ? Colors.grey
                                  : FlutterFlowTheme.of(context).northAtlantic,
                              foregroundColor: Colors.white,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 16.0, 0.0, 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 2.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Save Button Icon
                                Icon(
                                  isLoadingSettings
                                      ? Icons.hourglass_empty
                                      : Icons.save,
                                  size: 20.0,
                                  color: Colors.white,
                                ),
                                // Save Button Text
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    isLoadingSettings
                                        ? 'Loading...'
                                        : 'Save Settings',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.interTight(),
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ========================================
                        // SECTION 4: SMART SUGGESTION PREVIEW
                        // ========================================
                        Container(
                          width: double.infinity,
                          margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0,
                              100.0), // Extra margin for bottom nav bar
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 16.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Color(0xFFE3F2FD),
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Preview Section Header
                              Row(
                                children: [
                                  // Preview Status Icon
                                  Icon(
                                    settingsAreSaved
                                        ? Icons.check_circle
                                        : isLoadingSettings
                                            ? Icons.hourglass_empty
                                            : Icons.lightbulb,
                                    color: settingsAreSaved
                                        ? Colors.green
                                        : isLoadingSettings
                                            ? Colors.orange
                                            : Color(0xFF1976D2),
                                    size: 24.0,
                                  ),
                                  // Preview Section Title
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      settingsAreSaved
                                          ? 'Live Preview (Based on Saved Settings)'
                                          : isLoadingSettings
                                              ? 'Loading Settings from Firebase'
                                              : 'Preview (Using Default Settings)',
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.interTight(),
                                            color: settingsAreSaved
                                                ? Colors.green
                                                : isLoadingSettings
                                                    ? Colors.orange
                                                    : Color(0xFF1976D2),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              // Preview Content Container
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 12.0, 12.0, 12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Main Suggestion Text Widget
                                      Text(
                                        isLoadingWeather || weatherError != null
                                            ? 'Loading current conditions...'
                                            : weatherData != null
                                                ? _generateSmartSuggestion(
                                                    weatherData!)
                                                : 'No weather data available',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              font: GoogleFonts.inter(),
                                              letterSpacing: 0.0,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16.0,
                                            ),
                                      ),

                                      // Notification Message Widget
                                      if (weatherData != null &&
                                          !isLoadingWeather &&
                                          weatherError == null)
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 12.0, 0.0, 0.0),
                                          child: Text(
                                            _getNotificationMessage(),
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.inter(),
                                                  letterSpacing: 0.0,
                                                  fontSize: 12.0,
                                                  color: isLoadingSettings
                                                      ? Colors.orange.shade700
                                                      : settingsAreSaved
                                                          ? Colors
                                                              .green.shade700
                                                          : Colors
                                                              .orange.shade700,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
