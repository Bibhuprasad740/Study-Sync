import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../../core/app_export.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _dotsController;
  late AnimationController _circleController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _dotsAnimation;
  late Animation<double> _circleAnimation;

  bool _isInitialized = false;
  String _statusText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAppInitialization();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Dots animation controller
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Circle expansion animation controller
    _circleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animations
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Loading dots animation
    _dotsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dotsController,
      curve: Curves.easeInOut,
    ));

    // Circle expansion animation representing knowledge flow
    _circleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: Curves.easeOut,
    ));

    // Start logo animation
    _logoController.forward();

    // Start dots animation with delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _dotsController.repeat();
      }
    });

    // Start circle animation
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _circleController.forward();
      }
    });
  }

  Future<void> _startAppInitialization() async {
    try {
      // Simulate app initialization processes
      await _simulateInitializationSteps();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _statusText = 'Ready!';
        });

        // Navigate to onboarding or main app after completion
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboardingFlow);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusText = 'Loading failed. Tap to retry';
        });
      }
    }
  }

  Future<void> _simulateInitializationSteps() async {
    final steps = [
      'Loading core modules...',
      'Checking authentication...',
      'Preparing your studies...',
      'Almost ready...',
    ];

    for (int i = 0; i < steps.length; i++) {
      if (mounted) {
        setState(() {
          _statusText = steps[i];
        });
        await Future.delayed(Duration(milliseconds: 600 + (i * 100)));
      }
    }
  }

  void _retryInitialization() {
    if (!_isInitialized) {
      setState(() {
        _statusText = 'Retrying...';
      });
      _startAppInitialization();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _dotsController.dispose();
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                    const Color(0xFF334155),
                  ]
                : [
                    const Color(0xFFFAFAFA),
                    const Color(0xFFEEF2FF),
                    const Color(0xFFDDD6FE),
                  ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background animated circles
              _buildBackgroundCircles(isDarkMode),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Logo section
                    _buildLogoSection(isDarkMode),

                    const SizedBox(height: 48),

                    // Loading indicator
                    _buildLoadingIndicator(isDarkMode),

                    const SizedBox(height: 24),

                    // Status text
                    _buildStatusText(isDarkMode),

                    const Spacer(flex: 3),

                    // Footer
                    _buildFooter(isDarkMode),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundCircles(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _circleAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Large expanding circle
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 200 * _circleAnimation.value,
                height: 200 * _circleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (isDarkMode ? Colors.blue.shade400 : Colors.blue.shade200)
                          .withValues(alpha: 0.1 * _circleAnimation.value),
                ),
              ),
            ),

            // Medium circle
            Positioned(
              bottom: -50,
              left: -80,
              child: Container(
                width: 150 * _circleAnimation.value,
                height: 150 * _circleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDarkMode
                          ? Colors.green.shade400
                          : Colors.green.shade200)
                      .withValues(alpha: 0.15 * _circleAnimation.value),
                ),
              ),
            ),

            // Small accent circles
            Positioned(
              top: 100,
              left: 50,
              child: Container(
                width: 80 * _circleAnimation.value,
                height: 80 * _circleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDarkMode
                          ? Colors.purple.shade400
                          : Colors.purple.shade200)
                      .withValues(alpha: 0.12 * _circleAnimation.value),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogoSection(bool isDarkMode) {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoScaleAnimation, _logoOpacityAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: _logoOpacityAnimation.value,
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Column(
              children: [
                // StudySync Logo Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 4,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Brain/Book icon representation
                      Icon(
                        Icons.psychology_alt_rounded,
                        size: 60,
                        color: Colors.white,
                      ),

                      // Overlapping cards indicating spaced repetition
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          width: 16,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 25,
                        right: 25,
                        child: Container(
                          width: 16,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // App name
                Text(
                  'StudySync',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Master Through Repetition',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _dotsAnimation,
      builder: (context, child) {
        return SizedBox(
          width: 60,
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              final delayFactor = index * 0.3;
              final animationValue = (_dotsAnimation.value + delayFactor) % 1.0;
              final opacity = (sin(animationValue * 2 * pi) + 1) / 2;

              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3 + (0.7 * opacity)),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildStatusText(bool isDarkMode) {
    return GestureDetector(
      onTap: _retryInitialization,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Text(
          _statusText,
          key: ValueKey(_statusText),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            letterSpacing: 0.1,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildFooter(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          Text(
            '© 2025 StudySync',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
