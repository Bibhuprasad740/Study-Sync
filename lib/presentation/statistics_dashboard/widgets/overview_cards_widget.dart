import 'package:flutter/material.dart';

class OverviewCardsWidget extends StatelessWidget {
  final int totalTopics;
  final int currentStreak;
  final double completionRate;
  final double weeklyProgress;

  const OverviewCardsWidget({
    super.key,
    required this.totalTopics,
    required this.currentStreak,
    required this.completionRate,
    required this.weeklyProgress,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildOverviewCard(
          context,
          'Total Topics Studied',
          '$totalTopics',
          Icons.library_books_outlined,
          Theme.of(context).colorScheme.primary,
          'Topics completed',
        ),
        _buildOverviewCard(
          context,
          'Current Streak',
          '$currentStreak days',
          Icons.local_fire_department,
          Theme.of(context).colorScheme.tertiary,
          'Consecutive study days',
        ),
        _buildOverviewCard(
          context,
          'Completion Rate',
          '${completionRate.toStringAsFixed(1)}%',
          Icons.check_circle_outline,
          Theme.of(context).colorScheme.secondary,
          'Overall accuracy',
        ),
        _buildOverviewCard(
          context,
          'Weekly Progress',
          '+${weeklyProgress.toStringAsFixed(1)}%',
          Icons.trending_up,
          Theme.of(context).colorScheme.secondary,
          'Improvement this week',
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              // Trend indicator (could be dynamic based on data)
              if (title.contains('Weekly') || title.contains('Streak'))
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 16,
                  ),
                ),
            ],
          ),

          Spacer(),

          // Main value
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
          ),

          SizedBox(height: 4),

          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2),

          // Subtitle
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
