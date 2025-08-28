import 'package:flutter/material.dart';
import 'dart:math';

class OnboardingBrainAnimationWidget extends StatefulWidget {
  final bool isActive;

  const OnboardingBrainAnimationWidget({
    super.key,
    required this.isActive,
  });

  @override
  State<OnboardingBrainAnimationWidget> createState() =>
      _OnboardingBrainAnimationWidgetState();
}

class _OnboardingBrainAnimationWidgetState
    extends State<OnboardingBrainAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _curveController;
  late AnimationController _pulseController;

  late Animation<double> _curveAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _curveController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _curveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _curveController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(OnboardingBrainAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startAnimations();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAnimations();
    }
  }

  void _startAnimations() {
    _curveController.repeat();
    _pulseController.repeat(reverse: true);
  }

  void _stopAnimations() {
    _curveController.stop();
    _pulseController.stop();
  }

  @override
  void dispose() {
    _curveController.dispose();
    _pulseController.dispose();
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
          // Memory retention curve
          AnimatedBuilder(
            animation: _curveAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(300, 200),
                painter: MemoryRetentionCurvePainter(
                  progress: _curveAnimation.value,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),

          // Brain icon with pulse animation
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology_outlined,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          // Floating information particles
          ...List.generate(8, (index) {
            return AnimatedBuilder(
              animation: _curveAnimation,
              builder: (context, child) {
                final angle = (index * 45) * (pi / 180);
                final radius = 120.0;
                final offset = sin(_curveAnimation.value * 2 * pi + index) * 20;

                return Positioned(
                  left: 150 + (radius + offset) * cos(angle) - 8,
                  top: 150 + (radius + offset) * sin(angle) - 8,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: widget.isActive ? 0.7 : 0.0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Statistics overlay
          Positioned(
            bottom: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: widget.isActive ? 1.0 : 0.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  '200% better retention',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MemoryRetentionCurvePainter extends CustomPainter {
  final double progress;
  final Color color;

  MemoryRetentionCurvePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final width = size.width;
    final height = size.height;

    // Draw Ebbinghaus forgetting curve and spaced repetition improvements
    path.moveTo(0, height * 0.2);

    final points = <Offset>[];
    for (int i = 0; i <= (width * progress).round(); i++) {
      final x = i.toDouble();
      final normalizedX = x / width;

      // Forgetting curve with spaced repetition intervals
      double y;
      if (normalizedX < 0.2) {
        y = height * (0.2 + 0.6 * exp(-normalizedX * 3));
      } else if (normalizedX < 0.4) {
        y = height * (0.3 + 0.4 * exp(-(normalizedX - 0.2) * 2));
      } else if (normalizedX < 0.6) {
        y = height * (0.25 + 0.5 * exp(-(normalizedX - 0.4) * 1.5));
      } else if (normalizedX < 0.8) {
        y = height * (0.2 + 0.6 * exp(-(normalizedX - 0.6) * 1));
      } else {
        y = height * (0.15 + 0.7 * exp(-(normalizedX - 0.8) * 0.5));
      }

      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);

    // Draw spaced repetition markers
    if (progress > 0.2) {
      _drawMarker(canvas, size, 0.2, color);
    }
    if (progress > 0.4) {
      _drawMarker(canvas, size, 0.4, color);
    }
    if (progress > 0.6) {
      _drawMarker(canvas, size, 0.6, color);
    }
    if (progress > 0.8) {
      _drawMarker(canvas, size, 0.8, color);
    }
  }

  void _drawMarker(Canvas canvas, Size size, double position, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final x = size.width * position;
    final y = size.height * 0.3;

    canvas.drawCircle(Offset(x, y), 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
