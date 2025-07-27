import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'redirect_page_model.dart';
export 'redirect_page_model.dart';

class RedirectPageWidget extends StatefulWidget {
  const RedirectPageWidget({super.key});

  static String routeName = 'RedirectPage';
  static String routePath = '/redirectPage';

  @override
  State<RedirectPageWidget> createState() => _RedirectPageWidgetState();
}

class _RedirectPageWidgetState extends State<RedirectPageWidget> {
  late RedirectPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RedirectPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.currentUserDoc =
          await UsersRecord.getDocumentOnce(currentUserReference!);
      if (_model.currentUserDoc?.role == 'admin') {
        context.pushNamed(AdminDashboardWidget.routeName);
      } else if (_model.currentUserDoc?.role == 'vendor') {
        context.pushNamed(VendorDashboardWidget.routeName);
      } else if (_model.currentUserDoc?.role == 'user') {
        context.pushNamed(HomePageWidget.routeName);
      }
    });
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
        backgroundColor: Colors.white,
        body: Container(
          width: 400.5,
          height: 854.68,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).blankCanvas,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Builder(
                builder: (context) {
                  if (true) {
                    return Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 350.0, 0.0, 0.0),
                        child: CircularPercentIndicator(
                          percent: 0.5,
                          radius: 60.0,
                          lineWidth: 12.0,
                          animation: true,
                          animateFromLastPercent: true,
                          progressColor:
                              FlutterFlowTheme.of(context).underground,
                          backgroundColor: FlutterFlowTheme.of(context).accent4,
                          center: Text(
                            FFLocalizations.of(context).getText(
                              'e2pxdx14' /* 50% */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 350.0, 0.0, 0.0),
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(),
                        child: Icon(
                          Icons.error,
                          color: FlutterFlowTheme.of(context).error,
                          size: 100.0,
                        ),
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                child: Text(
                  FFLocalizations.of(context).getText(
                    'iwft93pd' /* Redirecting.... */,
                  ),
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
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
