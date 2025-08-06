import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/services/session_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page_model.dart';
export 'login_page_model.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  static String routeName = 'LoginPage';
  static String routePath = '/loginPage';

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  late LoginPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// Enhanced sign-in method with better error handling
  Future<void> _performSignIn() async {
    // Validate form
    if (!_model.validateForm()) {
      _showErrorMessage('Please fix the errors above');
      return;
    }

    setState(() {
      _model.isLoading = true;
    });

    try {
      // Prepare authentication
      GoRouter.of(context).prepareAuthEvent();

      // Attempt sign in
      final user = await authManager.signInWithEmail(
        context,
        _model.trimmedEmail,
        _model.password,
      );

      if (user == null) {
        _handleSignInFailure('Sign in failed');
        return;
      }

      // Check email verification
      if (!await _checkEmailVerification()) {
        return;
      }

      // Get user document and handle role-based navigation
      await _handleSuccessfulSignIn();
    } catch (error) {
      _handleSignInFailure(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _model.isLoading = false;
        });
      }
    }
  }

  /// Check email verification status
  Future<bool> _checkEmailVerification() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return false;

    await firebaseUser.reload();

    if (!firebaseUser.emailVerified) {
      await FirebaseAuth.instance.signOut();
      await _showEmailVerificationDialog(firebaseUser);
      return false;
    }

    return true;
  }

  /// Show email verification dialog
  Future<void> _showEmailVerificationDialog(User firebaseUser) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Email Not Verified'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please verify your email before signing in.'),
            const SizedBox(height: 12),
            const Text(
                'Check your email inbox and click the verification link.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await firebaseUser.sendEmailVerification();
                Navigator.of(context).pop();
                _showSuccessMessage('Verification email sent!');
              } catch (e) {
                _showErrorMessage('Failed to send verification email: $e');
              }
            },
            child: const Text('Resend Email'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Handle successful sign in
  Future<void> _handleSuccessfulSignIn() async {
    try {
      // Track successful login
      await _trackLoginSession();

      // Get user document
      _model.currentUserDoc =
          await UsersRecord.getDocumentOnce(currentUserReference!);

      if (_model.currentUserDoc == null) {
        _showErrorMessage('User record not found in Firestore');
        return;
      }

      // Navigate based on role
      await _navigateBasedOnRole();
    } catch (e) {
      _showErrorMessage('Error during sign in: $e');
    }
  }

  /// Track login session
  Future<void> _trackLoginSession() async {
    try {
      await SessionService.trackUserAction(
        action: 'user_login',
        metadata: {
          'login_time': DateTime.now().toIso8601String(),
          'login_method': 'email_password',
          'user_email': _model.trimmedEmail,
        },
      );
      print('✅ Login session tracked successfully');
    } catch (e) {
      print('⚠️ Failed to track login session: $e');
    }
  }

  /// Navigate based on user role
  Future<void> _navigateBasedOnRole() async {
    final role = _model.currentUserDoc?.role?.toLowerCase();
    final accountStatus = _model.currentUserDoc?.accountStatus?.toLowerCase();

    // Check if account is suspended
    if (accountStatus == 'suspended') {
      _showErrorMessage(
          'Your account has been suspended. Please contact support.');
      return;
    }

    // Navigate based on role
    switch (role) {
      case 'admin':
        if (accountStatus != 'active') {
          _showErrorMessage('Admin account pending approval');
          return;
        }
        context.pushNamedAuth(AdminDashboardWidget.routeName, context.mounted);
        break;

      case 'vendor':
        if (accountStatus != 'active') {
          _showErrorMessage('Vendor account pending admin approval');
          return;
        }
        context.pushNamedAuth(VendorDashboardWidget.routeName, context.mounted);
        break;

      case 'user':
        if (accountStatus != 'active') {
          _showErrorMessage(
              'Your account is not active. Please contact support.');
          return;
        }
        context.pushNamedAuth(HomePageWidget.routeName, context.mounted);
        break;

      default:
        _showErrorMessage('No role assigned for this account.');
    }
  }

  /// Handle sign in failure
  void _handleSignInFailure(String error) {
    final userFriendlyMessage = _model.getUserFriendlyErrorMessage(error);
    _showErrorMessage(userFriendlyMessage);
  }

  /// Show error message
  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[600],
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  /// Show success message
  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green[600],
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Build enhanced text field with validation
  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required LoginValidationResult? validation,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    List<String>? autofillHints,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                  font: GoogleFonts.inter(),
                  letterSpacing: 0.0,
                ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _getBorderColor(validation),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _getFocusedBorderColor(validation),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red[600]!,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red[600]!,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).blankCanvas,
            suffixIcon: _buildSuffixIcon(validation, suffixIcon),
          ),
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                font: GoogleFonts.inter(),
                letterSpacing: 0.0,
              ),
        ),
        if (validation?.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 12.0, right: 12.0),
            child: Text(
              validation!.errorMessage!,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  /// Get border color based on validation
  Color _getBorderColor(LoginValidationResult? validation) {
    if (validation == null)
      return FlutterFlowTheme.of(context).primaryBackground;
    if (validation.isValid) return Colors.green[400]!;
    return Colors.red[400]!;
  }

  /// Get focused border color based on validation
  Color _getFocusedBorderColor(LoginValidationResult? validation) {
    if (validation == null) return FlutterFlowTheme.of(context).primary;
    if (validation.isValid) return Colors.green[600]!;
    return Colors.red[600]!;
  }

  /// Build suffix icon with validation feedback
  Widget? _buildSuffixIcon(
      LoginValidationResult? validation, Widget? customSuffix) {
    if (customSuffix != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (validation != null) _buildValidationIcon(validation),
          const SizedBox(width: 8),
          customSuffix,
        ],
      );
    }

    return validation != null ? _buildValidationIcon(validation) : null;
  }

  /// Build validation icon
  Widget _buildValidationIcon(LoginValidationResult validation) {
    if (validation.isValid) {
      return Icon(Icons.check_circle, color: Colors.green[600]);
    } else {
      return Icon(Icons.error, color: Colors.red[600]);
    }
  }

  /// Build sign in button
  Widget _buildSignInButton() {
    final isEnabled = _model.isFormValid && !_model.isLoading;

    return FFButtonWidget(
      onPressed: isEnabled ? _performSignIn : null,
      text: _model.isLoading ? 'Signing In...' : 'Sign In',
      options: FFButtonOptions(
        width: 200.0,
        height: 44.0,
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        color: isEnabled
            ? FlutterFlowTheme.of(context).underground
            : Colors.grey[400],
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
              font: GoogleFonts.interTight(),
              color: Colors.white,
              letterSpacing: 0.0,
            ),
        elevation: isEnabled ? 3.0 : 0.0,
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      showLoadingIndicator: false, // We handle loading state manually
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
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  width: 100.0,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo section
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 60.0, 0.0, 20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Picture1.png',
                                  width: 250.0,
                                  height: 175.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Form section
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 10.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(maxWidth: 430.0),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Welcome text
                                    Text(
                                      'Welcome Back',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineLarge
                                          .override(
                                            font: GoogleFonts.interTight(),
                                            color: FlutterFlowTheme.of(context)
                                                .underground,
                                            letterSpacing: 0.0,
                                          ),
                                    ),

                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 12.0, 0.0, 24.0),
                                      child: Text(
                                        'Let\'s get started by filling out the form below.',
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              font: GoogleFonts.inter(),
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),

                                    // Email field
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 16.0),
                                      child: _buildEnhancedTextField(
                                        controller:
                                            _model.emailAddressTextController!,
                                        focusNode:
                                            _model.emailAddressFocusNode!,
                                        labelText: 'Email',
                                        validation: _model.emailValidation,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autofillHints: [AutofillHints.email],
                                      ),
                                    ),

                                    // Password field
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 16.0),
                                      child: _buildEnhancedTextField(
                                        controller:
                                            _model.passwordTextController!,
                                        focusNode: _model.passwordFocusNode!,
                                        labelText: 'Password',
                                        validation: _model.passwordValidation,
                                        obscureText: !_model.passwordVisibility,
                                        autofillHints: [AutofillHints.password],
                                        suffixIcon: InkWell(
                                          onTap: () => setState(() =>
                                              _model.passwordVisibility =
                                                  !_model.passwordVisibility),
                                          child: Icon(
                                            _model.passwordVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Forgot Password
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 16.0),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: GestureDetector(
                                          onTap: () {
                                            _showForgotPasswordDialog();
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .underground,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Sign in button
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 30.0, 0.0, 16.0),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            _buildSignInButton(),
                                            if (_model.isLoading)
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Sign up link
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 0.0, 12.0),
                                        child: RichText(
                                          textScaler:
                                              MediaQuery.of(context).textScaler,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    'Don\'t have an account?  ',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(),
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: 'Sign Up here',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .underground,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                mouseCursor:
                                                    SystemMouseCursors.click,
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        context.pushNamed(
                                                            CreateAccountWidget
                                                                .routeName);
                                                      },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show forgot password dialog
  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Enter your email address and we\'ll send you a password reset link.'),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: emailController.text.trim(),
                );
                Navigator.of(context).pop();
                _showSuccessMessage('Password reset email sent!');
              } catch (e) {
                _showErrorMessage(
                    'Failed to send reset email: ${_model.getUserFriendlyErrorMessage(e.toString())}');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).underground,
            ),
            child:
                Text('Send Reset Email', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
