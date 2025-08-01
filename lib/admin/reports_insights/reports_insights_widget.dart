import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/backend.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
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
  List<Map<String, dynamic>> userGrowthData = [];

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
        _loadPromoMetrics(),
        _loadWardrobeCategories(),
      ]);
      setState(() {}); // Refresh UI with loaded data
    } catch (e) {
      print('Error loading dashboard data: $e');
    }
  }

  // Method 1: Get from daily_reports collection (if you have this data)
  Future<void> _loadActiveSessionsData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    try {
      // Option 1: From daily_reports collection
      final dailyReportQuery = await FirebaseFirestore.instance
          .collection('daily_reports')
          .where('date', isGreaterThanOrEqualTo: today)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (dailyReportQuery.docs.isNotEmpty) {
        activeSessions =
            dailyReportQuery.docs.first.data()['active_sessions'] ?? 0;
      } else {
        // Option 2: Calculate from users with recent activity
        await _calculateActiveSessionsFromUsers();
      }
    } catch (e) {
      print('Error loading active sessions: $e');
      // Fallback to calculating from user activity
      await _calculateActiveSessionsFromUsers();
    }
  }

  // Method 2: Calculate active sessions based on recent user activity
  Future<void> _calculateActiveSessionsFromUsers() async {
    final now = DateTime.now();
    final last30Minutes = now.subtract(Duration(minutes: 30));

    try {
      // Count users who created outfits in last 30 minutes
      final recentOutfitsQuery = await FirebaseFirestore.instance
          .collection('outfits')
          .where('created_time', isGreaterThan: last30Minutes)
          .get();

      // Count users who planned outfits in last 30 minutes
      final recentPlansQuery = await FirebaseFirestore.instance
          .collection('outfit_plans')
          .where('created_time', isGreaterThan: last30Minutes)
          .get();

      // Get unique users from both activities
      Set<String> activeUserIds = {};
      for (var doc in recentOutfitsQuery.docs) {
        activeUserIds.add(doc.data()['user_id'] ?? '');
      }
      for (var doc in recentPlansQuery.docs) {
        activeUserIds.add(doc.data()['user_id'] ?? '');
      }

      activeSessions = activeUserIds.length;
    } catch (e) {
      print('Error calculating active sessions: $e');
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

  Future<void> _loadPromoMetrics() async {
    try {
      final activePromos = await FirebaseFirestore.instance
          .collection('promo_codes')
          .where('is_active', isEqualTo: true)
          .get();

      // Calculate conversion rate (this would need actual usage tracking)
      // For now, using mock calculation based on active promos
      promoConversion = activePromos.docs.length > 0 ? 24.8 : 0.0;
      print(
          'Active promos: ${activePromos.docs.length}, Conversion: $promoConversion%');
    } catch (e) {
      print('Error loading promo metrics: $e');
      promoConversion = 0.0;
    }
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
            Text(
              'User Growth Trend',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun'
                          ];
                          return Text(days[value.toInt() % days.length]);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 900),
                        FlSpot(1, 950),
                        FlSpot(2, 1000),
                        FlSpot(3, 1100),
                        FlSpot(4, 1150),
                        FlSpot(5, 1200),
                        FlSpot(6, 1250),
                      ],
                      isCurved: true,
                      color: FlutterFlowTheme.of(context).underground,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
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
            Text(
              'Promo Code Performance',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: 65,
                            title: 'Converted\n65%',
                            radius: 80,
                            titleStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.orange,
                            value: 25,
                            title: 'Pending\n25%',
                            radius: 80,
                            titleStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: 10,
                            title: 'Expired\n10%',
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
                        _buildLegendItem(Colors.green, 'Converted', '520'),
                        _buildLegendItem(Colors.orange, 'Pending', '200'),
                        _buildLegendItem(Colors.red, 'Expired', '80'),
                      ],
                    ),
                  ),
                ],
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
            Text(
              'Top Vendor Performance',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const vendors = [
                            'Nike',
                            'Adidas',
                            'Zara',
                            'H&M',
                            'Uniqlo'
                          ];
                          return Text(
                            vendors[value.toInt() % vendors.length],
                            style: TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text('${value.toInt()}%');
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: 85, color: Colors.blue)
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: 78, color: Colors.green)
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(toY: 72, color: Colors.orange)
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(toY: 65, color: Colors.purple)
                    ]),
                    BarChartGroupData(
                        x: 4,
                        barRods: [BarChartRodData(toY: 58, color: Colors.red)]),
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

                // KPI Cards - 3 Card Layout
                Container(
                  margin: EdgeInsetsDirectional.fromSTEB(22.0, 20.0, 22.0, 0.0),
                  child: Column(
                    children: [
                      // First Row - 2 cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildKPICard(
                              title: 'Active Sessions',
                              value: activeSessions.toString(),
                              change: '+8.2%',
                              icon: Icons.show_chart,
                              changeColor: Colors.green,
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

                // User Growth Chart
                _buildUserGrowthChart(),

                // Trending Style Tags
                _buildTopStyleTags(),

                // Promo Conversion Chart
                _buildPromoConversionChart(),

                // Vendor Performance Chart
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
