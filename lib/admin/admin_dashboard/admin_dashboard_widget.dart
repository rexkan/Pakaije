import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_dashboard_model.dart';
export 'admin_dashboard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardWidget extends StatefulWidget {
  const AdminDashboardWidget({super.key});

  static String routeName = 'AdminDashboard';
  static String routePath = '/adminDashboard';

  @override
  State<AdminDashboardWidget> createState() => _AdminDashboardWidgetState();
}

class _AdminDashboardWidgetState extends State<AdminDashboardWidget>
    with TickerProviderStateMixin {
  late AdminDashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminDashboardModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ============================================================================
  // NAVIGATION STATE MANAGEMENT SECTION
  // ============================================================================
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.pushNamed(AdminDashboardWidget.routeName);
        break;
      case 1:
        context.pushNamed(AccountManagementWidget.routeName);
        break;
      case 2:
        context.pushNamed(ModerateContentWidget.routeName);
        break;
      case 3:
        context.pushNamed(SmartSuggestionsWidget.routeName);
        break;
      case 4:
        context.pushNamed(ReportsInsightsWidget.routeName);
        break;
    }
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

        // ====================================================================
        // APP BAR SECTION - Contains title and action buttons
        // ====================================================================
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).underground,
          automaticallyImplyLeading: false,

          // App Bar Title Widget
          title: Text(
            FFLocalizations.of(context).getText(
              '3qdzok6f' /* Admin Dashboard */,
            ),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).white,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),

          // App Bar Action Buttons Section
          actions: [
            // Profile Button Widget
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: FlutterFlowTheme.of(context).blankCanvas,
                  size: 30.0,
                ),
                onPressed: () {
                  print('Profile pressed ...');
                },
              ),
            ),

            // Logout Button Widget with Confirmation Dialog
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.logout,
                  color: FlutterFlowTheme.of(context).blankCanvas,
                  size: 26.0,
                ),
                onPressed: () async {
                  // Show confirmation dialog
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
                    context.pushReplacementNamed('LoginPage');
                    print('User logged out');
                  }
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),

        // ====================================================================
        // BOTTOM NAVIGATION BAR SECTION - 5 navigation items
        // ====================================================================
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              FlutterFlowTheme.of(context).underground, // nav bar bg
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor:
              FlutterFlowTheme.of(context).blankCanvas, // selected icon & text
          unselectedItemColor: Colors.grey, // unselected icons & text
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

        // ====================================================================
        // MAIN BODY SECTION - Contains all dashboard content
        // ====================================================================
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ============================================================
                // STATISTICS CARDS SECTION - Active Users & Active Vendors
                // ============================================================
                Container(
                  width: double.infinity,
                  height: 148.88,
                  constraints: BoxConstraints(
                    maxHeight: 140.0,
                  ),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Color(0x33000000),
                        offset: Offset(0.0, 1.0),
                      )
                    ],
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 4.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly, // Center the cards
                              children: [
                                // ----------------------------------------
                                // ACTIVE USERS CARD WIDGET
                                // ----------------------------------------
                                Container(
                                  width: 160, // Fixed width for both cards
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .blankCanvas,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x33000000),
                                        offset: Offset(0.0, 2.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: Color(0xFFE0E3E7),
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Active Users Count - Firebase Stream
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role', isEqualTo: 'User')
                                              .where('account_status',
                                                  isEqualTo: 'active')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Text(
                                                '0',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .displaySmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .displaySmall
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                        ),
                                              );
                                            }
                                            final userCount =
                                                snapshot.data!.docs.length;
                                            return Text(
                                              userCount.toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .displaySmall
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displaySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displaySmall
                                                              .fontStyle,
                                                    ),
                                                    letterSpacing: 0.0,
                                                  ),
                                            );
                                          },
                                        ),

                                        // Active Users Label
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 4.0, 0.0, 0.0),
                                          child: Text(
                                            FFLocalizations.of(context).getText(
                                              '2deva6hz' /* Active Users */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // ----------------------------------------
                                // ACTIVE VENDORS CARD WIDGET
                                // ----------------------------------------
                                Container(
                                  width: 160, // Same fixed width
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .blankCanvas,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x33000000),
                                        offset: Offset(0.0, 2.0),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: Color(0xFFE0E3E7),
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Active Vendors Count - Firebase Stream
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role',
                                                  isEqualTo: 'Vendor')
                                              .where('account_status',
                                                  isEqualTo: 'active')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Text(
                                                '0',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .displaySmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .displaySmall
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          letterSpacing: 0.0,
                                                        ),
                                              );
                                            }
                                            final vendorCount =
                                                snapshot.data!.docs.length;
                                            return Text(
                                              vendorCount.toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .displaySmall
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displaySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displaySmall
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                  ),
                                            );
                                          },
                                        ),

                                        // Active Vendors Label
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 4.0, 0.0, 0.0),
                                          child: Text(
                                            FFLocalizations.of(context).getText(
                                              'zwczaws4' /* Active Vendors */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
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
                        ),
                      ],
                    ),
                  ),
                ),

                // Add spacing between sections
                SizedBox(height: 16.0),

                // ============================================================
                // URGENT TASKS SECTION - Pending Approvals Management
                // ============================================================
                Container(
                  width: 422.5,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ----------------------------------------
                      // URGENT TASKS TITLE WIDGET
                      // ----------------------------------------
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 12.0, 0.0, 0.0),
                        child: Text(
                          'Urgent Tasks',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 12.0),

                      // ----------------------------------------
                      // URGENT TASKS LIST WIDGET - Pending Approvals
                      // ----------------------------------------
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('account_status', isEqualTo: 'pending')
                            .where('role',
                                whereIn: ['Vendor', 'Admin']).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final tasks = snapshot.data!.docs;

                          // Empty State Widget
                          if (tasks.isEmpty) {
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 8.0, 0.0, 12.0),
                              child: Text(
                                'No pending approvals right now.',
                                style: FlutterFlowTheme.of(context).labelMedium,
                              ),
                            );
                          }

                          // Pending Tasks List
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              final data = task.data() as Map<String, dynamic>;
                              final userName =
                                  data['display_name'] ?? 'Unknown User';
                              final userRole = data['role'] ?? 'Unknown';

                              // Individual Task Card Widget
                              return Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 8.0, 16.0, 8.0),
                                child: Card(
                                  color:
                                      FlutterFlowTheme.of(context).blankCanvas,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    // Task Icon
                                    leading: Icon(
                                        userRole == 'Vendor'
                                            ? Icons.store
                                            : Icons.admin_panel_settings,
                                        color: Colors.orange,
                                        size: 28),

                                    // Task Title
                                    title: Text(
                                      'Pending $userRole Approval',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge,
                                    ),

                                    // Task Subtitle
                                    subtitle: Text('$userRole: $userName'),

                                    // Action Buttons Row
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Approve Button Widget
                                        IconButton(
                                          icon: Icon(Icons.check_circle,
                                              color: Colors.green, size: 30),
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(task.id)
                                                .update({
                                              'account_status': 'active'
                                            });

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      '$userRole approved successfully!')),
                                            );
                                          },
                                        ),

                                        // Suspend Button Widget with Confirmation
                                        IconButton(
                                          icon: Icon(Icons.block,
                                              color: Colors.red, size: 30),
                                          onPressed: () async {
                                            // Show confirmation dialog before suspending
                                            final shouldSuspend =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      Text('Suspend Account'),
                                                  content: Text(
                                                      'Are you sure you want to suspend this $userRole account?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      child: Text('Suspend',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (shouldSuspend == true) {
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(task.id)
                                                  .update({
                                                'account_status': 'suspended'
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        '$userRole account suspended.')),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Add spacing between sections
                SizedBox(height: 16.0),

                // ============================================================
                // RECENT ACTIVITY SECTION - Latest User Registrations
                // ============================================================
                Container(
                  width: 422.5,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ----------------------------------------
                      // RECENT ACTIVITY TITLE WIDGET
                      // ----------------------------------------
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 12.0, 0.0, 0.0),
                        child: Text(
                          'Recent Activity',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // ----------------------------------------
                      // RECENT ACTIVITY LIST WIDGET - Latest 10 Users
                      // ----------------------------------------
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .orderBy('created_time', descending: true)
                            .limit(10)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final docs = snapshot.data!.docs;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data =
                                  docs[index].data() as Map<String, dynamic>;
                              final createdTime =
                                  (data['created_time'] as Timestamp).toDate();
                              final role = data['role'] ?? 'Unknown';
                              final name =
                                  data['display_name'] ?? 'Unnamed User';
                              final accountStatus =
                                  data['account_status'] ?? 'unknown';

                              // Individual Activity Item Widget
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      FlutterFlowTheme.of(context).blankCanvas,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    width: 0.5,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      color: Color(0x33000000),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: ListTile(
                                  // Activity Icon
                                  leading: Icon(
                                      role == 'Vendor'
                                          ? Icons.store
                                          : role == 'Admin'
                                              ? Icons.admin_panel_settings
                                              : Icons.person,
                                      color: FlutterFlowTheme.of(context)
                                          .northAtlantic),

                                  // Activity Title
                                  title: Text(
                                    "New $role signed up: $name",
                                    style:
                                        FlutterFlowTheme.of(context).titleSmall,
                                  ),

                                  // Activity Details
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Time Difference Widget
                                      Text(
                                        timeDifference(createdTime),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),

                                      // Account Status Widget
                                      Text(
                                        'Status: ${accountStatus.toUpperCase()}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: accountStatus == 'active'
                                              ? Colors.green
                                              : accountStatus == 'pending'
                                                  ? Colors.orange
                                                  : Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      // ----------------------------------------
                      // BOTTOM SPACING WIDGET - Space from bottom nav bar
                      // ----------------------------------------
                      SizedBox(height: 20),
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

// ============================================================================
// UTILITY FUNCTIONS SECTION
// ============================================================================

// Time Difference Calculator Function - Converts DateTime to readable format
String timeDifference(DateTime time) {
  final difference = DateTime.now().difference(time);
  if (difference.inMinutes < 1) return "just now";
  if (difference.inMinutes < 60) return "${difference.inMinutes} minutes ago";
  if (difference.inHours < 24) return "${difference.inHours} hours ago";
  return "${difference.inDays} days ago";
}
