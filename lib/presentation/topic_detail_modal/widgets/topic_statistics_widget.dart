import 'package:flutter/material.dart';

class TopicStatisticsWidget extends StatelessWidget {
  final double completionRate;
  final double averagePerformance;
  final int streak;
  final String lastReviewed;

  const TopicStatisticsWidget({
    super.key,
    required this.completionRate,
    required this.averagePerformance,
    required this.streak,
    required this.lastReviewed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard(
                context,
                'Completion Rate',
                '${completionRate.toInt()}%',
                Icons.check_circle_outline,
                Theme.of(context).colorScheme.secondary,
              ),
              _buildStatCard(
                context,
                'Avg Performance',
                '${averagePerformance.toStringAsFixed(1)}/10',
                Icons.trending_up,
                Theme.of(context).colorScheme.primary,
              ),
              _buildStatCard(
                context,
                'Current Streak',
                '$streak days',
                Icons.local_fire_department,
                Theme.of(context).colorScheme.tertiary,
              ),
              _buildStatCard(
                context,
                'Last Reviewed',
                _formatDate(lastReviewed),
                Icons.access_time,
                Theme.of(context).colorScheme.outline,
              ),
            ],
          ),

          SizedBox(height: 32),

          // Performance trend
          Text(
            'Performance Trend',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 16),

          Container(
            height: 200,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: _buildPerformanceTrendChart(context),
          ),

          SizedBox(height: 32),

          // Study patterns
          Text(
            'Study Patterns',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 16),

          _buildStudyPatterns(context),

          SizedBox(height: 32),

          // Insights
          Text(
            'Insights & Recommendations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 16),

          _buildInsights(context),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                icon,
                color: color,
                size: 20,
              ),
            ],
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTrendChart(BuildContext context) {
    // Mock data for performance trend
    List<double> performanceData = [7.5, 8.0, 9.0, 8.5, 9.5, 8.0, 9.0];
    List<String> dates = [
      'Jan 19',
      'Jan 22',
      'Jan 25',
      'Jan 28',
      'Jan 31',
      'Feb 3',
      'Feb 6'
    ];

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: performanceData.asMap().entries.map((entry) {
              int index = entry.key;
              double value = entry.value;
              double height = (value / 10.0) * 120; // Max height 120

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Value label
                  Text(
                    value.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 4),
                  // Bar
                  Container(
                    width: 24,
                    height: height,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Date label
                  Text(
                    dates[index],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStudyPatterns(BuildContext context) {
    return Column(
      children: [
        _buildPatternRow(
          context,
          'Best Study Time',
          '2:00 PM - 4:00 PM',
          Icons.schedule,
          'Based on your performance data',
        ),
        SizedBox(height: 12),
        _buildPatternRow(
          context,
          'Average Session',
          '42 minutes',
          Icons.timer,
          'Optimal for retention',
        ),
        SizedBox(height: 12),
        _buildPatternRow(
          context,
          'Weekly Frequency',
          '3.5 sessions/week',
          Icons.calendar_today,
          'Consistent study pattern',
        ),
      ],
    );
  }

  Widget _buildPatternRow(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(BuildContext context) {
    return Column(
      children: [
        _buildInsightCard(
          context,
          '🎯',
          'Strong Performance',
          'Your average score of 8.5/10 shows excellent understanding. Keep it up!',
          Theme.of(context).colorScheme.secondary,
        ),
        SizedBox(height: 12),
        _buildInsightCard(
          context,
          '🔥',
          'Great Consistency',
          'Your 12-day streak demonstrates excellent study habits. Consistency is key to retention.',
          Theme.of(context).colorScheme.tertiary,
        ),
        SizedBox(height: 12),
        _buildInsightCard(
          context,
          '📈',
          'Room for Growth',
          'Consider reviewing neural network architectures more frequently to boost completion rate to 85%+.',
          Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildInsightCard(
    BuildContext context,
    String emoji,
    String title,
    String description,
    Color accentColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;

      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Yesterday';
      } else if (difference < 7) {
        return '${difference}d ago';
      } else {
        return '${date.day}/${date.month}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
