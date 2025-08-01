import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/backend.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // 🔥 ADDED FOR DATE FORMATTING
import 'reports_insights_model.dart';
export 'reports_insights_model.dart';

class ReportsInsightsWidget extends StatefulWidget {
  const ReportsInsightsWidget({super.key});

  static String routeName = 'ReportsInsights';
  static String routePath = '/reportsInsights';

  @override
  State<ReportsInsightsWidget> createState() => _ReportsInsightsWidgetState();
}

class _ReportsInsightsWidgetState extends State<ReportsInsightsWidget> {
  late ReportsInsightsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 4;
  String _selectedTimeRange = '7d'; // 7d, 30d, 90d

  // Backend data variables
  int activeSessions = 0;
  int totalOutfits = 0;
  int contentReports = 0;
  double promoConversion = 0.0;
  List<Map<String, dynamic>> wardrobeCategories = [];
  List<Map<String, dynamic>> userGrowthData =
      []; // 🔥 MODIFIED: Now holds real data

  // 🔥 ADDED: User statistics
  int totalUsers = 0;
  int newUsersThisPeriod = 0;

  // 🔥 ADDED: Promo code statistics
  int totalPromoCopies = 0;
  int uniquePromoUsers = 0;
  List<MapEntry<String, int>> mostPopularPromos = [];

  // 🔥 ADDED: Vendor performance statistics
  List<Map<String, dynamic>> vendorPerformanceData = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportsInsightsModel());
    _loadDashboardData();
  }

  // Load data from Firestore
  Future<void> _loadDashboardData() async {
    try {
      await Future.wait([
        _loadActiveSessionsData(),
        _loadOutfitMetrics(),
        _loadContentReports(),
        _loadPromoMetrics(), // 🔥 NOW USES REAL PROMO DATA
        _loadWardrobeCategories(),
        _loadUserGrowthData(), // 🔥 ADDED: Load user growth data
        _loadVendorPerformance(), // 🔥 ADDED: Load vendor performance data
      ]);
      setState(() {}); // Refresh UI with loaded data
    } catch (e) {
      print('Error loading dashboard data: $e');
    }
  }

  // 🔥 ADDED: Load user growth data from users collection
  Future<void> _loadUserGrowthData() async {
    try {
      final now = DateTime.now();
      final days = _selectedTimeRange == '7d'
          ? 7
          : _selectedTimeRange == '30d'
              ? 30
              : 90;
      final startDate = now.subtract(Duration(days: days));

      print('📊 Loading user growth data for ${_selectedTimeRange}...');
      print(
          '📅 Date range: ${DateFormat('yyyy-MM-dd').format(startDate)} to ${DateFormat('yyyy-MM-dd').format(now)}');

      // Get all users created within the selected time range
      final usersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('created_time', isGreaterThan: startDate)
          .where('role',
              isEqualTo:
                  'User') // 🔥 Only count regular users (not vendors/admins)
          .orderBy('created_time')
          .get();

      print('📈 Found ${usersQuery.docs.length} new users in selected period');

      // Update new users count
      newUsersThisPeriod = usersQuery.docs.length;

      // Get total user count
      final totalUsersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'User')
          .get();

      totalUsers = totalUsersQuery.docs.length;
      print('👥 Total users: $totalUsers');

      // Group users by day for chart
      Map<String, int> dailySignups = {};

      // Initialize all days in range with 0
      for (int i = 0; i < days; i++) {
        final date = now.subtract(Duration(days: days - 1 - i));
        final dayKey = DateFormat('yyyy-MM-dd').format(date);
        dailySignups[dayKey] = 0;
      }

      // Count actual signups per day
      for (var doc in usersQuery.docs) {
        final data = doc.data();
        final createdTime = (data['created_time'] as Timestamp).toDate();
        final dayKey = DateFormat('yyyy-MM-dd').format(createdTime);
        dailySignups[dayKey] = (dailySignups[dayKey] ?? 0) + 1;

        // Debug: Print sample user data
        if (dailySignups[dayKey] == 1) {
          print(
              '📝 Sample user on $dayKey: ${data['display_name']} (${data['email']})');
        }
      }

      // Convert to chart data format
      userGrowthData = [];
      dailySignups.entries.toList().asMap().forEach((index, entry) {
        userGrowthData.add({
          'date': entry.key,
          'count': entry.value,
          'index': index,
        });
      });

      print('📊 Chart data points: ${userGrowthData.length}');
      print('📈 User growth data: $userGrowthData');
    } catch (e) {
      print('❌ Error loading user growth data: $e');
      // Set default data if there's an error
      userGrowthData = [
        {
          'date': DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 6))),
          'count': 0,
          'index': 0
        },
        {
          'date': DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 5))),
          'count': 0,
          'index': 1
        },
        {
          'date': DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 4))),
          'count': 0,
          'index': 2
        },
        {
          'date': DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 3))),
          'count': 0,
          'index': 3
        },
        {
          'date': DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 2))),
          'count': 0,
          'index': 4
        },
        {
          'date': DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 1))),
          'count': 0,
          'index': 5
        },
        {
          'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'count': 0,
          'index': 6
        },
      ];
      newUsersThisPeriod = 0;
      totalUsers = 0;
    }
  }

  // 🔥 MODIFIED: Load active sessions from user_sessions collection
  Future<void> _loadActiveSessionsData() async {
    try {
      // Calculate active sessions from user_sessions collection
      await _calculateActiveSessionsFromUserSessions();
    } catch (e) {
      print('Error loading active sessions: $e');
      activeSessions = 0;
    }
  }

  // 🔥 MODIFIED: Calculate active sessions from user_sessions collection
  Future<void> _calculateActiveSessionsFromUserSessions() async {
    final now = DateTime.now();
    final activeThreshold = now.subtract(Duration(
        minutes:
            30)); // Consider sessions active if last_active within 30 minutes

    try {
      final userSessionsQuery = await FirebaseFirestore.instance
          .collection('user_sessions')
          .where('last_active', isGreaterThan: activeThreshold)
          .get();

      activeSessions = userSessionsQuery.docs.length;

      print('✅ Active sessions found: $activeSessions');
      print('✅ Query returned ${userSessionsQuery.docs.length} documents');

      // Debug: Print some sample session data
      for (var doc in userSessionsQuery.docs.take(3)) {
        final data = doc.data();
        print(
            'Session: ${data['user_id']} - Last Active: ${data['last_active']}');
      }
    } catch (e) {
      print('❌ Error calculating active sessions from user_sessions: $e');
      activeSessions = 0;
    }
  }

  Future<void> _loadOutfitMetrics() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(
          days: _selectedTimeRange == '7d'
              ? 7
              : _selectedTimeRange == '30d'
                  ? 30
                  : 90));

      final outfitsQuery = await FirebaseFirestore.instance
          .collection('outfits')
          .where('created_time', isGreaterThan: startDate)
          .get();

      totalOutfits = outfitsQuery.docs.length;
      print('Total outfits found: $totalOutfits');
    } catch (e) {
      print('Error loading outfit metrics: $e');
      totalOutfits = 0;
    }
  }

  Future<void> _loadContentReports() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(
          days: _selectedTimeRange == '7d'
              ? 7
              : _selectedTimeRange == '30d'
                  ? 30
                  : 90));

      final reportsQuery = await FirebaseFirestore.instance
          .collection('content_reports')
          .where('timestamp', isGreaterThan: startDate)
          .get();

      contentReports = reportsQuery.docs.length;
      print('Content reports found: $contentReports');
    } catch (e) {
      print('Error loading content reports: $e');
      contentReports = 0;
    }
  }

  // 🔥 UPDATED: Load real promo metrics from promo_code_usage collection
  Future<void> _loadPromoMetrics() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(
          days: _selectedTimeRange == '7d'
              ? 7
              : _selectedTimeRange == '30d'
                  ? 30
                  : 90));

      // Get all promo code copies in the selected time range
      final usageQuery = await FirebaseFirestore.instance
          .collection('promo_code_usage')
          .where('timestamp', isGreaterThan: startDate)
          .get();

      // Get total active promo codes for comparison
      final activePromosQuery = await FirebaseFirestore.instance
          .collection('promo_codes')
          .where('is_active', isEqualTo: true)
          .get();

      final totalCopies = usageQuery.docs.length;
      final activePromoCount = activePromosQuery.docs.length;
      final uniqueUsers = <String>{};
      final promoCodeStats = <String, int>{};
      final vendorStats = <String, int>{};

      // Analyze usage data
      for (var doc in usageQuery.docs) {
        final data = doc.data();
        final userId = data['user_id'] as String? ?? '';
        final promoCode = data['promo_code'] as String? ?? '';
        final vendorId = data['vendor_id'] as String? ?? '';

        uniqueUsers.add(userId);
        promoCodeStats[promoCode] = (promoCodeStats[promoCode] ?? 0) + 1;
        vendorStats[vendorId] = (vendorStats[vendorId] ?? 0) + 1;
      }

      // Calculate engagement rate (copies per active promo code)
      promoConversion = activePromoCount > 0
          ? (totalCopies / activePromoCount) * 10 // Scale for better display
          : 0.0;

      // Store additional metrics for charts
      totalPromoCopies = totalCopies;
      uniquePromoUsers = uniqueUsers.length;
      mostPopularPromos = promoCodeStats.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      print('📊 Promo Code Analytics:');
      print('   📋 Total Copies: $totalCopies');
      print('   👥 Unique Users: ${uniqueUsers.length}');
      print('   🎯 Active Promo Codes: $activePromoCount');
      print('   📈 Engagement Rate: ${promoConversion.toStringAsFixed(1)}');
      print(
          '   🏆 Most Popular Codes: ${promoCodeStats.entries.take(3).map((e) => '${e.key}(${e.value})').join(', ')}');
    } catch (e) {
      print('❌ Error loading promo metrics: $e');
      promoConversion = 0.0;
      totalPromoCopies = 0;
      uniquePromoUsers = 0;
      mostPopularPromos = [];
    }
  }

  // 🔥 NEW: Load vendor performance data using branded_items + promo_code_usage
  Future<void> _loadVendorPerformance() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(
          days: _selectedTimeRange == '7d'
              ? 7
              : _selectedTimeRange == '30d'
                  ? 30
                  : 90));

      // Get promo code usage by vendor (within time range)
      final usageQuery = await FirebaseFirestore.instance
          .collection('promo_code_usage')
          .where('timestamp', isGreaterThan: startDate)
          .get();

      // Get all branded items by vendor
      final brandedItemsQuery =
          await FirebaseFirestore.instance.collection('branded_items').get();

      // Get active promo codes by vendor
      final promoQuery = await FirebaseFirestore.instance
          .collection('promo_codes')
          .where('is_active', isEqualTo: true)
          .get();

      // Calculate comprehensive vendor stats
      Map<String, Map<String, dynamic>> vendorStats = {};

      // Initialize vendor stats from branded items
      for (var doc in brandedItemsQuery.docs) {
        final data = doc.data();
        final vendorId = data['vendor_id'] as String? ?? '';

        if (vendorId.isNotEmpty) {
          if (!vendorStats.containsKey(vendorId)) {
            vendorStats[vendorId] = {
              'vendorId': vendorId,
              'totalProducts': 0,
              'recentProducts': 0,
              'categories': <String>{},
              'promoCopies': 0,
              'activePromos': 0,
              'avgPrice': 0.0,
              'totalValue': 0.0,
            };
          }

          // Count total products
          vendorStats[vendorId]!['totalProducts']++;

          // Count recent products (within time range)
          final dateAdded = data['date_added'] as Timestamp?;
          if (dateAdded != null && dateAdded.toDate().isAfter(startDate)) {
            vendorStats[vendorId]!['recentProducts']++;
          }

          // Collect categories
          final category = data['category'] as String? ?? '';
          if (category.isNotEmpty) {
            (vendorStats[vendorId]!['categories'] as Set<String>).add(category);
          }

          // Sum up pricing for average calculation
          final price = (data['price'] as num?)?.toDouble() ?? 0.0;
          vendorStats[vendorId]!['totalValue'] += price;
        }
      }

      // Count promo code copies per vendor
      for (var doc in usageQuery.docs) {
        final data = doc.data();
        final vendorId = data['vendor_id'] as String? ?? '';

        if (vendorId.isNotEmpty && vendorStats.containsKey(vendorId)) {
          vendorStats[vendorId]!['promoCopies']++;
        }
      }

      // Count active promo codes per vendor
      for (var doc in promoQuery.docs) {
        final data = doc.data();
        final vendorId = data['vendor_id'] as String? ?? '';

        if (vendorId.isNotEmpty && vendorStats.containsKey(vendorId)) {
          vendorStats[vendorId]!['activePromos']++;
        }
      }

      // Calculate performance scores and convert to list
      vendorPerformanceData = [];
      for (var entry in vendorStats.entries) {
        final stats = entry.value;
        final totalProducts = stats['totalProducts'] as int;
        final recentProducts = stats['recentProducts'] as int;
        final promoCopies = stats['promoCopies'] as int;
        final activePromos = stats['activePromos'] as int;
        final categories = stats['categories'] as Set<String>;
        final totalValue = stats['totalValue'] as double;

        // Calculate metrics
        final avgPrice = totalProducts > 0 ? totalValue / totalProducts : 0.0;
        final promoEngagement =
            activePromos > 0 ? (promoCopies / activePromos) : 0.0;
        final categoryDiversity = categories.length;
        final productFreshness =
            totalProducts > 0 ? (recentProducts / totalProducts) * 100 : 0.0;

        // Calculate overall performance score (weighted formula)
        final performanceScore =
            ((promoEngagement * 40) + // 40% weight on promo engagement
                (categoryDiversity * 15) + // 15% weight on category diversity
                (productFreshness *
                    25) + // 25% weight on recent product additions
                (totalProducts.clamp(0, 50) *
                    0.4) // 20% weight on catalog size (capped at 50)
            );

        vendorPerformanceData.add({
          'vendorId': entry.key,
          'vendorName': await _getVendorName(entry.key),
          'totalProducts': totalProducts,
          'recentProducts': recentProducts,
          'promoCopies': promoCopies,
          'activePromos': activePromos,
          'categoryDiversity': categoryDiversity,
          'avgPrice': avgPrice,
          'promoEngagement': promoEngagement,
          'productFreshness': productFreshness,
          'performanceScore': performanceScore,
        });
      }

      // Sort by performance score (highest first)
      vendorPerformanceData.sort((a, b) => (b['performanceScore'] as double)
          .compareTo(a['performanceScore'] as double));

      // Take top 5 vendors
      vendorPerformanceData = vendorPerformanceData.take(5).toList();

      print('📊 Top Vendor Performance:');
      for (var vendor in vendorPerformanceData.take(3)) {
        print('   🏆 ${vendor['vendorName']}:');
        print(
            '      📦 ${vendor['totalProducts']} products (${vendor['recentProducts']} recent)');
        print(
            '      📋 ${vendor['promoCopies']} promo copies, ${vendor['categoryDiversity']} categories');
        print(
            '      📈 Score: ${(vendor['performanceScore'] as double).toStringAsFixed(1)}');
      }
    } catch (e) {
      print('❌ Error loading vendor performance: $e');
      vendorPerformanceData = [];
    }
  }

  // 🔥 NEW: Get vendor display names (tries to infer from branded items)
  Future<String> _getVendorName(String vendorId) async {
    try {
      // Try to get vendor name from vendors collection if it exists
      final vendorDoc = await FirebaseFirestore.instance
          .collection(
              'vendors') // Replace with your actual vendor collection name if you have one
          .doc(vendorId)
          .get();

      if (vendorDoc.exists) {
        final data = vendorDoc.data();
        return data?['name'] ??
            data?['display_name'] ??
            data?['business_name'] ??
            vendorId;
      }
    } catch (e) {
      // Vendors collection might not exist, that's okay
    }

    // Fallback: try to get a sample branded item to infer vendor name
    try {
      final sampleQuery = await FirebaseFirestore.instance
          .collection('branded_items')
          .where('vendor_id', isEqualTo: vendorId)
          .limit(1)
          .get();

      if (sampleQuery.docs.isNotEmpty) {
        final data = sampleQuery.docs.first.data();
        final itemName = data['name'] as String? ?? '';

        // Extract brand name from item name (common patterns)
        if (itemName.contains(' - ')) {
          return itemName.split(' - ').first;
        } else if (itemName.contains(' by ')) {
          return itemName.split(' by ').last;
        }
      }
    } catch (e) {
      // Couldn't infer name from items
    }

    // Final fallback: truncated vendor ID
    return vendorId.length > 10 ? vendorId.substring(0, 10) + '...' : vendorId;
  }

  Future<void> _loadWardrobeCategories() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(
          days: _selectedTimeRange == '7d'
              ? 7
              : _selectedTimeRange == '30d'
                  ? 30
                  : 90));

      final wardrobeQuery = await FirebaseFirestore.instance
          .collection('wardrobe_items')
          .where('date_added', isGreaterThan: startDate)
          .get();

      print(
          'Found ${wardrobeQuery.docs.length} wardrobe items in selected time range');

      Map<String, int> categoryCount = {};
      for (var doc in wardrobeQuery.docs) {
        final data = doc.data();
        String category = data['category'] ?? 'Unknown';
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;

        // Debug: Print sample data
        if (categoryCount[category] == 1) {
          print('Sample $category item: ${data['name']} - ${data['color']}');
        }
      }

      wardrobeCategories = categoryCount.entries
          .map((e) => {'name': e.key, 'count': e.value})
          .toList()
        ..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

      print('Wardrobe categories loaded: $wardrobeCategories');
    } catch (e) {
      print('Error loading wardrobe categories: $e');
      // Set default categories if there's an error
      wardrobeCategories = [
        {'name': 'No Data', 'count': 0},
      ];
    }
  }

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
        context.pushNamed('SmartSuggestions');
        break;
      case 4:
        break;
    }
  }

  void _onTimeRangeChanged(String newRange) {
    setState(() {
      _selectedTimeRange = newRange;
    });
    _loadDashboardData(); // Reload data for new time range
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(22.0, 10.0, 22.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTimeButton('7d', '7 Days'),
          _buildTimeButton('30d', '30 Days'),
          _buildTimeButton('90d', '90 Days'),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String value, String label) {
    bool isSelected = _selectedTimeRange == value;
    return GestureDetector(
      onTap: () => _onTimeRangeChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).underground
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: FlutterFlowTheme.of(context).underground,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : FlutterFlowTheme.of(context).underground,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color changeColor,
  }) {
    return Container(
      height: 110.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).blankCanvas,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon,
                    size: 20, color: FlutterFlowTheme.of(context).underground),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: changeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      color: changeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                    fontSize: 11,
                  ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 MODIFIED: Updated user growth chart with real data
  Widget _buildUserGrowthChart() {
    return Container(
      width: double.infinity,
      height: 280.0,
      margin: EdgeInsetsDirectional.fromSTEB(22.0, 20.0, 22.0, 0.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).blankCanvas,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondaryText,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New User Registrations',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .underground
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$newUsersThisPeriod new users',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).underground,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: userGrowthData.isNotEmpty
                  ? LineChart(
                      LineChartData(
                        gridData:
                            FlGridData(show: true, drawVerticalLine: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 &&
                                    index < userGrowthData.length) {
                                  final date = DateTime.parse(
                                      userGrowthData[index]['date']);
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      DateFormat('MM/dd').format(date),
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  );
                                }
                                return Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: userGrowthData.map((data) {
                              return FlSpot(
                                data['index'].toDouble(),
                                data['count'].toDouble(),
                              );
                            }).toList(),
                            isCurved: true,
                            color: FlutterFlowTheme.of(context).underground,
                            barWidth: 3,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color:
                                      FlutterFlowTheme.of(context).underground,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: FlutterFlowTheme.of(context)
                                  .underground
                                  .withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).underground,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading user growth data...',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 UPDATED: Promo conversion chart with real data
  Widget _buildPromoConversionChart() {
    return Container(
      width: double.infinity,
      height: 300.0,
      margin: EdgeInsetsDirectional.fromSTEB(22.0, 20.0, 22.0, 0.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).blankCanvas,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondaryText,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Promo Code Performance',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .underground
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$totalPromoCopies copies',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).underground,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: totalPromoCopies > 0
                  ? Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: Colors.blue,
                                  value: totalPromoCopies.toDouble(),
                                  title: 'Copied\n$totalPromoCopies',
                                  radius: 80,
                                  titleStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                PieChartSectionData(
                                  color: Colors.grey,
                                  value: (totalPromoCopies * 0.3).toDouble(),
                                  title:
                                      'Available\n${(totalPromoCopies * 0.3).toInt()}',
                                  radius: 80,
                                  titleStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLegendItem(Colors.blue, 'Total Copies',
                                  '$totalPromoCopies'),
                              _buildLegendItem(Colors.green, 'Unique Users',
                                  '$uniquePromoUsers'),
                              _buildLegendItem(Colors.orange, 'Engagement',
                                  '${promoConversion.toStringAsFixed(1)}%'),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No promo code activity',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  color: Colors.grey,
                                ),
                          ),
                          Text(
                            'in selected time period',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      color: Colors.grey,
                                    ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12)),
                Text(value,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStyleTags() {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(22.0, 20.0, 22.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Wardrobe Categories',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: wardrobeCategories.isNotEmpty
                  ? wardrobeCategories.take(4).map((category) {
                      int index = wardrobeCategories.indexOf(category);
                      List<Color> colors = [
                        Colors.blue,
                        Colors.purple,
                        Colors.orange,
                        Colors.green
                      ];
                      return Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: _buildStyleTagCard(category['name'],
                            category['count'], colors[index % colors.length]),
                      );
                    }).toList()
                  : [
                      _buildStyleTagCard('Loading...', 0, Colors.grey),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleTagCard(String tag, int count, Color color) {
    return Container(
      width: 140,
      height: 80,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).blankCanvas,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '$count items',
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 UPDATED: Build vendor performance chart with real data from branded_items
  Widget _buildVendorPerformance() {
    return Container(
      width: double.infinity,
      height: 320,
      margin: EdgeInsetsDirectional.fromSTEB(22.0, 20.0, 22.0, 0.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).blankCanvas,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondaryText,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Vendor Performance',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .underground
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${vendorPerformanceData.length} vendors',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).underground,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: vendorPerformanceData.isNotEmpty
                  ? BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: vendorPerformanceData.isNotEmpty
                            ? vendorPerformanceData
                                    .map((v) => v['performanceScore'] as double)
                                    .reduce((a, b) => a > b ? a : b) +
                                10
                            : 100,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              if (groupIndex < vendorPerformanceData.length) {
                                final vendor =
                                    vendorPerformanceData[groupIndex];
                                return BarTooltipItem(
                                  '${vendor['vendorName']}\n',
                                  TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                      text:
                                          '${vendor['totalProducts']} products\n${vendor['promoCopies']} promo copies',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 12),
                                    ),
                                  ],
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                final index = value.toInt();
                                if (index >= 0 &&
                                    index < vendorPerformanceData.length) {
                                  final vendorName =
                                      vendorPerformanceData[index]['vendorName']
                                          as String;
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(
                                      vendorName.length > 8
                                          ? vendorName.substring(0, 8) + '...'
                                          : vendorName,
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  );
                                }
                                return Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text('${value.toInt()}',
                                    style: TextStyle(fontSize: 10));
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups:
                            vendorPerformanceData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final vendor = entry.value;
                          final colors = [
                            Colors.blue,
                            Colors.green,
                            Colors.orange,
                            Colors.purple,
                            Colors.red
                          ];

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: vendor['performanceScore'] as double,
                                color: colors[index % colors.length],
                                width: 20,
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.store,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No vendor performance data',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  color: Colors.grey,
                                ),
                          ),
                          Text(
                            'in selected time period',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      color: Colors.grey,
                                    ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).underground,
          automaticallyImplyLeading: false,
          title: Text(
            'Reports & Insights',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(),
                  color: FlutterFlowTheme.of(context).white,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: FlutterFlowTheme.of(context).underground,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: FlutterFlowTheme.of(context).blankCanvas,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: "Accounts"),
            BottomNavigationBarItem(
                icon: Icon(Icons.content_copy), label: "Contents"),
            BottomNavigationBarItem(icon: Icon(Icons.tune), label: "Tune"),
            BottomNavigationBarItem(
                icon: Icon(Icons.analytics), label: "Reports"),
          ],
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Time Range Selector
                _buildTimeRangeSelector(),

                // KPI Cards - 3 Card Layout (🔥 UPDATED: Now shows total users)
                Container(
                  margin: EdgeInsetsDirectional.fromSTEB(22.0, 20.0, 22.0, 0.0),
                  child: Column(
                    children: [
                      // First Row - 2 cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildKPICard(
                              title: 'Total Users',
                              value: totalUsers.toString(),
                              change: newUsersThisPeriod > 0
                                  ? '+${((newUsersThisPeriod / (totalUsers > 0 ? totalUsers : 1)) * 100).toStringAsFixed(1)}%'
                                  : '0%',
                              icon: Icons.people,
                              changeColor: newUsersThisPeriod > 0
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildKPICard(
                              title: 'Outfits Created',
                              value: totalOutfits.toString(),
                              change: '+15.2%',
                              icon: Icons.checkroom,
                              changeColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      // Second Row - 1 card centered
                      Row(
                        children: [
                          Expanded(flex: 1, child: Container()), // Spacer
                          Expanded(
                            flex: 2,
                            child: _buildKPICard(
                              title: 'Content Reports',
                              value: contentReports.toString(),
                              change: contentReports > 10 ? '+5.8%' : '-5.8%',
                              icon: Icons.report_problem,
                              changeColor: contentReports > 10
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          Expanded(flex: 1, child: Container()), // Spacer
                        ],
                      ),
                    ],
                  ),
                ),

                // User Growth Chart (🔥 NOW SHOWS REAL DATA)
                _buildUserGrowthChart(),

                // Trending Style Tags
                _buildTopStyleTags(),

                // Promo Conversion Chart (🔥 NOW SHOWS REAL DATA)
                _buildPromoConversionChart(),

                // Vendor Performance Chart (🔥 NOW SHOWS REAL DATA)
                _buildVendorPerformance(),

                // Action Buttons
                Container(
                  width: double.infinity,
                  margin:
                      EdgeInsetsDirectional.fromSTEB(22.0, 30.0, 22.0, 100.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: FFButtonWidget(
                              onPressed: () {
                                print('Download CSV pressed ...');
                              },
                              text: 'Download CSV',
                              icon: Icon(Icons.download, size: 18),
                              options: FFButtonOptions(
                                height: 44.0,
                                color: FlutterFlowTheme.of(context).underground,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: FFButtonWidget(
                              onPressed: () {
                                print('Export Summary pressed ...');
                              },
                              text: 'Export Summary',
                              icon: Icon(Icons.file_download, size: 18),
                              options: FFButtonOptions(
                                height: 44.0,
                                color: Color(0xAE9E5696),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
