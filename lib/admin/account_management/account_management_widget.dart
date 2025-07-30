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

class _AccountManagementWidgetState extends State<AccountManagementWidget>
    with TickerProviderStateMixin {
  late AccountManagementModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).underground,
          automaticallyImplyLeading: false,
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
                  color: FlutterFlowTheme.of(context).info,
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
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          children: [
                            // ===== USER TAB =====
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        35.0), // ⬅️ global left/right padding
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // "Accounts" Title
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

                                    // Search Bar
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
                                          hintText: FFLocalizations.of(context)
                                              .getText(
                                            'zpml24qc' /* Search user here */,
                                          ),
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
                                          suffixIcon: Icon(
                                            Icons.search,
                                            color: FlutterFlowTheme.of(context)
                                                .tastyCrust,
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                    ),

                                    SizedBox(height: 12.0),

                                    // Users List
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .where('role', isEqualTo: 'User')
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
                                                      // Left: User Info
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
                                                      // Right: Suspend Button
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
                                                                .delete();
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                    '$userName suspended'),
                                                              ),
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

                            // Replace your Admin tab (second TabBarView child) with this:
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Search Bar
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 22.0, bottom: 16.0),
                                      child: Center(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth:
                                                  400), // 🔧 Adjust width here
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
                                                suffixIcon: Icon(
                                                  Icons.search,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .tastyCrust,
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

                                    // === Application Section ===
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

                                    // Pending Admin Applications
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .where('role', isEqualTo: 'Admin')
                                          .where('is_approved',
                                              isEqualTo: false)
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
                                              'No pending applications',
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
                                                      // Accept Button
                                                      TextButton(
                                                        onPressed: () async {
                                                          try {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(adminId)
                                                                .update({
                                                              'is_approved':
                                                                  true
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
                                                      // Reject Button
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

                                    // === Approved Admin Accounts Section ===
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

                                    // Approved Admins List
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .where('role', isEqualTo: 'Admin')
                                          .where('is_approved', isEqualTo: true)
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
                                              'No approved admins found',
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
                                                      // Left: Admin Info
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
                                                      // Right: Suspend Button
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
                                                                  .delete();

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

                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // === Search Bar ===
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
                                                    ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 14.0),
                                                suffixIcon: Icon(Icons.search,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .tastyCrust),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // === Applications Section ===
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 16.0),
                                      child: Text(
                                        'Applications',
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium,
                                      ),
                                    ),

                                    // Pending Vendor Applications
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .where('role',
                                              isEqualTo:
                                                  'Vendor') // ✅ must match Firebase case
                                          .where('is_approved',
                                              isEqualTo: false)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .tastyCrust),
                                          );
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return Text(
                                              'No pending vendor applications');
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

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
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
                                                  title: Text(vendorName),
                                                  subtitle: Text(
                                                      'Applied on $createdDate'),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(vendorId)
                                                              .update({
                                                            'is_approved': true
                                                          });
                                                        },
                                                        child: Text('Approve',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green)),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(vendorId)
                                                              .delete();
                                                        },
                                                        child: Text('Reject',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
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

                                    // === Accounts Section ===
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, bottom: 12.0),
                                      child: Text(
                                        'Accounts',
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium,
                                      ),
                                    ),

                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .where('role',
                                              isEqualTo:
                                                  'Vendor') // ✅ fixed case
                                          .where('is_approved', isEqualTo: true)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return Text('No vendor accounts');
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

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12.0),
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
                                                  title: Text(vendorName),
                                                  subtitle: Text(
                                                      'Active vendor account'),
                                                  trailing: GestureDetector(
                                                    onTap: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(vendorId)
                                                          .update({
                                                        'is_approved': false
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 36,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .underground,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 4,
                                                            color: Color(
                                                                0x33000000),
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .blankCanvas,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12.0),
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
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
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
            ],
          ),
        ),
      ),
    );
  }
}
