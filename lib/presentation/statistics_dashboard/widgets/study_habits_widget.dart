import 'package:flutter/material.dart';

class StudyHabitsWidget extends StatelessWidget {
  final Map<String, dynamic> studyHabits;

  const StudyHabitsWidget({
    super.key,
    required this.studyHabits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Study Patterns',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'AI Insights',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Study habits grid
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildHabitCard(
                      context,
                      '⏰',
                      'Optimal Study Time',
                      studyHabits['optimalTime'],
                      'Peak performance window',
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildHabitCard(
                      context,
                      '⏱️',
                      'Average Session',
                      '${studyHabits['averageSession']} min',
                      'Sweet spot duration',
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildHabitCard(
                      context,
                      '📅',
                      'Weekly Frequency',
                      '${studyHabits['weeklyFrequency']} sessions',
                      'Consistent pattern',
                      Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildHabitCard(
                      context,
                      '🎯',
                      'Best Day',
                      studyHabits['bestDay'],
                      'Highest productivity',
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24),

          // Efficiency indicator
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Study Efficiency Score',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        'Based on your completion rates and retention',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${studyHabits['efficiency']}%',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    Text(
                      'Excellent',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Recommendations
          Text(
            'Personalized Recommendations',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),

          SizedBox(height: 12),

          ..._getRecommendations()
              .map((rec) => Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: _buildRecommendationCard(context, rec),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildHabitCard(
    BuildContext context,
    String emoji,
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
      BuildContext context, Map<String, String> recommendation) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recommendation['icon']!,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation['title']!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 2),
                Text(
                  recommendation['description']!,
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

  List<Map<String, String>> _getRecommendations() {
    return [
      {
        'icon': '🌅',
        'title': 'Try morning sessions',
        'description':
            'Your concentration is 23% higher in the morning. Consider studying before 10 AM.',
      },
      {
        'icon': '⏸️',
        'title': 'Take short breaks',
        'description':
            'Add 5-minute breaks every 25 minutes to improve retention by up to 15%.',
      },
      {
        'icon': '🎧',
        'title': 'Minimize distractions',
        'description':
            'Your efficiency drops 18% with notifications. Try focus mode during study sessions.',
      },
    ];
  }
}
