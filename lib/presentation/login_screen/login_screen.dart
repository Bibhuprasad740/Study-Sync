import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/app_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'student@studysync.com': 'student123',
    'teacher@studysync.com': 'teacher123',
    'admin@studysync.com': 'admin123',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 4.h),

                  // App Logo Section
                  AppLogoWidget(),

                  SizedBox(height: 6.h),

                  // Welcome Text
                  Text(
                    'Welcome Back!',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    'Sign in to continue your learning journey',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 4.h),

                  // Login Form
                  LoginFormWidget(
                    onLogin: _handleLogin,
                    isLoading: _isLoading,
                  ),

                  SizedBox(height: 4.h),

                  // Social Login Options
                  SocialLoginWidget(
                    isLoading: _isLoading,
                    onGoogleLogin: _handleGoogleLogin,
                    onAppleLogin: _handleAppleLogin,
                  ),

                  SizedBox(height: 4.h),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New user? ',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(
                                    context, '/registration-screen');
                              },
                        child: Text(
                          'Sign Up',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(String email, String password) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(Duration(seconds: 2));

      // Check mock credentials
      if (_mockCredentials.containsKey(email.toLowerCase()) &&
          _mockCredentials[email.toLowerCase()] == password) {
        // Success haptic feedback
        HapticFeedback.lightImpact();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login successful! Welcome back.'),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate to Studies tab
          Navigator.pushReplacementNamed(context, '/studies-tab');
        }
      } else {
        // Show error for invalid credentials
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid email or password. Please try again.'),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      // Handle network or other errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong. Please try again later.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate Google login process
      await Future.delayed(Duration(seconds: 2));

      // Success haptic feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google login successful!'),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to Studies tab
        Navigator.pushReplacementNamed(context, '/studies-tab');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google login failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleAppleLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate Apple login process
      await Future.delayed(Duration(seconds: 2));

      // Success haptic feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Apple login successful!'),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to Studies tab
        Navigator.pushReplacementNamed(context, '/studies-tab');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Apple login failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
