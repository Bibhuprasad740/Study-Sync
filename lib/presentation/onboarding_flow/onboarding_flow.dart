import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/onboarding_page_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 4;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Welcome to StudySync',
      subtitle: 'Master any subject through the power of spaced repetition',
      description:
          'StudySync uses scientifically proven spaced repetition techniques to help you retain information longer and learn more effectively.',
      pageType: OnboardingPageType.intro,
    ),
    OnboardingPageData(
      title: 'Science-Backed Learning',
      subtitle: 'Your brain remembers better with spaced repetition',
      description:
          'Studies show that reviewing information at increasing intervals improves long-term retention by up to 200%.',
      pageType: OnboardingPageType.science,
    ),
    OnboardingPageData(
      title: 'Organize Your Studies',
      subtitle: 'Goals → Subjects → Topics made simple',
      description:
          'Create study goals, organize subjects, and break them down into manageable topics. Stay focused and track your progress.',
      pageType: OnboardingPageType.organization,
    ),
    OnboardingPageData(
      title: 'Smart Scheduling',
      subtitle: 'We remind you when it\'s time to review',
      description:
          'Our intelligent algorithm schedules your reviews at optimal intervals, ensuring maximum retention with minimal effort.',
      pageType: OnboardingPageType.scheduling,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // Navigate to login screen for new users
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with skip button
            _buildTopBar(),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    data: _pages[index],
                    isActive: index == _currentPage,
                  );
                },
              ),
            ),

            // Bottom section with indicators and navigation
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology_alt_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'StudySync',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),

          // Skip button
          TextButton(
            onPressed: _skipOnboarding,
            child: Text(
              'Skip',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Page indicators
          _buildPageIndicators(),

          const SizedBox(height: 24),

          // Navigation buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalPages, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == _currentPage ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == _currentPage
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        // Back button
        if (_currentPage > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousPage,
              child: Text(
                'Back',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        if (_currentPage > 0) const SizedBox(width: 16),

        // Next/Get Started button
        Expanded(
          flex: _currentPage > 0 ? 1 : 2,
          child: ElevatedButton(
            onPressed: _nextPage,
            child: Text(
              _currentPage == _totalPages - 1 ? 'Get Started' : 'Next',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum OnboardingPageType {
  intro,
  science,
  organization,
  scheduling,
}

class OnboardingPageData {
  final String title;
  final String subtitle;
  final String description;
  final OnboardingPageType pageType;

  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.pageType,
  });
}
