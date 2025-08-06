import 'package:cloud_firestore/cloud_firestore.dart';

import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_management_model.dart';
export 'account_management_model.dart';

class AccountManagementWidget extends StatefulWidget {
  const AccountManagementWidget({super.key});

  static String routeName = 'AccountManagement';
  static String routePath = '/accountManagement';

  @override
  State<AccountManagementWidget> createState() =>
      _AccountManagementWidgetState();
}

// ============================================================================
// GLOBAL SEARCH VARIABLES SECTION
// ============================================================================
String _searchQuery = '';
String _adminSearchQuery = ''; // Add admin search query
String _vendorSearchQuery = ''; // Add vendor search query

class _AccountManagementWidgetState extends State<AccountManagementWidget>
    with TickerProviderStateMixin {
  late AccountManagementModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1; // Set to 1 for Accounts tab

  // ============================================================================
  // INITIALIZATION SECTION
  // ============================================================================
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountManagementModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.searchBarTextController1 ??= TextEditingController();
    _model.searchBarFocusNode1 ??= FocusNode();

    _model.searchBarTextController2 ??= TextEditingController();
    _model.searchBarFocusNode2 ??= FocusNode();

    _model.searchBarTextController3 ??= TextEditingController();
    _model.searchBarFocusNode3 ??= FocusNode();
  }

  // ============================================================================
  // NAVIGATION HANDLER SECTION
  // ============================================================================
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.pushNamed('AdminDashboard');
        break;
      case 1:
        // Stay on current page (Account Management)
        break;
      case 2:
        context.pushNamed('ModerateContent');
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

        // ====================================================================
        // APP BAR SECTION - Contains page title
        // ====================================================================
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).underground,
          automaticallyImplyLeading: false,

          // App Bar Title Widget
          title: Text(
            FFLocalizations.of(context).getText(
              'uh4cjov9' /* Account Management */,
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
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),

        // ====================================================================
        // BOTTOM NAVIGATION BAR SECTION - 5 navigation items
        // ====================================================================
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

        // ====================================================================
        // MAIN BODY SECTION - Contains tabbed interface
        // ====================================================================
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                  child: Column(
                    children: [
                      // ============================================================
                      // TAB BAR SECTION - User, Admin, Vendor tabs
                      // ============================================================
                      Align(
                        alignment: Alignment(0.0, 0),
                        child: FlutterFlowButtonTabBar(
                          useToggleButtonStyle: true,
                          labelStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                          unselectedLabelStyle: TextStyle(),
                          labelColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).alternate,
                          backgroundColor:
                              FlutterFlowTheme.of(context).tastyCrust,
                          unselectedBackgroundColor: Color(0x88A57D4A),
                          borderColor: FlutterFlowTheme.of(context).alternate,
                          borderWidth: 2.0,
                          borderRadius: 12.0,
                          elevation: 0.0,
                          labelPadding: EdgeInsetsDirectional.fromSTEB(
                              18.0, 0.0, 18.0, 0.0),
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          tabs: [
                            Tab(
                              text: FFLocalizations.of(context).getText(
                                'lje39ygt' /* User */,
                              ),
                            ),
                            Tab(
                              text: FFLocalizations.of(context).getText(
                                '4yvq011t' /* Admin */,
                              ),
                            ),
                            Tab(
                              text: FFLocalizations.of(context).getText(
                                '559ql3s2' /* Vendor */,
                              ),
                            ),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) async {
                            [() async {}, () async {}, () async {}][i]();
                          },
                        ),
                      ),

                      // Add spacing between tab bar and content
                      SizedBox(height: 16.0),

                      // ============================================================
                      // TAB BAR VIEW SECTION - Content for each tab
                      // ============================================================
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          children: [
                            // ========================================================
                            // USER TAB CONTENT SECTION
                            // ========================================================
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        35.0), // global left/right padding
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ----------------------------------------
                                    // USER TAB TITLE WIDGET
                                    // ----------------------------------------
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0, bottom: 16.0, left: 8),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          'ykuz0p52' /* Accounts */,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              font: GoogleFonts.inter(
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
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),

                                    // ----------------------------------------
                                    // USER SEARCH BAR WIDGET
                                    // ----------------------------------------
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .blankCanvas,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      child: TextFormField(
                                        controller:
                                            _model.searchBarTextController1,
                                        focusNode: _model.searchBarFocusNode1,
                                        decoration: InputDecoration(
                                          hintText: 'Search user here',
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
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
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .underground,
                                                letterSpacing: 0.0,
                                              ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 14.0,
                                          ),
                                          suffixIcon: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Search Button Widget
                                              IconButton(
                                                icon: Icon(Icons.search,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .tastyCrust),
                                                onPressed: () {
                                                  setState(() {
                                                    _searchQuery = _model
                                                        .searchBarTextController1
                                                        .text
                                                        .trim();
                                                  });
                                                },
                                              ),
                                              // Clear Button Widget
                                              if (_searchQuery.isNotEmpty)
                                                IconButton(
                                                  icon: Icon(Icons.clear,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tastyCrust),
                                                  onPressed: () {
                                                    setState(() {
                                                      _model
                                                          .searchBarTextController1
                                                          ?.clear();
                                                      _searchQuery =
                                                          ''; // reset search
                                                    });
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                    ),

                                    SizedBox(height: 12.0),

                                    // ----------------------------------------
                                    // USER LIST WIDGET - Active Users Display
                                    // ----------------------------------------
                                    StreamBuilder<QuerySnapshot>(
                                      stream: (_searchQuery.isEmpty)
                                          ? FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role', isEqualTo: 'User')
                                              .where('account_status',
                                                  isEqualTo: 'active')
                                              .orderBy('display_name')
                                              .snapshots()
                                          : FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role', isEqualTo: 'User')
                                              .where('account_status',
                                                  isEqualTo: 'active')
                                              .where('display_name',
                                                  isGreaterThanOrEqualTo:
                                                      _searchQuery,
                                                  isLessThanOrEqualTo:
                                                      '$_searchQuery\uf8ff')
                                              .orderBy('display_name')
                                              .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .tastyCrust,
                                            ),
                                          );
                                        }

                                        final users = snapshot.data!.docs;
                                        if (users.isEmpty) {
                                          return Center(
                                            child: Text(
                                              'No users found',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                            ),
                                          );
                                        }

                                        return ListView.builder(
                                          padding: EdgeInsets.only(top: 12.0),
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: users.length,
                                          itemBuilder: (context, index) {
                                            final userData = users[index].data()
                                                as Map<String, dynamic>;
                                            final userId = users[index].id;
                                            final userName =
                                                userData['display_name'] ??
                                                    'Unnamed';
                                            final userRole =
                                                userData['role'] ?? 'Unknown';
                                            final joinedDate =
                                                (userData['created_time']
                                                            as Timestamp?)
                                                        ?.toDate()
                                                        .toString()
                                                        .split(' ')[0] ??
                                                    'N/A';

                                            // Individual User Card Widget
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
                                              child: Container(
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .blankCanvas,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 3.0,
                                                      color: Color(0x33000000),
                                                      offset: Offset(0.0, 1.0),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // User Info Section
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              userName,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                                height: 4.0),
                                                            Text(
                                                              '$userRole • Joined $joinedDate',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelSmall,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // User Suspend Button Widget
                                                      InkWell(
                                                        onTap: () async {
                                                          final confirm =
                                                              await showDialog<
                                                                  bool>(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: Text(
                                                                  'Confirm Suspend'),
                                                              content: Text(
                                                                  'Are you sure you want to suspend $userName?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          false),
                                                                  child: Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          true),
                                                                  child: Text(
                                                                      'Suspend'),
                                                                ),
                                                              ],
                                                            ),
                                                          );

                                                          if (confirm == true) {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(userId)
                                                                .update({
                                                              'account_status':
                                                                  'suspended'
                                                            });

                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      '$userName has been suspended')),
                                                            );
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 36.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .underground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 4.0,
                                                                color: Color(
                                                                    0x33000000),
                                                                offset: Offset(
                                                                    0.0, 2.0),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                            child: Center(
                                                              child: Text(
                                                                'Suspend',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .white,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
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
                            ),

                            // ========================================================
                            // ADMIN TAB CONTENT SECTION
                            // ========================================================
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ----------------------------------------
                                    // ADMIN SEARCH BAR WIDGET
                                    // ----------------------------------------
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 22.0, bottom: 16.0),
                                      child: Center(
                                        child: ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxWidth: 400),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .blankCanvas,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                )
                                              ],
                                            ),
                                            child: TextFormField(
                                              controller: _model
                                                  .searchBarTextController2,
                                              focusNode:
                                                  _model.searchBarFocusNode2,
                                              decoration: InputDecoration(
                                                hintText:
                                                    FFLocalizations.of(context)
                                                        .getText(
                                                  'zpml24qc' /* Search admin here */,
                                                ),
                                                hintStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .labelMedium
                                                    .override(
                                                      font: GoogleFonts.inter(),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      letterSpacing: 0.0,
                                                    ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 14.0,
                                                ),
                                                suffixIcon: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    // Admin Search Button Widget
                                                    IconButton(
                                                      icon: Icon(Icons.search,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tastyCrust),
                                                      onPressed: () {
                                                        setState(() {
                                                          _adminSearchQuery = _model
                                                              .searchBarTextController2
                                                              .text
                                                              .trim();
                                                        });
                                                      },
                                                    ),
                                                    // Admin Clear Button Widget
                                                    if (_adminSearchQuery
                                                        .isNotEmpty)
                                                      IconButton(
                                                        icon: Icon(Icons.clear,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tastyCrust),
                                                        onPressed: () {
                                                          setState(() {
                                                            _model
                                                                .searchBarTextController2
                                                                ?.clear();
                                                            _adminSearchQuery =
                                                                ''; // reset search
                                                          });
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // ----------------------------------------
                                    // ADMIN APPLICATIONS SECTION TITLE WIDGET
                                    // ----------------------------------------
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 16.0),
                                      child: Text(
                                        'Applications',
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),

                                    // ----------------------------------------
                                    // PENDING ADMIN APPLICATIONS WIDGET
                                    // ----------------------------------------
                                    StreamBuilder<QuerySnapshot>(
                                      stream: (_adminSearchQuery.isEmpty)
                                          ? FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role', isEqualTo: 'Admin')
                                              .where('account_status',
                                                  isEqualTo: 'pending')
                                              .snapshots()
                                          : FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role', isEqualTo: 'Admin')
                                              .where('account_status',
                                                  isEqualTo: 'pending')
                                              .where('display_name',
                                                  isGreaterThanOrEqualTo:
                                                      _adminSearchQuery,
                                                  isLessThanOrEqualTo:
                                                      '$_adminSearchQuery\uf8ff')
                                              .snapshots(),
                                      builder: (context, snapshot) {
                                        // Error handling
                                        if (snapshot.hasError) {
                                          return Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'Error loading applications: ${snapshot.error}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        color: Colors.red,
                                                      ),
                                            ),
                                          );
                                        }

                                        // Loading state
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            height: 100,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tastyCrust,
                                              ),
                                            ),
                                          );
                                        }

                                        // No data
                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              _adminSearchQuery.isEmpty
                                                  ? 'No pending applications'
                                                  : 'No applications found matching "$_adminSearchQuery"',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                            ),
                                          );
                                        }

                                        final pendingAdmins =
                                            snapshot.data!.docs;

                                        return Column(
                                          children: pendingAdmins.map((doc) {
                                            final adminData = doc.data()
                                                as Map<String, dynamic>;
                                            final adminId = doc.id;
                                            final adminName =
                                                adminData['display_name'] ??
                                                    'Unnamed';
                                            final createdDate =
                                                adminData['created_time'] !=
                                                        null
                                                    ? (adminData['created_time']
                                                            as Timestamp)
                                                        .toDate()
                                                        .toString()
                                                        .split(' ')[0]
                                                    : 'N/A';

                                            // Individual Admin Application Card Widget
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 12.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .blankCanvas,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    )
                                                  ],
                                                ),
                                                child: ListTile(
                                                  title: Text(
                                                    adminName,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge,
                                                  ),
                                                  subtitle: Text(
                                                    'Applied on $createdDate',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelSmall,
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      // Admin Accept Button Widget
                                                      TextButton(
                                                        onPressed: () async {
                                                          try {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(adminId)
                                                                .update({
                                                              'account_status':
                                                                  'active'
                                                            });

                                                            if (mounted) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      '$adminName approved'),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                ),
                                                              );
                                                            }
                                                          } catch (e) {
                                                            if (mounted) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      'Error approving admin: $e'),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              );
                                                            }
                                                          }
                                                        },
                                                        child: Text(
                                                          'Accept',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ),

                                                      // Admin Reject Button Widget
                                                      TextButton(
                                                        onPressed: () async {
                                                          final confirm =
                                                              await showDialog<
                                                                  bool>(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: Text(
                                                                  'Confirm Rejection'),
                                                              content: Text(
                                                                  'Are you sure you want to reject $adminName?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          false),
                                                                  child: Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          true),
                                                                  child: Text(
                                                                      'Reject'),
                                                                ),
                                                              ],
                                                            ),
                                                          );

                                                          if (confirm == true) {
                                                            try {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(adminId)
                                                                  .delete();

                                                              if (mounted) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        '$adminName rejected'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .orange,
                                                                  ),
                                                                );
                                                              }
                                                            } catch (e) {
                                                              if (mounted) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        'Error rejecting admin: $e'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          }
                                                        },
                                                        child: Text(
                                                          'Reject',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),

                                    // Add spacing between sections
                                    SizedBox(height: 24.0),

                                    // ----------------------------------------
                                    // ADMIN ACCOUNTS SECTION TITLE WIDGET
                                    // ----------------------------------------
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 24.0, bottom: 16.0),
                                      child: Text(
                                        'Admin Accounts',
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),

                                    // ----------------------------------------
                                    // APPROVED ADMIN ACCOUNTS WIDGET
                                    // ----------------------------------------
                                    StreamBuilder<QuerySnapshot>(
                                      stream: (_adminSearchQuery.isEmpty)
                                          ? FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role', isEqualTo: 'Admin')
                                              .where('account_status',
                                                  isEqualTo: 'active')
                                              .snapshots()
                                          : FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role', isEqualTo: 'Admin')
                                              .where('account_status',
                                                  isEqualTo: 'active')
                                              .where('display_name',
                                                  isGreaterThanOrEqualTo:
                                                      _adminSearchQuery,
                                                  isLessThanOrEqualTo:
                                                      '$_adminSearchQuery\uf8ff')
                                              .snapshots(),
                                      builder: (context, snapshot) {
                                        // Error handling
                                        if (snapshot.hasError) {
                                          return Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'Error loading admin accounts: ${snapshot.error}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        color: Colors.red,
                                                      ),
                                            ),
                                          );
                                        }

                                        // Loading state
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            height: 100,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tastyCrust,
                                              ),
                                            ),
                                          );
                                        }

                                        // No data
                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              _adminSearchQuery.isEmpty
                                                  ? 'No approved admins found'
                                                  : 'No admin accounts found matching "$_adminSearchQuery"',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                            ),
                                          );
                                        }

                                        final admins = snapshot.data!.docs;

                                        return Column(
                                          children: admins.map((doc) {
                                            final adminData = doc.data()
                                                as Map<String, dynamic>;
                                            final adminId = doc.id;
                                            final adminName =
                                                adminData['display_name'] ??
                                                    'Unnamed';
                                            final joinedDate =
                                                adminData['created_time'] !=
                                                        null
                                                    ? (adminData['created_time']
                                                            as Timestamp)
                                                        .toDate()
                                                        .toString()
                                                        .split(' ')[0]
                                                    : 'N/A';

                                            // Individual Admin Account Card Widget
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 12.0),
                                              child: Container(
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .blankCanvas,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 3.0,
                                                      color: Color(0x33000000),
                                                      offset: Offset(0.0, 1.0),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Admin Info Section
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              adminName,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                                height: 4.0),
                                                            Text(
                                                              'Admin • Joined $joinedDate',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelSmall,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Admin Suspend Button Widget
                                                      InkWell(
                                                        onTap: () async {
                                                          final confirm =
                                                              await showDialog<
                                                                  bool>(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: Text(
                                                                  'Confirm Suspend'),
                                                              content: Text(
                                                                  'Are you sure you want to suspend $adminName?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          false),
                                                                  child: Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          true),
                                                                  child: Text(
                                                                      'Suspend'),
                                                                ),
                                                              ],
                                                            ),
                                                          );

                                                          if (confirm == true) {
                                                            try {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(adminId)
                                                                  .update({
                                                                'account_status':
                                                                    'suspended'
                                                              });

                                                              if (mounted) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        '$adminName suspended'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .orange,
                                                                  ),
                                                                );
                                                              }
                                                            } catch (e) {
                                                              if (mounted) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        'Error suspending admin: $e'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 36.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .underground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 4.0,
                                                                color: Color(
                                                                    0x33000000),
                                                                offset: Offset(
                                                                    0.0, 2.0),
                                                              ),
                                                            ],
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .blankCanvas,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                            child: Center(
                                                              child: Text(
                                                                'Suspend',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .white,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),

                                    // Add some bottom padding
                                    SizedBox(height: 20.0),
                                  ],
                                ),
                              ),
                            ),

                            // ========================================================
                            // VENDOR TAB CONTENT SECTION
                            // ========================================================
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ----------------------------------------
                                    // VENDOR SEARCH BAR WIDGET
                                    // ----------------------------------------
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 22.0, bottom: 16.0),
                                      child: Center(
                                        child: ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxWidth: 400),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .blankCanvas,
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                )
                                              ],
                                            ),
                                            child: TextFormField(
                                              controller: _model
                                                  .searchBarTextController3,
                                              focusNode:
                                                  _model.searchBarFocusNode3,
                                              decoration: InputDecoration(
                                                hintText: 'Search vendor here',
                                                hintStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .labelMedium
                                                    .override(
                                                      font: GoogleFonts.inter(),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      letterSpacing: 0.0,
                                                    ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 14.0,
                                                ),
                                                suffixIcon: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    // Vendor Search Button Widget
                                                    IconButton(
                                                      icon: Icon(Icons.search,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tastyCrust),
                                                      onPressed: () {
                                                        setState(() {
                                                          _vendorSearchQuery =
                                                              _model
                                                                  .searchBarTextController3
                                                                  .text
                                                                  .trim();
                                                        });
                                                      },
                                                    ),
                                                    // Vendor Clear Button Widget
                                                    if (_vendorSearchQuery
                                                        .isNotEmpty)
                                                      IconButton(
                                                        icon: Icon(Icons.clear,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tastyCrust),
                                                        onPressed: () {
                                                          setState(() {
                                                            _model
                                                                .searchBarTextController3
                                                                ?.clear();
                                                            _vendorSearchQuery =
                                                                ''; // reset search
                                                          });
                                                        },
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // ----------------------------------------
                                    // VENDOR APPLICATIONS SECTION TITLE WIDGET
                                    // ----------------------------------------
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 16.0),
                                      child: Text(
                                        'Applications',
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),

                                    // ----------------------------------------
                                    // PENDING VENDOR APPLICATIONS WIDGET
                                    // ----------------------------------------
                                    StreamBuilder<QuerySnapshot>(
                                      stream: (_vendorSearchQuery.isEmpty)
                                          ? FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role',
                                                  isEqualTo: 'Vendor')
                                              .where('account_status',
                                                  isEqualTo: 'pending')
                                              .snapshots()
                                          : FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role',
                                                  isEqualTo: 'Vendor')
                                              .where('account_status',
                                                  isEqualTo: 'pending')
                                              .where('display_name',
                                                  isGreaterThanOrEqualTo:
                                                      _vendorSearchQuery,
                                                  isLessThanOrEqualTo:
                                                      '$_vendorSearchQuery\uf8ff')
                                              .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'Error loading applications: ${snapshot.error}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        color: Colors.red,
                                                      ),
                                            ),
                                          );
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            height: 100,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tastyCrust,
                                              ),
                                            ),
                                          );
                                        }

                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              _vendorSearchQuery.isEmpty
                                                  ? 'No pending vendor applications'
                                                  : 'No applications found matching "$_vendorSearchQuery"',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                            ),
                                          );
                                        }

                                        final pendingVendors =
                                            snapshot.data!.docs;

                                        return Column(
                                          children: pendingVendors.map((doc) {
                                            final vendorData = doc.data()
                                                as Map<String, dynamic>;
                                            final vendorId = doc.id;
                                            final vendorName =
                                                vendorData['display_name'] ??
                                                    'Unnamed';
                                            final createdDate = vendorData[
                                                        'created_time'] !=
                                                    null
                                                ? (vendorData['created_time']
                                                        as Timestamp)
                                                    .toDate()
                                                    .toString()
                                                    .split(' ')[0]
                                                : 'N/A';

                                            // Individual Vendor Application Card Widget
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 12.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .blankCanvas,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 4,
                                                      offset: Offset(0, 2),
                                                    )
                                                  ],
                                                ),
                                                child: ListTile(
                                                  title: Text(
                                                    vendorName,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyLarge,
                                                  ),
                                                  subtitle: Text(
                                                    'Applied on $createdDate',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelSmall,
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      // Vendor Accept Button Widget
                                                      TextButton(
                                                        onPressed: () async {
                                                          try {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(vendorId)
                                                                .update({
                                                              'account_status':
                                                                  'active'
                                                            });
                                                            if (context
                                                                .mounted) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      '$vendorName approved'),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                ),
                                                              );
                                                            }
                                                          } catch (e) {
                                                            if (context
                                                                .mounted) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                      'Error approving vendor: $e'),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              );
                                                            }
                                                          }
                                                        },
                                                        child: Text(
                                                          'Accept',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ),

                                                      // Vendor Reject Button Widget
                                                      TextButton(
                                                        onPressed: () async {
                                                          final confirm =
                                                              await showDialog<
                                                                  bool>(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: Text(
                                                                  'Confirm Rejection'),
                                                              content: Text(
                                                                  'Are you sure you want to reject $vendorName?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          false),
                                                                  child: Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          true),
                                                                  child: Text(
                                                                      'Reject'),
                                                                ),
                                                              ],
                                                            ),
                                                          );

                                                          if (confirm == true) {
                                                            try {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(vendorId)
                                                                  .delete();

                                                              if (context
                                                                  .mounted) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        '$vendorName rejected'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .orange,
                                                                  ),
                                                                );
                                                              }
                                                            } catch (e) {
                                                              if (context
                                                                  .mounted) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        'Error rejecting vendor: $e'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          }
                                                        },
                                                        child: Text(
                                                          'Reject',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),

                                    // Add spacing between sections
                                    SizedBox(height: 20.0),

                                    // ----------------------------------------
                                    // VENDOR ACCOUNTS SECTION TITLE WIDGET
                                    // ----------------------------------------
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, bottom: 12.0),
                                      child: Text(
                                        'Vendor Accounts',
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),

                                    // ----------------------------------------
                                    // APPROVED VENDOR ACCOUNTS WIDGET
                                    // ----------------------------------------
                                    StreamBuilder<QuerySnapshot>(
                                      stream: (_vendorSearchQuery.isEmpty)
                                          ? FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role',
                                                  isEqualTo: 'Vendor')
                                              .where('account_status',
                                                  isEqualTo: 'active')
                                              .snapshots()
                                          : FirebaseFirestore.instance
                                              .collection('users')
                                              .where('role',
                                                  isEqualTo: 'Vendor')
                                              .where('account_status',
                                                  isEqualTo: 'active')
                                              .where('display_name',
                                                  isGreaterThanOrEqualTo:
                                                      _vendorSearchQuery,
                                                  isLessThanOrEqualTo:
                                                      '$_vendorSearchQuery\uf8ff')
                                              .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Container(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              'Error loading vendor accounts: ${snapshot.error}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        color: Colors.red,
                                                      ),
                                            ),
                                          );
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            height: 100,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tastyCrust,
                                              ),
                                            ),
                                          );
                                        }

                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return Container(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              _vendorSearchQuery.isEmpty
                                                  ? 'No vendor accounts'
                                                  : 'No vendor accounts found matching "$_vendorSearchQuery"',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                            ),
                                          );
                                        }

                                        final approvedVendors =
                                            snapshot.data!.docs;

                                        return Column(
                                          children: approvedVendors.map((doc) {
                                            final vendorData = doc.data()
                                                as Map<String, dynamic>;
                                            final vendorId = doc.id;
                                            final vendorName =
                                                vendorData['display_name'] ??
                                                    'Unnamed';
                                            final joinedDate = vendorData[
                                                        'created_time'] !=
                                                    null
                                                ? (vendorData['created_time']
                                                        as Timestamp)
                                                    .toDate()
                                                    .toString()
                                                    .split(' ')[0]
                                                : 'N/A';

                                            // Individual Vendor Account Card Widget
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
                                              child: Container(
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .blankCanvas,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      blurRadius: 3.0,
                                                      color: Color(0x33000000),
                                                      offset: Offset(0.0, 1.0),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Vendor Info Section
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              vendorName,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                                height: 4.0),
                                                            Text(
                                                              'Vendor • Joined $joinedDate',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelSmall,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Vendor Suspend Button Widget
                                                      InkWell(
                                                        onTap: () async {
                                                          final confirm =
                                                              await showDialog<
                                                                  bool>(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: const Text(
                                                                  'Confirm Suspension'),
                                                              content: Text(
                                                                  'Suspend $vendorName\'s account?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          false),
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          true),
                                                                  child:
                                                                      const Text(
                                                                    'Suspend',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );

                                                          if (confirm == true) {
                                                            try {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(vendorId)
                                                                  .update({
                                                                'account_status':
                                                                    'suspended'
                                                              });
                                                              if (context
                                                                  .mounted) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        '$vendorName suspended'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .orange,
                                                                  ),
                                                                );
                                                              }
                                                            } catch (e) {
                                                              if (context
                                                                  .mounted) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                    content: Text(
                                                                        'Error suspending vendor: $e'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 36.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .underground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                blurRadius: 4.0,
                                                                color: Color(
                                                                    0x33000000),
                                                                offset: Offset(
                                                                    0.0, 2.0),
                                                              ),
                                                            ],
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .blankCanvas,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12.0),
                                                          child: Center(
                                                            child: Text(
                                                              'Suspend',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .white,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),

                                    // ----------------------------------------
                                    // BOTTOM SPACING WIDGET - Space from bottom nav bar
                                    // ----------------------------------------
                                    SizedBox(height: 20.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
