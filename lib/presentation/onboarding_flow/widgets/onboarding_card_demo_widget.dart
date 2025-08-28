import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class OnboardingCardDemoWidget extends StatefulWidget {
  final bool isActive;

  const OnboardingCardDemoWidget({
    super.key,
    required this.isActive,
  });

  @override
  State<OnboardingCardDemoWidget> createState() =>
      _OnboardingCardDemoWidgetState();
}

class _OnboardingCardDemoWidgetState extends State<OnboardingCardDemoWidget>
    with TickerProviderStateMixin {
  late AnimationController _hierarchyController;
  late AnimationController _tapController;

  late Animation<double> _hierarchyAnimation;
  late Animation<double> _tapAnimation;

  int _selectedGoal = -1;
  int _selectedSubject = -1;

  @override
  void initState() {
    super.initState();

    _hierarchyController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _tapController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _hierarchyAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hierarchyController,
      curve: Curves.easeOutBack,
    ));

    _tapAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(OnboardingCardDemoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startDemo();
    } else if (!widget.isActive && oldWidget.isActive) {
      _hierarchyController.reset();
      _selectedGoal = -1;
      _selectedSubject = -1;
    }
  }

  void _startDemo() {
    _hierarchyController.forward();

    // Simulate user interactions
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted && widget.isActive) {
        _simulateGoalTap(0);
      }
    });

    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted && widget.isActive) {
        _simulateSubjectTap(1);
      }
    });

    Future.delayed(const Duration(milliseconds: 6000), () {
      if (mounted && widget.isActive) {
        setState(() {
          _selectedGoal = -1;
          _selectedSubject = -1;
        });
        _hierarchyController.reset();
        _hierarchyController.forward();
      }
    });
  }

  void _simulateGoalTap(int index) {
    _tapController.forward().then((_) {
      _tapController.reverse();
      setState(() {
        _selectedGoal = index;
      });
    });
  }

  void _simulateSubjectTap(int index) {
    _tapController.forward().then((_) {
      _tapController.reverse();
      setState(() {
        _selectedSubject = index;
      });
    });
  }

  @override
  void dispose() {
    _hierarchyController.dispose();
    _tapController.dispose();
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
          // Goal level
          AnimatedBuilder(
            animation: _hierarchyAnimation,
            builder: (context, child) {
              return Positioned(
                top: 20 + (1 - _hierarchyAnimation.value) * 100,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _hierarchyAnimation.value,
                  child: _buildGoalCard(),
                ),
              );
            },
          ),

          // Subject level
          AnimatedBuilder(
            animation: _hierarchyAnimation,
            builder: (context, child) {
              final delay = max(0.0, (_hierarchyAnimation.value - 0.3) / 0.7);
              return Positioned(
                top: 140 + (1 - delay) * 100,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: delay,
                  child: _buildSubjectsRow(),
                ),
              );
            },
          ),

          // Topic level
          AnimatedBuilder(
            animation: _hierarchyAnimation,
            builder: (context, child) {
              final delay = max(0.0, (_hierarchyAnimation.value - 0.6) / 0.4);
              return Positioned(
                top: 260 + (1 - delay) * 100,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: delay,
                  child: _buildTopicsGrid(),
                ),
              );
            },
          ),

          // Connection lines
          AnimatedBuilder(
            animation: _hierarchyAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(300, 400),
                painter: HierarchyConnectionPainter(
                  progress: _hierarchyAnimation.value,
                  selectedGoal: _selectedGoal,
                  selectedSubject: _selectedSubject,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard() {
    return AnimatedBuilder(
      animation: _tapAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _selectedGoal == 0 ? _tapAnimation.value : 1.0,
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Computer Science Degree',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Goal • 8 subjects',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubjectsRow() {
    final subjects = [
      {'name': 'Mathematics', 'icon': Icons.functions, 'topics': '12'},
      {'name': 'Algorithms', 'icon': Icons.account_tree, 'topics': '8'},
      {'name': 'Database', 'icon': Icons.storage, 'topics': '6'},
    ];

    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: subjects.asMap().entries.map((entry) {
          final index = entry.key;
          final subject = entry.value;
          final isSelected = _selectedSubject == index;

          return AnimatedBuilder(
            animation: _tapAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isSelected ? _tapAnimation.value : 1.0,
                child: Container(
                  width: 90,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.2),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        subject['icon'] as IconData,
                        size: 24,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subject['name'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${subject['topics']} topics',
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopicsGrid() {
    final topics = [
      'Arrays',
      'Sorting',
      'Trees',
      'Graphs',
      'Dynamic Programming',
      'Hash Tables',
    ];

    return SizedBox(
      width: 280,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: topics.map((topic) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              topic,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class HierarchyConnectionPainter extends CustomPainter {
  final double progress;
  final int selectedGoal;
  final int selectedSubject;
  final Color color;

  HierarchyConnectionPainter({
    required this.progress,
    required this.selectedGoal,
    required this.selectedSubject,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final activePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    if (progress < 0.3) return;

    // Draw connections from goal to subjects
    final goalCenter = Offset(size.width / 2, 80);
    final subjectCenters = [
      Offset(size.width / 2 - 100, 180),
      Offset(size.width / 2, 180),
      Offset(size.width / 2 + 100, 180),
    ];

    for (int i = 0; i < subjectCenters.length; i++) {
      final paintToUse =
          (selectedGoal == 0 || selectedSubject == i) ? activePaint : paint;
      canvas.drawLine(goalCenter, subjectCenters[i], paintToUse);
    }

    if (progress < 0.6) return;

    // Draw connections from subjects to topics
    final topicArea = Offset(size.width / 2, 300);
    for (final subjectCenter in subjectCenters) {
      final paintToUse = selectedSubject >= 0 ? activePaint : paint;
      canvas.drawLine(subjectCenter, topicArea, paintToUse);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
