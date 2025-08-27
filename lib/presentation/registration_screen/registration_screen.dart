import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/educational_background_selector.dart';
import './widgets/password_strength_indicator.dart';
import './widgets/plan_comparison_card.dart';
import './widgets/terms_privacy_links.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isTermsAgreed = false;
  String? _selectedEducationalBackground;

  // Focus nodes
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      _buildHeader(),
                      SizedBox(height: 4.h),
                      _buildNameField(),
                      SizedBox(height: 3.h),
                      _buildEmailField(),
                      SizedBox(height: 3.h),
                      _buildPasswordField(),
                      PasswordStrengthIndicator(
                          password: _passwordController.text),
                      SizedBox(height: 3.h),
                      _buildConfirmPasswordField(),
                      SizedBox(height: 3.h),
                      EducationalBackgroundSelector(
                        selectedBackground: _selectedEducationalBackground,
                        onChanged: (value) {
                          setState(() {
                            _selectedEducationalBackground = value;
                          });
                        },
                      ),
                      PlanComparisonCard(),
                      SizedBox(height: 3.h),
                      TermsPrivacyLinks(
                        isAgreed: _isTermsAgreed,
                        onChanged: (value) {
                          setState(() {
                            _isTermsAgreed = value ?? false;
                          });
                        },
                      ),
                      SizedBox(height: 4.h),
                      _buildCreateAccountButton(),
                      SizedBox(height: 3.h),
                      _buildLoginLink(),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _handleBackNavigation(),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'Create Account',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join StudySync',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Start your journey to smarter studying with spaced repetition learning',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Full Name',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _nameController,
          focusNode: _nameFocus,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person_outline',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_emailFocus);
          },
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _emailController,
          focusNode: _emailFocus,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'email_outlined',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email address';
            }
            if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                .hasMatch(value.trim())) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocus);
          },
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          textInputAction: TextInputAction.next,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Create a strong password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock_outline',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_confirmPasswordFocus);
          },
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocus,
          textInputAction: TextInputAction.done,
          obscureText: !_isConfirmPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock_outline',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: _isConfirmPasswordVisible
                      ? 'visibility_off'
                      : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton() {
    final isFormValid = _isFormValid();

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: isFormValid && !_isLoading ? _handleCreateAccount : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          foregroundColor: isFormValid
              ? AppTheme.lightTheme.colorScheme.onPrimary
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          elevation: isFormValid ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                'Create Account',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isFormValid
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/login-screen'),
        child: RichText(
          text: TextSpan(
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            children: [
              TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              TextSpan(
                text: 'Sign In',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    return _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text &&
        _isTermsAgreed &&
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(_emailController.text.trim());
  }

  void _handleBackNavigation() {
    if (_hasUnsavedChanges()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Discard Changes?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'You have unsaved changes. Are you sure you want to go back?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Discard',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  bool _hasUnsavedChanges() {
    return _nameController.text.trim().isNotEmpty ||
        _emailController.text.trim().isNotEmpty ||
        _passwordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty ||
        _selectedEducationalBackground != null;
  }

  Future<void> _handleCreateAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate registration API call
      await Future.delayed(Duration(seconds: 2));

      // Mock registration logic
      final email = _emailController.text.trim().toLowerCase();

      // Simulate duplicate email check
      if (email == 'test@example.com' || email == 'admin@studysync.com') {
        _showErrorDialog('Registration Failed',
            'An account with this email already exists. Please use a different email or try signing in.');
        return;
      }

      // Simulate network error
      if (email.contains('error')) {
        _showErrorDialog('Network Error',
            'Unable to create account. Please check your internet connection and try again.');
        return;
      }

      // Success - show welcome message and navigate
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog('Registration Failed',
          'An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successLight,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Welcome to StudySync!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your account has been created successfully. Get ready to revolutionize your learning with spaced repetition!',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next Steps:',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '• Complete the onboarding tutorial\n• Create your first study goal\n• Start adding subjects and topics',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/studies-tab');
            },
            child: Text('Get Started'),
          ),
        ],
      ),
    );
  }
}
