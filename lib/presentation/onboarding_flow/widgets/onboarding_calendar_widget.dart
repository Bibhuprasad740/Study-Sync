import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class OnboardingCalendarWidget extends StatefulWidget {
  final bool isActive;

  const OnboardingCalendarWidget({
    super.key,
    required this.isActive,
  });

  @override
  State<OnboardingCalendarWidget> createState() =>
      _OnboardingCalendarWidgetState();
}

class _OnboardingCalendarWidgetState extends State<OnboardingCalendarWidget>
    with TickerProviderStateMixin {
  late AnimationController _calendarController;
  late AnimationController _highlightController;

  late Animation<double> _calendarAnimation;
  late Animation<double> _highlightAnimation;

  List<int> _highlightedDays = [];
  int _currentHighlight = 0;

  @override
  void initState() {
    super.initState();

    _calendarController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _highlightController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _calendarAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _calendarController,
      curve: Curves.easeOutBack,
    ));

    _highlightAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _highlightController,
      curve: Curves.easeInOut,
    ));

    // Spaced repetition schedule: 1 day, 3 days, 1 week, 2 weeks, 1 month
    _highlightedDays = [5, 8, 12, 19, 35];
  }

  @override
  void didUpdateWidget(OnboardingCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startCalendarDemo();
    } else if (!widget.isActive && oldWidget.isActive) {
      _calendarController.reset();
      _highlightController.reset();
      _currentHighlight = 0;
    }
  }

  void _startCalendarDemo() {
    _calendarController.forward();

    // Animate highlighting spaced repetition intervals
    Future.delayed(const Duration(milliseconds: 1800), () {
      _animateHighlights();
    });
  }

  void _animateHighlights() {
    if (!mounted || !widget.isActive) return;

    if (_currentHighlight < _highlightedDays.length) {
      _highlightController.forward().then((_) {
        _highlightController.reverse().then((_) {
          setState(() {
            _currentHighlight++;
          });
          Future.delayed(const Duration(milliseconds: 400), () {
            _animateHighlights();
          });
        });
      });
    } else {
      // Reset and repeat
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted && widget.isActive) {
          setState(() {
            _currentHighlight = 0;
          });
          _animateHighlights();
        }
      });
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _highlightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main calendar
          AnimatedBuilder(
            animation: _calendarAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _calendarAnimation.value,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _calendarAnimation.value,
                  child: _buildCalendar(),
                ),
              );
            },
          ),

          // Notification badges
          AnimatedBuilder(
            animation: _calendarAnimation,
            builder: (context, child) {
              final delay = max(0.0, (_calendarAnimation.value - 0.7) / 0.3);
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: delay,
                child: _buildNotificationBadges(),
              );
            },
          ),

          // Legend
          Positioned(
            bottom: 20,
            child: AnimatedBuilder(
              animation: _calendarAnimation,
              builder: (context, child) {
                final delay = max(0.0, (_calendarAnimation.value - 0.5) / 0.5);
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: delay,
                  child: _buildLegend(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Calendar header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
              Text(
                'January 2025',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Week days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return SizedBox(
                width: 32,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 8),

          // Calendar grid
          ...List.generate(6, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (dayIndex) {
                  final dayNumber =
                      (weekIndex * 7) + dayIndex - 2; // Start from Dec 30
                  final isCurrentMonth = dayNumber >= 1 && dayNumber <= 31;
                  final displayNumber = isCurrentMonth ? dayNumber : '';

                  return _buildCalendarDay(
                    displayNumber.toString(),
                    dayNumber,
                    isCurrentMonth,
                  );
                }),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(String day, int dayNumber, bool isCurrentMonth) {
    final isToday = dayNumber == 3;
    final isHighlighted = _highlightedDays.contains(dayNumber);
    final isCurrentlyAnimating = _currentHighlight < _highlightedDays.length &&
        _highlightedDays[_currentHighlight] == dayNumber;

    return AnimatedBuilder(
      animation: _highlightAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isCurrentlyAnimating ? _highlightAnimation.value : 1.0,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isToday
                  ? Theme.of(context).colorScheme.primary
                  : isHighlighted
                      ? Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: isCurrentlyAnimating
                  ? Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                day,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isToday
                      ? Colors.white
                      : isCurrentMonth
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationBadges() {
    return Positioned(
      top: 60,
      right: 20,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_active,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  '3',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Reviews due',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLegendItem(
            color: Theme.of(context).colorScheme.primary,
            label: 'Today',
          ),
          const SizedBox(width: 16),
          _buildLegendItem(
            color: Theme.of(context).colorScheme.secondary,
            label: 'Review days',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
