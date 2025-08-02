// Add these imports at the top of your file
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '/backend/backend.dart'; // Firebase backend integration
import '/auth/firebase_auth/auth_util.dart'; // Add this import for logout functionality

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? temperature;
  late String currentDate;

  // Smart suggestion variables
  SuggestionSettingsRecord? suggestionSettings;
  String smartSuggestion = "Loading personalized suggestions...";
  Map<String, dynamic>? fullWeatherData;
  DocumentReference? settingsDocRef;
  bool isLoadingSuggestions = true;

  // Trending items variables
  List<BrandedItemsRecord> trendingItems = [];
  bool isLoadingTrendingItems = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    currentDate = DateFormat('dd/MM').format(DateTime.now());

    // Initialize Firebase settings document reference
    settingsDocRef = SuggestionSettingsRecord.collection.doc('global_settings');

    // Load suggestion settings first, then weather, then trending items
    _loadSuggestionSettings().then((_) {
      getTemperature();
    });

    // Load trending items
    _loadTrendingItems();
  }

  // Load trending items from Firebase
  Future<void> _loadTrendingItems() async {
    try {
      print('🔄 Loading trending items...');

      // Query branded items with status filtering to exclude deleted products
      final trendingItemsQuery = await queryBrandedItemsRecordOnce(
        queryBuilder: (query) => query
            // ADDED: Filter out deleted products
            .where('status', isNotEqualTo: 'removed_for_violation')
            .orderBy('date_added', descending: true)
            .limit(6),
      );

      // ADDED: Additional client-side filtering as safety net
      final filteredItems = trendingItemsQuery.where((item) {
        // Filter out products that are deleted or have removal timestamp
        return item.status != 'removed_for_violation' && item.removedAt == null;
      }).toList();

      setState(() {
        trendingItems = filteredItems;
        isLoadingTrendingItems = false;
      });

      print('✅ Loaded ${trendingItems.length} active trending items');

      // Print details for debugging
      for (int i = 0; i < trendingItems.length; i++) {
        final item = trendingItems[i];
        print(
            'Item ${i + 1}: ${item.name} (${item.itemId}) - Status: ${item.status}');
      }
    } catch (e) {
      print('❌ Error loading trending items: $e');
      setState(() {
        isLoadingTrendingItems = false;
      });
    }
  }

  // Navigate to product details page
  void _navigateToProductDetails(BrandedItemsRecord item) {
    try {
      print('Navigating to product details for: ${item.name}');

      // Create query parameters for the product details page
      final queryParams = {
        'documentId': item.reference.id,
        'itemId': item.itemId,
        'name': item.name,
        'description': item.description,
        'price': item.price.toStringAsFixed(2),
        'imageUrl': item.imageUrl,
        'category': item.category,
        'productUrl': item.productUrl,
        'vendorId': item.vendorId,
        'styleTags': item.styleTags.join(','),
        'weatherSuitability': item.weatherSuitability.join(','),
      };

      // Navigate using query parameters
      context.pushNamed(
        ProductDetailsPageWidget.routeName,
        queryParameters: queryParams,
      );

      print('Navigation triggered with params: $queryParams');
    } catch (e) {
      print('Error navigating to product details: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening product details. Please try again.'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      );
    }
  }

  // Load suggestion settings from Firebase
  Future<void> _loadSuggestionSettings() async {
    try {
      print('🔄 Loading suggestion settings...');

      suggestionSettings =
          await SuggestionSettingsRecord.getDocumentOnce(settingsDocRef!);

      if (suggestionSettings != null) {
        print('✅ Suggestion settings loaded successfully');
        print(
            'Temperature ranges: Cold(${suggestionSettings!.weatherTempColdMin}-${suggestionSettings!.weatherTempColdMax}), Warm(${suggestionSettings!.weatherTempWarmMin}-${suggestionSettings!.weatherTempWarmMax}), Hot(${suggestionSettings!.weatherTempHotMin}+)');
      } else {
        print('⚠️ No suggestion settings found, will use defaults');
        setState(() {
          smartSuggestion =
              "Default weather suggestions enabled - personalized settings not configured by admin yet.";
        });
      }
    } catch (e) {
      print('❌ Error loading suggestion settings: $e');
      setState(() {
        smartSuggestion =
            "Unable to load personalized settings. Please check your connection.";
        isLoadingSuggestions = false;
      });
    }
  }

  // Get temperature and generate smart suggestions
  Future<void> getTemperature() async {
    final city = 'Kuala Lumpur';
    final apiKey = 'e94a49d026651e92567ebe5d78715d81';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      print('🌤️ Fetching weather data...');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = data['main']['temp'].toStringAsFixed(1);
          fullWeatherData = data;

          if (suggestionSettings != null) {
            smartSuggestion = _generateSmartSuggestion(data);
            print(
                '✅ Smart suggestion generated: ${smartSuggestion.substring(0, 50)}...');
          } else {
            smartSuggestion =
                "Weather data loaded, but personalized settings unavailable. Using basic suggestions.";
          }
          isLoadingSuggestions = false;
        });
      } else {
        print('Failed to load weather data: ${response.statusCode}');
        setState(() {
          smartSuggestion = "Unable to load weather data for suggestions";
          isLoadingSuggestions = false;
        });
      }
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        smartSuggestion =
            "Error loading weather-based suggestions. Please check your connection.";
        isLoadingSuggestions = false;
      });
    }
  }

  // Generate smart suggestions
  String _generateSmartSuggestion(Map<String, dynamic> weather) {
    if (suggestionSettings == null) {
      final temp = (weather['main']?['temp'] as num?)?.round() ?? 0;
      final description =
          weather['weather']?[0]?['main']?.toString().toLowerCase() ?? '';

      if (temp <= 24) {
        return "🧥 Cool weather (${temp}°C) - consider wearing a light jacket or long sleeves";
      } else if (temp >= 30) {
        return "☀️ Hot weather (${temp}°C) - stay cool with light clothing and stay hydrated";
      } else {
        return "👕 Pleasant weather (${temp}°C) - perfect for comfortable, casual clothing";
      }
    }

    final temp = (weather['main']?['temp'] as num?)?.round() ?? 0;
    final humidity = (weather['main']?['humidity'] as num?) ?? 0;
    final windSpeed = ((weather['wind']?['speed'] as num?) ?? 0) * 3.6;
    final description =
        weather['weather']?[0]?['main']?.toString().toLowerCase() ?? '';

    List<String> suggestions = [];

    if (temp <= suggestionSettings!.weatherTempColdMax) {
      suggestions.add(
          "🧥 Cold weather detected (${temp}°C) - wear warm layers, jacket, and closed shoes");
    } else if (temp >= suggestionSettings!.weatherTempWarmMin &&
        temp <= suggestionSettings!.weatherTempWarmMax) {
      suggestions.add(
          "👕 Perfect weather (${temp}°C) - light, breathable clothing recommended");
    } else if (temp >= suggestionSettings!.weatherTempHotMin) {
      suggestions.add(
          "☀️ Hot weather (${temp}°C) - wear light colors, UV protection, and stay hydrated");
    }

    if (suggestionSettings!.weatherHumidityAlert && humidity > 80) {
      suggestions.add(
          "💧 High humidity (${humidity}%) - choose moisture-wicking fabrics and avoid heavy materials");
    }

    if (suggestionSettings!.weatherStrongWind && windSpeed > 25) {
      suggestions.add(
          "💨 Strong winds (${windSpeed.round()} km/h) - avoid loose clothing and secure accessories");
    }

    if (suggestionSettings!.weatherRainDetection &&
        description.contains('rain')) {
      suggestions.add(
          "🌧️ Rain detected - bring an umbrella and consider waterproof clothing");
    }

    if (suggestionSettings!.weatherUvProtection &&
        description.contains('clear') &&
        temp >= suggestionSettings!.weatherTempHotMin) {
      suggestions.add(
          "🕶️ Clear skies and hot weather - sunglasses, hat, and sunscreen are essential");
    }

    if (suggestions.isEmpty) {
      return "Perfect weather conditions! Dress comfortably and enjoy your day! ☀️";
    }

    return suggestions.join('\n\n');
  }

  // NEW: Logout functionality matching admin dashboard design
  Future<void> _showLogoutConfirmation() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await _performLogout();
    }
  }

  // NEW: Perform logout matching admin dashboard
  Future<void> _performLogout() async {
    try {
      // Add your logout logic here
      // For example:
      await authManager.signOut();
      context.pushReplacementNamed(LoginPageWidget.routeName);
      print('User logged out');
    } catch (e) {
      print('Error during logout: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out. Please try again.'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
            child: Text(
              FFLocalizations.of(context).getText(
                '5ppbgqhi' /* Home */,
              ),
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.interTight(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).underground,
                    fontSize: 30.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
            ),
          ),
          // NEW: Add logout button matching admin dashboard design
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.logout,
                  color: FlutterFlowTheme.of(context).underground,
                  size: 26.0,
                ),
                onPressed: _showLogoutConfirmation,
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Card Section
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 12.0, 16.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: 280.0,
                          ),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x25090F13),
                                offset: Offset(0.0, 2.0),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 12.0, 12.0, 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'ljy2dica' /* Welcome back, */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .underground,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  FFLocalizations.of(context).getText(
                                    '7ylrldap' /* hope you enjoy the virtual wardrobe */,
                                  ),
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
                                        color: FlutterFlowTheme.of(context)
                                            .underground,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                ),
                                Divider(
                                  height: 24.0,
                                  thickness: 2.0,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            FFLocalizations.of(context).getText(
                                              'z7zma923' /* Date */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .underground,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Text(
                                            currentDate,
                                            style: FlutterFlowTheme.of(context)
                                                .displaySmall
                                                .override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .displaySmall
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .underground,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w300,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .displaySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            FFLocalizations.of(context).getText(
                                              '7l2m0dmr' /* Temperature */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .underground,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                temperature != null
                                                    ? '$temperature°C'
                                                    : '...',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .displaySmall
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .underground,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .displaySmall
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        4.0, 0.0, 0.0, 0.0),
                                                child: FaIcon(
                                                  FontAwesomeIcons
                                                      .temperatureLow,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .latte,
                                                  size: 20.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Outfit Suggest Section
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        FFLocalizations.of(context).getText(
                                          '8nn2q56u' /* Outfit Suggest */,
                                        ),
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .underground,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                      ),

                                      // Smart Suggestion Container
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  14.0, 14.0, 14.0, 14.0),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFF8F9FA),
                                                Color(0xFFE3F2FD),
                                              ],
                                              stops: [0.0, 1.0],
                                              begin: AlignmentDirectional(
                                                  0.0, -1.0),
                                              end: AlignmentDirectional(
                                                  0.0, 1.0),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .underground
                                                      .withOpacity(0.1),
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Header with icon
                                              Row(
                                                children: [
                                                  Icon(
                                                    isLoadingSuggestions
                                                        ? Icons.hourglass_empty
                                                        : Icons
                                                            .lightbulb_outline,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .underground,
                                                    size: 18.0,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(6.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Text(
                                                      isLoadingSuggestions
                                                          ? 'Loading Smart Suggestions'
                                                          : 'Smart Weather Suggestions',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .interTight(),
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .underground,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14.0,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // Suggestion text
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 10.0, 0.0, 0.0),
                                                child: Text(
                                                  smartSuggestion,
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .underground,
                                                        letterSpacing: 0.0,
                                                        lineHeight: 1.4,
                                                      ),
                                                ),
                                              ),

                                              // Weather info footer
                                              if (fullWeatherData != null &&
                                                  !isLoadingSuggestions)
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 10.0, 0.0, 0.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(10.0, 6.0,
                                                                10.0, 6.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          suggestionSettings !=
                                                                  null
                                                              ? 'Personalized for current KL weather'
                                                              : 'Basic weather suggestions for KL',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .inter(),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontSize: 11.0,
                                                              ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              suggestionSettings !=
                                                                      null
                                                                  ? Icons
                                                                      .verified
                                                                  : Icons
                                                                      .info_outline,
                                                              color:
                                                                  suggestionSettings !=
                                                                          null
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .orange,
                                                              size: 14.0,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          3.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                suggestionSettings !=
                                                                        null
                                                                    ? 'Live'
                                                                    : 'Basic',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(),
                                                                      color: suggestionSettings !=
                                                                              null
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .orange,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontSize:
                                                                          11.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
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
                          ),
                        ),
                      ),

                      // Quick Action Section
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 12.0, 0.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'fca3pt0z' /* Quick Action */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                font: GoogleFonts.interTight(),
                                color: FlutterFlowTheme.of(context).underground,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 5.0, 15.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed(AddNewItemWidget.routeName);
                              },
                              text: FFLocalizations.of(context).getText(
                                '9aptqlfu' /* Add Item */,
                              ),
                              options: FFButtonOptions(
                                width: 180.0,
                                height: 45.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).waxFlower,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.interTight(),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed(OutfitMatchWidget.routeName);
                              },
                              text: FFLocalizations.of(context).getText(
                                'coav3yn9' /* Match Outfit */,
                              ),
                              options: FFButtonOptions(
                                width: 180.0,
                                height: 45.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).waxFlower,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.interTight(),
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Trending Items Section
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 12.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                'hi7i3b2j' /* Trending Items */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.interTight(),
                                    color: FlutterFlowTheme.of(context)
                                        .underground,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            if (isLoadingTrendingItems)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 16.0, 0.0),
                                child: SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).underground,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Trending Items List from Firebase
                      if (isLoadingTrendingItems)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).underground,
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  Text(
                                    'Loading trending items...',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
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
                          ),
                        )
                      else if (trendingItems.isEmpty)
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 40.0,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'No trending items found',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
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
                          ),
                        )
                      else
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: trendingItems.length,
                          itemBuilder: (context, index) {
                            final item = trendingItems[index];
                            return _buildTrendingItemCard(item, index);
                          },
                        ),

                      SizedBox(height: 100.0), // Add bottom spacing for nav bar
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).underground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.0,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.home_rounded,
                    label: FFLocalizations.of(context)
                        .getText('syg4oh76' /* Home */),
                    isActive: true,
                    onTap: () {
                      // Already on home page
                    },
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.checkroom_rounded,
                    label: FFLocalizations.of(context)
                        .getText('8pv8eu1d' /* Wardrobe */),
                    isActive: false,
                    onTap: () => context.pushNamed(MyWardrodeWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.style_rounded,
                    label: FFLocalizations.of(context)
                        .getText('p35nqmcv' /* Match */),
                    isActive: false,
                    onTap: () => context.pushNamed(OutfitMatchWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.shopping_bag_rounded,
                    label: FFLocalizations.of(context)
                        .getText('egb8i29n' /* Shop */),
                    isActive: false,
                    onTap: () => context.pushNamed(BuyClothesWidget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.calendar_month_rounded,
                    label: FFLocalizations.of(context)
                        .getText('bzj3zlzq' /* Calendar */),
                    isActive: false,
                    onTap: () =>
                        context.pushNamed(OutfitPlanner2Widget.routeName),
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.person_rounded,
                    label: FFLocalizations.of(context)
                        .getText('zbeaamf9' /* Profile */),
                    isActive: false,
                    onTap: () => context.pushNamed(UserProfileWidget.routeName),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build trending item card widget
  Widget _buildTrendingItemCard(BrandedItemsRecord item, int index) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
          16.0, index == 0 ? 5.0 : 12.0, 16.0, 0.0),
      child: GestureDetector(
        onTap: () => _navigateToProductDetails(item),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 3.0,
                color: Color(0x411D2429),
                offset: Offset(0.0, 1.0),
              )
            ],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Product Image
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 1.0, 1.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: item.imageUrl.isNotEmpty
                        ? Image.network(
                            item.imageUrl,
                            width: 70.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 70.0,
                                height: 100.0,
                                color: FlutterFlowTheme.of(context).alternate,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).underground,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 70.0,
                                height: 100.0,
                                color: FlutterFlowTheme.of(context).alternate,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 30.0,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 70.0,
                            height: 100.0,
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              Icons.checkroom,
                              size: 30.0,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                  ),
                ),

                // Product Info
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 4.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          item.name.isNotEmpty ? item.name : 'Untitled Item',
                          style: FlutterFlowTheme.of(context)
                              .titleLarge
                              .override(
                                font: GoogleFonts.interTight(),
                                color: FlutterFlowTheme.of(context).underground,
                                letterSpacing: 0.0,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 4.0),

                        // Product Description
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 8.0, 0.0),
                          child: AutoSizeText(
                            item.description.isNotEmpty
                                ? item.description
                                : 'No description available',
                            textAlign: TextAlign.start,
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                    ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: 4.0),
                      ],
                    ),
                  ),
                ),

                // Arrow Icon
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: isActive
              ? FlutterFlowTheme.of(context).waxFlower.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.0,
              color: isActive
                  ? FlutterFlowTheme.of(context).waxFlower
                  : FlutterFlowTheme.of(context).info,
            ),
            SizedBox(height: 4.0),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.inter(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                    color: isActive
                        ? FlutterFlowTheme.of(context).waxFlower
                        : FlutterFlowTheme.of(context).info,
                    fontSize: 11.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
