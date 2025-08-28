import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_flow.dart';
import './onboarding_brain_animation_widget.dart';
import './onboarding_calendar_widget.dart';
import './onboarding_card_demo_widget.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageData data;
  final bool isActive;

  const OnboardingPageWidget({
    super.key,
    required this.data,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Illustration section
          Expanded(
            flex: 3,
            child: _buildIllustration(context),
          ),

          const SizedBox(height: 32),

          // Content section
          Expanded(
            flex: 2,
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    switch (data.pageType) {
      case OnboardingPageType.intro:
        return _buildIntroIllustration(context);
      case OnboardingPageType.science:
        return OnboardingBrainAnimationWidget(isActive: isActive);
      case OnboardingPageType.organization:
        return OnboardingCardDemoWidget(isActive: isActive);
      case OnboardingPageType.scheduling:
        return OnboardingCalendarWidget(isActive: isActive);
    }
  }

  Widget _buildIntroIllustration(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large StudySync logo
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                  blurRadius: 32,
                  spreadRadius: 8,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.psychology_alt_rounded,
                  size: 80,
                  color: Colors.white,
                ),

                // Floating knowledge particles
                ...List.generate(6, (index) {
                  final angle = (index * 60) * (3.14159 / 180);
                  final radius = 90.0;

                  return AnimatedPositioned(
                    duration: Duration(milliseconds: 800 + (index * 200)),
                    curve: Curves.easeOutBack,
                    left: 80 + (radius * cos(angle)) - 4,
                    top: 80 + (radius * sin(angle)) - 4,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 1000 + (index * 100)),
                      opacity: isActive ? 1.0 : 0.0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Welcome message
          AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: isActive ? 1.0 : 0.0,
            child: Text(
              '🚀 Ready to transform your learning?',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        // Title
        AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: isActive ? 1.0 : 0.0,
          child: Text(
            data.title,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 12),

        // Subtitle
        AnimatedOpacity(
          duration: const Duration(milliseconds: 700),
          opacity: isActive ? 1.0 : 0.0,
          child: Text(
            data.subtitle,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),

        // Description
        AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: isActive ? 1.0 : 0.0,
          child: Text(
            data.description,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
              height: 1.5,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// Import required for trigonometric functions
