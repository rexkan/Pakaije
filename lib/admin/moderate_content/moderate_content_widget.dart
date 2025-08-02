import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'moderate_content_model.dart';
export 'moderate_content_model.dart';

// Data models for the collections
class ContentReport {
  final String reportId;
  final String itemId;
  final String reason;
  final String reporterId;
  final String status;
  final DateTime timestamp;

  ContentReport({
    required this.reportId,
    required this.itemId,
    required this.reason,
    required this.reporterId,
    required this.status,
    required this.timestamp,
  });

  factory ContentReport.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ContentReport(
      reportId: data['report_id'] ?? '',
      itemId: data['item_id'] ?? '',
      reason: data['reason'] ?? '',
      reporterId: data['reporter_id'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class BrandedItem {
  final String itemId;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final double price;
  final String productUrl;
  final List<String> styleTags;
  final String vendorId;

  BrandedItem({
    required this.itemId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.price,
    required this.productUrl,
    required this.styleTags,
    required this.vendorId,
  });

  factory BrandedItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BrandedItem(
      itemId: data['item_id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['image_url'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      productUrl: data['product_url'] ?? '',
      styleTags: List<String>.from(data['style_tags'] ?? []),
      vendorId: data['vendor_id'] ?? '',
    );
  }
}

class ReportedItemData {
  final ContentReport report;
  final BrandedItem? item;

  ReportedItemData({required this.report, this.item});
}

class ModerateContentWidget extends StatefulWidget {
  const ModerateContentWidget({super.key});

  static String routeName = 'ModerateContent';
  static String routePath = '/moderateContent';

  @override
  State<ModerateContentWidget> createState() => _ModerateContentWidgetState();
}

class _ModerateContentWidgetState extends State<ModerateContentWidget>
    with TickerProviderStateMixin {
  late ModerateContentModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2;

  final animationsMap = <String, AnimationInfo>{};

  // Backend data
  List<ReportedItemData> reportedItems = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModerateContentModel());

    animationsMap.addAll({
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 40.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 50.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    // Load reported content data
    _loadReportedContent();
  }

  // Load reported content from Firestore
  Future<void> _loadReportedContent() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      print('🔄 Loading reported content...');

      QuerySnapshot reportsSnapshot = await FirebaseFirestore.instance
          .collection('content_reports')
          .where('status', isEqualTo: 'pending')
          .orderBy('timestamp', descending: true)
          .get();

      print('📊 Found ${reportsSnapshot.docs.length} pending reports');

      List<ReportedItemData> tempReportedItems = [];

      for (DocumentSnapshot reportDoc in reportsSnapshot.docs) {
        try {
          ContentReport report = ContentReport.fromFirestore(reportDoc);
          print(
              '📋 Processing report: ${report.reportId} for item: ${report.itemId}');

          // FIXED: Query by item_id field instead of using document ID
          String itemId = report.itemId.trim();
          print('🔍 Looking for branded item with item_id: "$itemId"');

          // Query the collection by item_id field
          QuerySnapshot itemQuery = await FirebaseFirestore.instance
              .collection('branded_items')
              .where('item_id', isEqualTo: itemId)
              .get();

          BrandedItem? item;
          if (itemQuery.docs.isNotEmpty) {
            // Take the first matching document
            DocumentSnapshot itemDoc = itemQuery.docs.first;
            item = BrandedItem.fromFirestore(itemDoc);
            print('✅ Found item: ${item.name} with image: ${item.imageUrl}');
          } else {
            print('❌ Item not found for item_id: "$itemId"');

            // Debug: Let's see what item_ids actually exist
            QuerySnapshot allItems = await FirebaseFirestore.instance
                .collection('branded_items')
                .get();

            print('📦 Available items in branded_items:');
            for (var doc in allItems.docs) {
              var data = doc.data() as Map<String, dynamic>;
              String id = data['item_id'] ?? 'no_item_id';
              String name = data['name'] ?? 'no_name';
              print('  - item_id: "$id", name: "$name"');
            }
          }

          tempReportedItems.add(ReportedItemData(
            report: report,
            item: item,
          ));
        } catch (e) {
          print('❌ Error processing report: $e');
        }
      }

      setState(() {
        reportedItems = tempReportedItems;
        isLoading = false;
      });

      print('✅ Loaded ${reportedItems.length} reported items');
    } catch (e) {
      print('❌ Error loading reported content: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Handle report actions
  Future<void> _handleReportAction(String reportId, String action) async {
    try {
      print('🔄 Handling action: $action for report: $reportId');

      String newStatus;
      switch (action) {
        case 'delete':
          newStatus = 'approved';
          break;
        case 'decline':
          newStatus = 'rejected';
          break;
        default:
          print('❌ Unknown action: $action');
          return;
      }

      // Find the report document by report_id field
      QuerySnapshot reportQuery = await FirebaseFirestore.instance
          .collection('content_reports')
          .where('report_id', isEqualTo: reportId)
          .get();

      if (reportQuery.docs.isEmpty) {
        throw Exception('Report not found with ID: $reportId');
      }

      // Update the report status
      DocumentSnapshot reportDoc = reportQuery.docs.first;
      await reportDoc.reference.update({
        'status': newStatus,
        'updated_at': FieldValue.serverTimestamp(),
      });

      print('✅ Updated report status to: $newStatus');

      // If approved for deletion, mark the item as removed
      if (action == 'delete') {
        ReportedItemData? reportData = reportedItems.firstWhere(
          (data) => data.report.reportId == reportId,
          orElse: () => throw Exception('Report not found in local data'),
        );

        if (reportData.item != null) {
          // FIXED: Query by item_id field to find the item to update
          QuerySnapshot itemQuery = await FirebaseFirestore.instance
              .collection('branded_items')
              .where('item_id', isEqualTo: reportData.item!.itemId.trim())
              .get();

          if (itemQuery.docs.isNotEmpty) {
            await itemQuery.docs.first.reference.update({
              'status': 'removed_for_violation',
              'removed_at': FieldValue.serverTimestamp(),
            });
            print('✅ Marked item as removed: ${reportData.item!.itemId}');
          } else {
            print(
                '⚠️ Could not find item to mark as removed: ${reportData.item!.itemId}');
          }
        }
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            action == 'delete'
                ? 'Item approved for deletion'
                : 'Report declined',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Reload the content
      await _loadReportedContent();
    } catch (e) {
      print('❌ Error handling report action: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Navigation handler for bottom nav bar
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
        // Current page (ModerateContent) - no navigation needed
        break;
      case 3:
        context.pushNamed('SmartSuggestions');
        break;
      case 4:
        context.pushNamed('ReportsInsights');
        break;
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Build individual report item widget
  Widget _buildReportItem(ReportedItemData reportData) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).blankCanvas,
        boxShadow: [
          BoxShadow(
            blurRadius: 7.0,
            color: Color(0x32171717),
            offset: Offset(0.0, 3.0),
          )
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item image
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: reportData.item != null
                      ? Image.network(
                          reportData.item!.imageUrl,
                          width: 120.0,
                          height: 120.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120.0,
                              height: 120.0,
                              color: Colors.grey[300],
                              child: Icon(Icons.broken_image, size: 40),
                            );
                          },
                        )
                      : Container(
                          width: 120.0,
                          height: 120.0,
                          color: Colors.grey[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, size: 40),
                              Text('Item\nNot Found',
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                ),
                SizedBox(width: 16.0),

                // Item details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Report reason
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border:
                              Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Text(
                          'Reason: ${reportData.report.reason}',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                      // Item name
                      Text(
                        reportData.item?.name ?? 'Unknown Item',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontWeight: FontWeight.w600,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),

                      // Item details
                      if (reportData.item != null) ...[
                        Text(
                          'Category: ${reportData.item!.category}',
                          style: FlutterFlowTheme.of(context).labelSmall,
                        ),
                        Text(
                          'Price: \$${reportData.item!.price.toStringAsFixed(2)}',
                          style: FlutterFlowTheme.of(context).labelSmall,
                        ),
                        Text(
                          'Item ID: ${reportData.item!.itemId}',
                          style: FlutterFlowTheme.of(context).labelSmall,
                        ),
                      ],

                      SizedBox(height: 8),

                      // Report timestamp
                      Text(
                        'Reported: ${_formatDate(reportData.report.timestamp)}',
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FFButtonWidget(
                    onPressed: () => _handleReportAction(
                      reportData.report.reportId,
                      'delete',
                    ),
                    text: 'Delete Item',
                    options: FFButtonOptions(
                      height: 40.0,
                      color: Colors.red,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: FFButtonWidget(
                    onPressed: () => _handleReportAction(
                      reportData.report.reportId,
                      'decline',
                    ),
                    text: 'Decline Report',
                    options: FFButtonOptions(
                      height: 40.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                color: Colors.white,
                                fontSize: 14,
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
    );
  }

  // Format date helper
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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
            'Content Moderation Panel',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: _loadReportedContent,
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: Text(
                    'Moderation Requests',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontWeight: FontWeight.w600,
                        ),
                  ).animateOnPageLoad(
                      animationsMap['textOnPageLoadAnimation1']!),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 16.0),
                  child: Text(
                    isLoading
                        ? 'Loading pending reviews...'
                        : '${reportedItems.length} Pending Reviews',
                    style: FlutterFlowTheme.of(context).labelMedium,
                  ).animateOnPageLoad(
                      animationsMap['textOnPageLoadAnimation2']!),
                ),

                // Content
                Expanded(
                  child: isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              SizedBox(height: 16),
                              Text('Loading reported content...'),
                            ],
                          ),
                        )
                      : errorMessage != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline,
                                      size: 64, color: Colors.red),
                                  SizedBox(height: 16),
                                  Text('Error: $errorMessage'),
                                  SizedBox(height: 16),
                                  FFButtonWidget(
                                    onPressed: _loadReportedContent,
                                    text: 'Retry',
                                    options: FFButtonOptions(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : reportedItems.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle_outline,
                                          size: 64, color: Colors.green),
                                      SizedBox(height: 16),
                                      Text(
                                        'No pending reports',
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'All content has been reviewed',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: _loadReportedContent,
                                  child: ListView.builder(
                                    itemCount: reportedItems.length,
                                    itemBuilder: (context, index) {
                                      return _buildReportItem(
                                          reportedItems[index]);
                                    },
                                  ),
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
