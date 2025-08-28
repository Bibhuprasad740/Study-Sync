import 'package:flutter/material.dart';

class AchievementsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementsWidget({
    super.key,
    required this.achievements,
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
                'Recent Achievements',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: () => _viewAllAchievements(context),
                child: Text('View All'),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Achievement cards
          ...achievements
              .map((achievement) => Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: _buildAchievementCard(context, achievement),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
      BuildContext context, Map<String, dynamic> achievement) {
    final title = achievement['title'] as String;
    final description = achievement['description'] as String;
    final icon = achievement['icon'] as String;
    final isEarned = achievement['earned'] as bool;
    final date = achievement['date'] as String?;
    final progress = achievement['progress'] as double?;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEarned
            ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05)
            : Theme.of(context).colorScheme.outline.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEarned
              ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          // Achievement icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isEarned
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
              shape: BoxShape.circle,
              boxShadow: isEarned
                  ? [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                _getIconEmoji(icon),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),

          SizedBox(width: 16),

          // Achievement info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isEarned
                                  ? Theme.of(context).colorScheme.secondary
                                  : null,
                            ),
                      ),
                    ),
                    if (isEarned)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'EARNED',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 4),

                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),

                if (isEarned && date != null) ...[
                  SizedBox(height: 4),
                  Text(
                    'Earned on ${_formatDate(date)}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],

                // Progress bar for unearned achievements
                if (!isEarned && progress != null) ...[
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getIconEmoji(String iconType) {
    switch (iconType) {
      case 'fire':
        return '🔥';
      case 'star':
        return '⭐';
      case 'trophy':
        return '🏆';
      case 'medal':
        return '🥇';
      case 'crown':
        return '👑';
      case 'target':
        return '🎯';
      case 'rocket':
        return '🚀';
      case 'lightning':
        return '⚡';
      default:
        return '🏆';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _viewAllAchievements(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    'All Achievements',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  SizedBox(height: 16),

                  // Achievement categories tabs
                  DefaultTabController(
                    length: 3,
                    child: Expanded(
                      child: Column(
                        children: [
                          TabBar(
                            tabs: [
                              Tab(text: 'Earned'),
                              Tab(text: 'In Progress'),
                              Tab(text: 'All'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildAchievementList(achievements
                                    .where((a) => a['earned'] == true)
                                    .toList()),
                                _buildAchievementList(achievements
                                    .where((a) => a['earned'] == false)
                                    .toList()),
                                _buildAchievementList(achievements),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAchievementList(List<Map<String, dynamic>> achievementList) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 16),
      itemCount: achievementList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: _buildAchievementCard(context, achievementList[index]),
        );
      },
    );
  }
}
