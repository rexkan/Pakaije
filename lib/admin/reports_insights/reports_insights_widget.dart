import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/backend.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
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

  // ==================== STATE VARIABLES ====================
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

  // User statistics
  int totalUsers = 0;
  int newUsersThisPeriod = 0;

  // Promo code statistics
  int totalPromoCopies = 0;
  int uniquePromoUsers = 0;
  List<MapEntry<String, int>> mostPopularPromos = [];

  // Vendor performance statistics
  List<Map<String, dynamic>> vendorPerformanceData = [];

  // ==================== INITIALIZATION ====================
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ReportsInsightsModel());
    _loadDashboardData();
  }

  // ==================== CSV EXPORT FUNCTIONALITY ====================
  // 🔥 SIMPLIFIED: Download CSV and show success message
  Future<void> _downloadCSV() async {
    try {
      print('📊 Starting CSV generation...');

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 16),
              Expanded(child: Text('📊 Generating CSV report...')),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Create CSV header
      String csvContent = 'Date,Category,Metric,Value\n';

      final now = DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd').format(now);

      // Add KPI data
      csvContent += '$dateStr,KPI,Total Users,$totalUsers\n';
      csvContent += '$dateStr,KPI,New Users This Period,$newUsersThisPeriod\n';
      csvContent += '$dateStr,KPI,Total Outfits,$totalOutfits\n';
      csvContent += '$dateStr,KPI,Content Reports,$contentReports\n';
      csvContent += '$dateStr,KPI,Active Sessions,$activeSessions\n';
      csvContent += '$dateStr,KPI,Total Promo Uses,$totalPromoCopies\n';
      csvContent += '$dateStr,KPI,Unique Promo Users,$uniquePromoUsers\n';
      csvContent +=
          '$dateStr,KPI,Promo Conversion Rate,${promoConversion.toStringAsFixed(2)}\n';

      // Add user growth data
      for (var data in userGrowthData) {
        csvContent +=
            '${data['date']},User Growth,Daily New Users,${data['count']}\n';
      }

      // Add vendor performance data
      for (var vendor in vendorPerformanceData) {
        final vendorName = vendor['vendorName'].toString().replaceAll(',', ' ');
        csvContent +=
            '$dateStr,Vendor Performance,$vendorName Products,${vendor['totalProducts']}\n';
        csvContent +=
            '$dateStr,Vendor Performance,$vendorName Promo Usage,${vendor['totalPromoUsage']}\n';
        csvContent +=
            '$dateStr,Vendor Performance,$vendorName Active Promos,${vendor['activePromos']}\n';
        csvContent +=
            '$dateStr,Vendor Performance,$vendorName Performance Score,${(vendor['performanceScore'] as double).toStringAsFixed(2)}\n';
      }

      // Add wardrobe categories
      for (var category in wardrobeCategories) {
        final categoryName = category['name'].toString().replaceAll(',', ' ');
        csvContent +=
            '$dateStr,Wardrobe Categories,$categoryName Items,${category['count']}\n';
      }

      // Add top promo codes
      for (var promo in mostPopularPromos.take(10)) {
        final promoCode = promo.key.replaceAll(',', ' ');
        csvContent += '$dateStr,Promo Codes,$promoCode Uses,${promo.value}\n';
      }

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'pakaije_analytics_${_selectedTimeRange}_$timestamp.csv';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(csvContent);

      print('✅ CSV saved: ${file.path}');
      print('📊 CSV contains ${csvContent.split('\n').length - 1} data rows');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✅ CSV Report Generated Successfully!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('📁 File: $fileName'),
              Text('📊 Data Points: ${_calculateDataPoints()}'),
              Text('💾 Saved to device storage'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Share',
            textColor: Colors.white,
            onPressed: () async {
              await Share.shareXFiles([XFile(file.path)]);
            },
          ),
        ),
      );
    } catch (e) {
      print('❌ Error generating CSV: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error generating CSV: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // ==================== SUMMARY EXPORT FUNCTIONALITY ====================
  // 🔥 SIMPLIFIED: Export Summary and show success message
  Future<void> _exportSummary() async {
    try {
      print('📋 Starting summary report generation...');

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 16),
              Expanded(child: Text('📋 Generating summary report...')),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Generate comprehensive summary report
      String summaryContent = _generateDetailedSummary();

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'pakaije_summary_${_selectedTimeRange}_$timestamp.txt';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(summaryContent);

      print('✅ Summary saved: ${file.path}');
      print('📋 Summary contains ${summaryContent.length} characters');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✅ Summary Report Generated Successfully!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('📄 File: $fileName'),
              Text('📊 Health Score: ${_calculateHealthScore()}'),
              Text('📈 User Growth: ${_calculateUserGrowthTrend()}'),
              Text('💾 Saved to device storage'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Share',
            textColor: Colors.white,
            onPressed: () async {
              await Share.shareXFiles([XFile(file.path)]);
            },
          ),
        ),
      );
    } catch (e) {
      print('❌ Error generating summary: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error generating summary: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // ==================== SUMMARY GENERATION HELPER ====================
  // 🔥 Generate detailed summary report
  String _generateDetailedSummary() {
    final now = DateTime.now();
    final reportDate =
        DateFormat('EEEE, MMMM d, yyyy \'at\' HH:mm').format(now);

    // Calculate additional insights
    final userGrowthTrend = _calculateUserGrowthTrend();
    final topVendor =
        vendorPerformanceData.isNotEmpty ? vendorPerformanceData.first : null;
    final topCategory =
        wardrobeCategories.isNotEmpty ? wardrobeCategories.first : null;
    final recommendations = _generateRecommendations();

    return '''
═══════════════════════════════════════════════════════════
                PAKAIJE ANALYTICS SUMMARY REPORT
═══════════════════════════════════════════════════════════

Generated: $reportDate
Analysis Period: $_selectedTimeRange
Data Source: Firebase Analytics Dashboard

═══════════════════════════════════════════════════════════
                        EXECUTIVE SUMMARY
═══════════════════════════════════════════════════════════

Platform Overview:
• Total Registered Users: ${totalUsers.toString().padLeft(8)} users
• New User Acquisitions: ${newUsersThisPeriod.toString().padLeft(8)} users (this period)
• Active Sessions: ${activeSessions.toString().padLeft(8)} concurrent
• Content Created: ${totalOutfits.toString().padLeft(8)} outfits
• Moderation Reports: ${contentReports.toString().padLeft(8)} reports

User Growth Trend: $userGrowthTrend

═══════════════════════════════════════════════════════════
                        USER ANALYTICS
═══════════════════════════════════════════════════════════

Registration Trends:
${_formatUserGrowthDetails()}

User Engagement:
• Average Session Activity: ${activeSessions > 0 ? (activeSessions / (totalUsers > 0 ? totalUsers : 1) * 100).toStringAsFixed(1) : '0.0'}%
• Content Creation Rate: ${totalUsers > 0 ? (totalOutfits / totalUsers).toStringAsFixed(1) : '0.0'} outfits per user
• Platform Health Score: ${_calculateHealthScore()}

═══════════════════════════════════════════════════════════
                      VENDOR ECOSYSTEM
═══════════════════════════════════════════════════════════

Vendor Performance Summary:
• Active Vendors: ${vendorPerformanceData.length} vendors
${topVendor != null ? '• Top Performing Vendor: ${topVendor['vendorName']} (Score: ${(topVendor['performanceScore'] as double).toStringAsFixed(1)})' : '• No vendor performance data available'}

Detailed Vendor Rankings:
${_formatVendorDetails()}

═══════════════════════════════════════════════════════════
                    PROMOTIONAL ANALYTICS
═══════════════════════════════════════════════════════════

Promo Code Performance:
• Total Promo Uses: ${totalPromoCopies.toString().padLeft(8)} uses
• Estimated Unique Users: ${uniquePromoUsers.toString().padLeft(8)} users
• Average Uses per Code: ${promoConversion.toStringAsFixed(1).padLeft(8)}
• Conversion Efficiency: ${totalPromoCopies > 0 ? ((uniquePromoUsers / totalPromoCopies) * 100).toStringAsFixed(1) : '0.0'}%

Top Performing Promo Codes:
${_formatPromoDetails()}

═══════════════════════════════════════════════════════════
                    CONTENT ANALYTICS
═══════════════════════════════════════════════════════════

Wardrobe Category Distribution:
${topCategory != null ? '• Most Popular Category: ${topCategory['name']} (${topCategory['count']} items)' : '• No category data available'}

Category Breakdown:
${_formatCategoryDetails()}

Content Moderation:
• Report Volume: ${contentReports} reports (${_getReportVolumeAssessment()})
• Platform Safety: ${contentReports < 5 ? 'GOOD' : contentReports < 15 ? 'MODERATE' : 'NEEDS ATTENTION'}

═══════════════════════════════════════════════════════════
                    STRATEGIC INSIGHTS
═══════════════════════════════════════════════════════════

Key Performance Indicators:
• User Acquisition: ${newUsersThisPeriod > 10 ? 'STRONG' : newUsersThisPeriod > 3 ? 'MODERATE' : 'NEEDS IMPROVEMENT'}
• Vendor Engagement: ${vendorPerformanceData.length > 5 ? 'HEALTHY' : vendorPerformanceData.length > 2 ? 'GROWING' : 'DEVELOPING'}
• Promo Effectiveness: ${totalPromoCopies > 50 ? 'HIGH' : totalPromoCopies > 10 ? 'MODERATE' : 'LOW'}
• Content Quality: ${contentReports < 5 ? 'EXCELLENT' : contentReports < 15 ? 'GOOD' : 'CONCERNING'}

═══════════════════════════════════════════════════════════
                      RECOMMENDATIONS
═══════════════════════════════════════════════════════════

$recommendations

═══════════════════════════════════════════════════════════
                        APPENDIX
═══════════════════════════════════════════════════════════

Technical Details:
• Report Generation Time: ${DateTime.now().millisecondsSinceEpoch}ms
• Data Points Analyzed: ${_calculateDataPoints()}
• Analysis Depth: Comprehensive Multi-Source
• Confidence Level: ${_calculateConfidenceLevel()}

For technical support or data inquiries, please contact the analytics team.

═══════════════════════════════════════════════════════════
                      END OF REPORT
═══════════════════════════════════════════════════════════
''';
  }

  // ==================== SUMMARY HELPER METHODS ====================
  // Helper methods for summary generation
  String _calculateUserGrowthTrend() {
    if (userGrowthData.length < 2) return 'Insufficient data';

    final recent = userGrowthData.length >= 3
        ? userGrowthData
            .sublist(userGrowthData.length - 3)
            .map((d) => d['count'] as int)
            .toList()
        : userGrowthData.map((d) => d['count'] as int).toList();
    final earlier = userGrowthData.length >= 3
        ? userGrowthData.sublist(0, 3).map((d) => d['count'] as int).toList()
        : userGrowthData.map((d) => d['count'] as int).toList();

    final recentAvg =
        recent.isNotEmpty ? recent.reduce((a, b) => a + b) / recent.length : 0;
    final earlierAvg = earlier.isNotEmpty
        ? earlier.reduce((a, b) => a + b) / earlier.length
        : 0;

    if (recentAvg > earlierAvg * 1.2) return 'INCREASING';
    if (recentAvg < earlierAvg * 0.8) return 'DECREASING';
    return 'STABLE';
  }

  String _formatUserGrowthDetails() {
    if (userGrowthData.isEmpty) return '• No user growth data available';

    return userGrowthData.map((data) {
      final date = DateTime.parse(data['date']);
      final count = data['count'] as int;
      final dayName = DateFormat('EEE').format(date);
      return '• $dayName ${DateFormat('MM/dd').format(date)}: ${count.toString().padLeft(3)} new users';
    }).join('\n');
  }

  String _formatVendorDetails() {
    if (vendorPerformanceData.isEmpty)
      return '• No vendor performance data available';

    return vendorPerformanceData.toList().asMap().entries.map((entry) {
      final index = entry.key + 1;
      final vendor = entry.value;
      return '${index.toString().padLeft(2)}. ${vendor['vendorName']} - ${vendor['totalProducts']} products, ${vendor['totalPromoUsage']} promo uses';
    }).join('\n');
  }

  String _formatPromoDetails() {
    if (mostPopularPromos.isEmpty)
      return '• No promo code usage data available';

    return mostPopularPromos.take(5).toList().asMap().entries.map((entry) {
      final index = entry.key + 1;
      final promo = entry.value;
      return '${index.toString().padLeft(2)}. ${promo.key}: ${promo.value.toString().padLeft(3)} uses';
    }).join('\n');
  }

  String _formatCategoryDetails() {
    if (wardrobeCategories.isEmpty) return '• No category data available';

    return wardrobeCategories.take(5).toList().asMap().entries.map((entry) {
      final index = entry.key + 1;
      final category = entry.value;
      return '${index.toString().padLeft(2)}. ${category['name']}: ${category['count'].toString().padLeft(3)} items';
    }).join('\n');
  }

  String _getReportVolumeAssessment() {
    if (contentReports == 0) return 'No reports - monitor engagement';
    if (contentReports < 5) return 'Low volume - healthy community';
    if (contentReports < 15) return 'Moderate volume - normal activity';
    return 'High volume - review moderation policies';
  }

  String _calculateHealthScore() {
    int score = 0;

    // User growth (30 points)
    if (newUsersThisPeriod > 10)
      score += 30;
    else if (newUsersThisPeriod > 3)
      score += 20;
    else if (newUsersThisPeriod > 0) score += 10;

    // Content creation (25 points)
    if (totalOutfits > 50)
      score += 25;
    else if (totalOutfits > 20)
      score += 20;
    else if (totalOutfits > 5) score += 10;

    // Vendor engagement (25 points)
    if (vendorPerformanceData.length > 5)
      score += 25;
    else if (vendorPerformanceData.length > 2)
      score += 15;
    else if (vendorPerformanceData.length > 0) score += 10;

    // Community health (20 points)
    if (contentReports < 5)
      score += 20;
    else if (contentReports < 15) score += 10;

    return '$score/100 ${score > 80 ? '(EXCELLENT)' : score > 60 ? '(GOOD)' : score > 40 ? '(FAIR)' : '(NEEDS IMPROVEMENT)'}';
  }

  String _generateRecommendations() {
    List<String> recommendations = [];

    // User acquisition recommendations
    if (newUsersThisPeriod == 0) {
      recommendations.add(
          '🎯 CRITICAL: Implement user acquisition campaigns - zero new users detected');
      recommendations.add('   • Launch social media marketing campaigns');
      recommendations.add('   • Consider referral programs or incentives');
      recommendations
          .add('   • Review onboarding flow for conversion barriers');
    } else if (newUsersThisPeriod < 5) {
      recommendations.add('📈 User Growth: Boost acquisition efforts');
      recommendations.add('   • Analyze successful acquisition channels');
      recommendations.add('   • Optimize app store presence and SEO');
    } else {
      recommendations
          .add('✅ User Growth: Maintaining healthy acquisition rate');
    }

    // Vendor ecosystem recommendations
    if (vendorPerformanceData.isEmpty) {
      recommendations
          .add('🏪 URGENT: Focus on vendor onboarding and activation');
      recommendations.add('   • Develop vendor recruitment strategy');
      recommendations.add('   • Create vendor success programs');
    } else if (vendorPerformanceData.length < 3) {
      recommendations.add('🏪 Vendor Ecosystem: Expand vendor base');
      recommendations.add('   • Target key fashion categories');
      recommendations.add('   • Improve vendor tools and analytics');
    }

    // Promo code recommendations
    if (totalPromoCopies == 0) {
      recommendations
          .add('🎫 Promo Strategy: Increase promo code visibility and usage');
      recommendations.add('   • Improve promo code placement in UI');
      recommendations.add('   • Create promo code discovery features');
      recommendations.add('   • Train vendors on effective promo strategies');
    } else if (promoConversion < 2) {
      recommendations.add('🎫 Promo Optimization: Improve conversion rates');
      recommendations.add('   • Simplify promo code redemption process');
      recommendations.add('   • Add promo code value propositions');
    }

    // Content moderation recommendations
    if (contentReports > 15) {
      recommendations
          .add('⚠️  Content Moderation: High report volume requires attention');
      recommendations.add('   • Review and update community guidelines');
      recommendations.add('   • Increase moderation team capacity');
      recommendations.add('   • Implement automated content filtering');
    } else if (contentReports == 0) {
      recommendations
          .add('👁️  Community Engagement: Monitor reporting system usage');
      recommendations.add('   • Ensure users know how to report issues');
      recommendations.add('   • Verify reporting system functionality');
    }

    // Content creation recommendations
    if (totalOutfits < 10) {
      recommendations
          .add('👗 Content Creation: Encourage more outfit creation');
      recommendations.add('   • Add outfit creation tutorials');
      recommendations.add('   • Implement outfit challenges or contests');
      recommendations.add('   • Improve outfit creation tools');
    }

    return recommendations.isNotEmpty
        ? recommendations.join('\n')
        : '✅ All metrics performing well - continue current strategies';
  }

  int _calculateDataPoints() {
    return userGrowthData.length +
        vendorPerformanceData.length +
        wardrobeCategories.length +
        mostPopularPromos.length +
        8; // KPI metrics
  }

  String _calculateConfidenceLevel() {
    final dataPoints = _calculateDataPoints();
    if (dataPoints > 50) return 'HIGH (>50 data points)';
    if (dataPoints > 20) return 'MEDIUM (20-50 data points)';
    return 'LOW (<20 data points)';
  }

  // ==================== DATA LOADING SECTION ====================
  // Load data from Firestore
  Future<void> _loadDashboardData() async {
    try {
      await Future.wait([
        _loadActiveSessionsData(),
        _loadOutfitMetrics(),
        _loadContentReports(),
        _loadPromoMetrics(),
        _loadWardrobeCategories(),
        _loadUserGrowthData(),
        _loadVendorPerformance(),
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

  // 🔥 UPDATED: Load promo metrics from discount_codes collection using usage_count
  Future<void> _loadPromoMetrics() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(
          days: _selectedTimeRange == '7d'
              ? 7
              : _selectedTimeRange == '30d'
                  ? 30
                  : 90));

      print('📊 Loading promo metrics for ${_selectedTimeRange}...');
      print(
          '📅 Date range: ${DateFormat('yyyy-MM-dd').format(startDate)} to ${DateFormat('yyyy-MM-dd').format(now)}');

      // Get all discount codes
      final allPromoCodesQuery =
          await FirebaseFirestore.instance.collection('discount_codes').get();

      // Get recently created promo codes (within time range)
      final recentPromoCodesQuery = await FirebaseFirestore.instance
          .collection('discount_codes')
          .where('created_at', isGreaterThan: startDate)
          .get();

      print('📋 Found ${allPromoCodesQuery.docs.length} total promo codes');
      print('📋 Found ${recentPromoCodesQuery.docs.length} recent promo codes');

      // Calculate comprehensive metrics
      int totalUsageCount = 0;
      int activePromoCount = 0;
      int recentUsageCount = 0;
      Set<String> vendorsWithActivity = <String>{};
      Map<String, int> promoCodeStats = <String, int>{};
      Map<String, Map<String, dynamic>> vendorStats =
          <String, Map<String, dynamic>>{};

      // Analyze all promo codes
      for (var doc in allPromoCodesQuery.docs) {
        final data = doc.data();
        final code = data['code'] as String? ?? '';
        final vendorId = data['vendor_id'] as String? ?? '';
        final usageCount = (data['usage_count'] as num?)?.toInt() ?? 0;
        final isActive = data['is_active'] as bool? ?? false;
        final createdAt = data['created_at'] as Timestamp?;

        // Count active promo codes
        if (isActive) {
          activePromoCount++;
        }

        // Track total usage
        totalUsageCount += usageCount;

        // Track recent usage (codes created in time range)
        if (createdAt != null && createdAt.toDate().isAfter(startDate)) {
          recentUsageCount += usageCount;
        }

        // Track vendor activity
        if (usageCount > 0 && vendorId.isNotEmpty) {
          vendorsWithActivity.add(vendorId);

          // Initialize vendor stats if not exists
          if (!vendorStats.containsKey(vendorId)) {
            vendorStats[vendorId] = {
              'totalCodes': 0,
              'totalUsage': 0,
              'activeCodes': 0,
              'bestPerformingCode': '',
              'bestPerformingUsage': 0,
            };
          }

          // Update vendor stats
          vendorStats[vendorId]!['totalCodes'] =
              (vendorStats[vendorId]!['totalCodes'] as int) + 1;
          vendorStats[vendorId]!['totalUsage'] =
              (vendorStats[vendorId]!['totalUsage'] as int) + usageCount;

          if (isActive) {
            vendorStats[vendorId]!['activeCodes'] =
                (vendorStats[vendorId]!['activeCodes'] as int) + 1;
          }

          // Track best performing code per vendor
          if (usageCount >
              (vendorStats[vendorId]!['bestPerformingUsage'] as int)) {
            vendorStats[vendorId]!['bestPerformingCode'] = code;
            vendorStats[vendorId]!['bestPerformingUsage'] = usageCount;
          }
        }

        // Track individual code performance
        if (usageCount > 0) {
          promoCodeStats[code] = usageCount;
        }
      }

      // Calculate engagement rate (average usage per active code)
      promoConversion = activePromoCount > 0
          ? (totalUsageCount / activePromoCount) *
              10 // Scale for better display
          : 0.0;

      // Estimate unique users (rough estimate: 80% of usage count, as some users might copy multiple times)
      final estimatedUniqueUsers = (totalUsageCount * 0.8).round();

      // Store metrics for UI
      totalPromoCopies = totalUsageCount;
      uniquePromoUsers = estimatedUniqueUsers;
      mostPopularPromos = promoCodeStats.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      print('📊 Promo Code Analytics Summary:');
      print('   📋 Total Usage Count: $totalUsageCount');
      print('   🎯 Active Promo Codes: $activePromoCount');
      print('   📈 Engagement Rate: ${promoConversion.toStringAsFixed(1)}');
      print('   🏪 Vendors with Activity: ${vendorsWithActivity.length}');
      print('   🏆 Top Performing Codes:');

      for (var entry in mostPopularPromos.take(5)) {
        print('      ${entry.key}: ${entry.value} uses');
      }

      print('   🏪 Top Performing Vendors:');
      final sortedVendors = vendorStats.entries.toList()
        ..sort((a, b) => (b.value['totalUsage'] as int)
            .compareTo(a.value['totalUsage'] as int));

      for (var entry in sortedVendors.take(3)) {
        final stats = entry.value;
        print(
            '      ${entry.key}: ${stats['totalUsage']} total uses, ${stats['activeCodes']} active codes');
      }

      // Additional insights
      if (totalUsageCount > 0) {
        final avgUsagePerCode = activePromoCount > 0
            ? (totalUsageCount / activePromoCount).toStringAsFixed(1)
            : '0';
        final vendorParticipationRate = vendorStats.isNotEmpty
            ? ((vendorsWithActivity.length / vendorStats.length) * 100)
                .toStringAsFixed(1)
            : '0';

        print('   📊 Additional Insights:');
        print('      Average uses per active code: $avgUsagePerCode');
        print('      Vendor participation rate: $vendorParticipationRate%');
        print(
            '      Recent activity (${_selectedTimeRange}): $recentUsageCount uses');
      }
    } catch (e) {
      print('❌ Error loading promo metrics: $e');

      // Set default values on error
      promoConversion = 0.0;
      totalPromoCopies = 0;
      uniquePromoUsers = 0;
      mostPopularPromos = [];
    }
  }

  // 🔥 UPDATED: Enhanced vendor performance method that uses discount_codes data
  Future<void> _loadVendorPerformance() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(
          days: _selectedTimeRange == '7d'
              ? 7
              : _selectedTimeRange == '30d'
                  ? 30
                  : 90));

      print('📊 Loading vendor performance for ${_selectedTimeRange}...');

      // Get all branded items by vendor
      final brandedItemsQuery =
          await FirebaseFirestore.instance.collection('branded_items').get();

      // Get all discount codes with usage data
      final discountCodesQuery =
          await FirebaseFirestore.instance.collection('discount_codes').get();

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
              'totalPromoUsage': 0,
              'activePromos': 0,
              'totalPromosCreated': 0,
              'avgPrice': 0.0,
              'totalValue': 0.0,
              'bestPerformingPromo': '',
              'bestPromoUsage': 0,
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

      // Add promo code performance data
      for (var doc in discountCodesQuery.docs) {
        final data = doc.data();
        final vendorId = data['vendor_id'] as String? ?? '';
        final usageCount = (data['usage_count'] as num?)?.toInt() ?? 0;
        final isActive = data['is_active'] as bool? ?? false;
        final code = data['code'] as String? ?? '';

        if (vendorId.isNotEmpty && vendorStats.containsKey(vendorId)) {
          // Count total promo codes created
          vendorStats[vendorId]!['totalPromosCreated']++;

          // Count active promo codes
          if (isActive) {
            vendorStats[vendorId]!['activePromos']++;
          }

          // Sum up promo usage
          vendorStats[vendorId]!['totalPromoUsage'] += usageCount;

          // Track best performing promo
          if (usageCount > (vendorStats[vendorId]!['bestPromoUsage'] as int)) {
            vendorStats[vendorId]!['bestPerformingPromo'] = code;
            vendorStats[vendorId]!['bestPromoUsage'] = usageCount;
          }
        }
      }

      // Calculate performance scores and convert to list
      vendorPerformanceData = [];
      for (var entry in vendorStats.entries) {
        final stats = entry.value;
        final totalProducts = stats['totalProducts'] as int;
        final recentProducts = stats['recentProducts'] as int;
        final totalPromoUsage = stats['totalPromoUsage'] as int;
        final activePromos = stats['activePromos'] as int;
        final totalPromosCreated = stats['totalPromosCreated'] as int;
        final categories = stats['categories'] as Set<String>;
        final totalValue = stats['totalValue'] as double;

        // Skip vendors with no activity
        if (totalProducts == 0 && totalPromosCreated == 0) continue;

        // Calculate metrics
        final avgPrice = totalProducts > 0 ? totalValue / totalProducts : 0.0;
        final promoEngagement =
            activePromos > 0 ? (totalPromoUsage / activePromos) : 0.0;
        final categoryDiversity = categories.length;
        final productFreshness =
            totalProducts > 0 ? (recentProducts / totalProducts) * 100 : 0.0;
        final promoSuccessRate = totalPromosCreated > 0
            ? (activePromos / totalPromosCreated) * 100
            : 0.0;

        // Calculate overall performance score (weighted formula)
        final performanceScore = ((promoEngagement *
                    30) + // 30% weight on promo engagement (usage per active promo)
                (totalPromoUsage * 0.5) + // Direct weight on total usage
                (categoryDiversity * 15) + // 15% weight on category diversity
                (productFreshness *
                    20) + // 20% weight on recent product additions
                (promoSuccessRate * 15) + // 15% weight on promo success rate
                (totalProducts.clamp(0, 50) *
                    0.4) // 20% weight on catalog size (capped at 50)
            );

        vendorPerformanceData.add({
          'vendorId': entry.key,
          'vendorName': await _getVendorName(entry.key),
          'totalProducts': totalProducts,
          'recentProducts': recentProducts,
          'totalPromoUsage': totalPromoUsage,
          'activePromos': activePromos,
          'totalPromosCreated': totalPromosCreated,
          'categoryDiversity': categoryDiversity,
          'avgPrice': avgPrice,
          'promoEngagement': promoEngagement,
          'productFreshness': productFreshness,
          'promoSuccessRate': promoSuccessRate,
          'performanceScore': performanceScore,
          'bestPerformingPromo': stats['bestPerformingPromo'],
          'bestPromoUsage': stats['bestPromoUsage'],
        });
      }

      // Sort by performance score (highest first)
      vendorPerformanceData.sort((a, b) => (b['performanceScore'] as double)
          .compareTo(a['performanceScore'] as double));

      // Take top 5 vendors
      vendorPerformanceData = vendorPerformanceData.take(5).toList();

      print('📊 Top Vendor Performance (Updated with Promo Usage):');
      for (var vendor in vendorPerformanceData.take(3)) {
        print('   🏆 ${vendor['vendorName']}:');
        print(
            '      📦 ${vendor['totalProducts']} products (${vendor['recentProducts']} recent)');
        print(
            '      📋 ${vendor['totalPromoUsage']} total promo uses, ${vendor['activePromos']} active promos');
        print(
            '      🎯 Best promo: ${vendor['bestPerformingPromo']} (${vendor['bestPromoUsage']} uses)');
        print(
            '      📈 Score: ${(vendor['performanceScore'] as double).toStringAsFixed(1)}');
      }
    } catch (e) {
      print('❌ Error loading vendor performance: $e');
      vendorPerformanceData = [];
    }
  }

  // 🔥 FIXED: Get vendor display names from users collection
  Future<String> _getVendorName(String vendorId) async {
    try {
      // Query the users collection where uid matches vendorId and role is Vendor
      final vendorQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: vendorId)
          .where('role', isEqualTo: 'Vendor')
          .limit(1)
          .get();

      if (vendorQuery.docs.isNotEmpty) {
        final userData = vendorQuery.docs.first.data();
        final displayName = userData['display_name'] as String? ?? '';

        if (displayName.isNotEmpty) {
          print('✅ Found vendor name: $displayName for ID: $vendorId');
          return displayName;
        }
      }

      // Alternative approach: Query by document ID if uid is the document ID
      try {
        final vendorDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(vendorId)
            .get();

        if (vendorDoc.exists) {
          final userData = vendorDoc.data();
          final role = userData?['role'] as String? ?? '';

          if (role == 'Vendor') {
            final displayName = userData?['display_name'] as String? ?? '';
            if (displayName.isNotEmpty) {
              print(
                  '✅ Found vendor name (by doc ID): $displayName for ID: $vendorId');
              return displayName;
            }
          }
        }
      } catch (e) {
        print('⚠️ Could not query vendor by doc ID: $e');
      }

      print('⚠️ No vendor found with ID: $vendorId');
    } catch (e) {
      print('❌ Error getting vendor name for ID $vendorId: $e');
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
          final inferredName = itemName.split(' - ').first;
          print('📝 Inferred vendor name from item: $inferredName');
          return inferredName;
        } else if (itemName.contains(' by ')) {
          final inferredName = itemName.split(' by ').last;
          print('📝 Inferred vendor name from item: $inferredName');
          return inferredName;
        }
      }
    } catch (e) {
      print('❌ Error inferring vendor name from items: $e');
    }

    // Final fallback: truncated vendor ID
    final fallbackName =
        vendorId.length > 12 ? vendorId.substring(0, 12) + '...' : vendorId;
    print('📝 Using fallback name: $fallbackName');
    return fallbackName;
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

  // ==================== NAVIGATION FUNCTIONS ====================
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

  // ==================== DISPOSE ====================
  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ==================== UI WIDGET BUILDERS ====================

  // ===== TIME RANGE SELECTOR WIDGET =====
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

  // ===== KPI CARDS WIDGET =====
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

  // ===== USER GROWTH CHART WIDGET =====
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

  // ===== PROMO CONVERSION CHART WIDGET =====
  Widget _buildPromoConversionChart() {
    return Container(
      width: double.infinity,
      height: 320.0,
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
                  'Promo Code Analytics',
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
                    '$totalPromoCopies total uses',
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
                                  title: 'Used\n$totalPromoCopies',
                                  radius: 80,
                                  titleStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                PieChartSectionData(
                                  color: Colors.green,
                                  value: uniquePromoUsers.toDouble(),
                                  title: 'Users\n$uniquePromoUsers',
                                  radius: 80,
                                  titleStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                PieChartSectionData(
                                  color: Colors.orange,
                                  value: promoConversion,
                                  title:
                                      'Engagement\n${promoConversion.toStringAsFixed(1)}',
                                  radius: 80,
                                  titleStyle: TextStyle(
                                      fontSize: 11,
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
                              _buildLegendItem(Colors.blue, 'Total Uses',
                                  '$totalPromoCopies'),
                              _buildLegendItem(Colors.green, 'Est. Users',
                                  '$uniquePromoUsers'),
                              _buildLegendItem(Colors.orange, 'Avg Uses/Code',
                                  '${promoConversion.toStringAsFixed(1)}'),
                              if (mostPopularPromos.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Top Promo:',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                      Text('${mostPopularPromos.first.key}',
                                          style: TextStyle(fontSize: 10)),
                                      Text(
                                          '${mostPopularPromos.first.value} uses',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
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
                            'No promo code usage data',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  color: Colors.grey,
                                ),
                          ),
                          Text(
                            'Promo codes not being used yet',
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

  // ===== WARDROBE CATEGORIES WIDGET =====
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

  // ===== VENDOR PERFORMANCE CHART WIDGET =====
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
                                          '${vendor['totalProducts']} products\n${vendor['totalPromoUsage']} promo uses',
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

  // ==================== MAIN BUILD METHOD ====================
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

        // ===== APP BAR SECTION =====
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

        // ===== BOTTOM NAVIGATION BAR SECTION =====
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

        // ===== MAIN BODY SECTION =====
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ===== SECTION 1: TIME RANGE SELECTOR =====
                _buildTimeRangeSelector(),
                SizedBox(height: 10), // Spacer between sections

                // ===== SECTION 2: KPI CARDS - 3 Card Layout =====
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
                SizedBox(height: 20), // Spacer between sections

                // ===== SECTION 3: USER GROWTH CHART =====
                _buildUserGrowthChart(),
                SizedBox(height: 20), // Spacer between sections

                // ===== SECTION 4: WARDROBE CATEGORIES (TRENDING STYLE TAGS) =====
                _buildTopStyleTags(),
                SizedBox(height: 20), // Spacer between sections

                // ===== SECTION 5: PROMO CONVERSION CHART =====
                _buildPromoConversionChart(),
                SizedBox(height: 20), // Spacer between sections

                // ===== SECTION 6: VENDOR PERFORMANCE CHART =====
                _buildVendorPerformance(),
                SizedBox(height: 30), // Extra spacer before action buttons

                // ===== SECTION 7: ACTION BUTTONS (CSV & SUMMARY EXPORT) =====
                Container(
                  width: double.infinity,
                  margin:
                      EdgeInsetsDirectional.fromSTEB(22.0, 0.0, 22.0, 100.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: FFButtonWidget(
                              onPressed:
                                  _downloadCSV, // 🔥 Generates CSV locally
                              text: 'Generate CSV Report',
                              icon: Icon(Icons.file_download, size: 18),
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
                              onPressed:
                                  _exportSummary, // 🔥 Generates summary locally
                              text: 'Generate Summary',
                              icon: Icon(Icons.assessment, size: 18),
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
