import 'package:flutter/material.dart';

class RevisionHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> revisionHistory;
  final String nextReview;

  const RevisionHistoryWidget({
    super.key,
    required this.revisionHistory,
    required this.nextReview,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Next review section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.schedule,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Review',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        _formatDate(nextReview),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _showSchedulePicker(context),
                  child: Text('Reschedule'),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // History title
          Text(
            'Revision History',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 16),

          // History list
          if (revisionHistory.isEmpty)
            Center(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No revision history yet',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  Text(
                    'Complete a study session to see your progress',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...revisionHistory.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> revision = entry.value;
              bool isFirst = index == 0;
              bool isLast = index == revisionHistory.length - 1;

              return _buildHistoryItem(context, revision, isFirst, isLast);
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    Map<String, dynamic> revision,
    bool isFirst,
    bool isLast,
  ) {
    final performance = revision['performance'] as double;
    final duration = revision['duration'] as int;
    final date = revision['date'] as String;
    final notes = revision['notes'] as String?;

    Color performanceColor = Theme.of(context).colorScheme.secondary;
    if (performance < 6.0) {
      performanceColor = Theme.of(context).colorScheme.error;
    } else if (performance < 8.0) {
      performanceColor = Theme.of(context).colorScheme.tertiary;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isFirst
                      ? performanceColor
                      : Theme.of(context).colorScheme.outline,
                  shape: BoxShape.circle,
                  border: isFirst
                      ? Border.all(color: performanceColor, width: 2)
                      : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),

          SizedBox(width: 16),

          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(date),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: performanceColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${performance.toStringAsFixed(1)}/10',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: performanceColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Duration
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${duration} minutes',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),

                  // Notes
                  if (notes != null && notes.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text(
                      notes,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
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
        return '${difference} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  void _showSchedulePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reschedule Review',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 16),
                _buildScheduleOption(context, 'Tomorrow', () {
                  Navigator.pop(context);
                  // Implement schedule change
                }),
                _buildScheduleOption(context, 'In 2 days', () {
                  Navigator.pop(context);
                  // Implement schedule change
                }),
                _buildScheduleOption(context, 'In 1 week', () {
                  Navigator.pop(context);
                  // Implement schedule change
                }),
                _buildScheduleOption(context, 'In 2 weeks', () {
                  Navigator.pop(context);
                  // Implement schedule change
                }),
                _buildScheduleOption(context, 'Custom date', () {
                  Navigator.pop(context);
                  _showCustomDatePicker(context);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleOption(
      BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showCustomDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        // Implement custom date scheduling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Review rescheduled to ${_formatDate(date.toIso8601String())}')),
        );
      }
    });
  }
}
