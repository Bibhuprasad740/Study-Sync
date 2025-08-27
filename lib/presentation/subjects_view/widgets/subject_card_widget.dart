import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectCardWidget extends StatelessWidget {
  final Map<String, dynamic> subject;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onEdit;
  final VoidCallback onStatistics;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const SubjectCardWidget({
    Key? key,
    required this.subject,
    required this.onTap,
    required this.onLongPress,
    required this.onEdit,
    required this.onStatistics,
    required this.onShare,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completionPercentage =
        (subject['completionPercentage'] as double? ?? 0.0);
    final topicCount = subject['topicCount'] as int? ?? 0;
    final lastActivity = subject['lastActivity'] as String? ?? 'No activity';

    Color progressColor = _getProgressColor(completionPercentage);

    return Dismissible(
      key: Key('subject_${subject['id']}'),
      background: _buildSwipeBackground(isLeft: false),
      secondaryBackground: _buildSwipeBackground(isLeft: true),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context);
        } else {
          _showQuickActions(context);
          return false;
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject['name'] as String? ?? 'Untitled Subject',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '$topicCount ${topicCount == 1 ? 'topic' : 'topics'}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: progressColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${completionPercentage.toInt()}%',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: progressColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${completionPercentage.toInt()}%',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: progressColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: completionPercentage / 100,
                      backgroundColor: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      minHeight: 6,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      size: 16,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Last activity: $lastActivity',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 80) {
      return AppTheme.lightTheme.colorScheme.secondary;
    } else if (percentage >= 50) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'delete' : 'more_horiz',
                size: 24,
                color: Colors.white,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Delete' : 'Actions',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Subject',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to delete "${subject['name']}"? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                onDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subject['name'] as String? ?? 'Subject Actions',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              _buildActionTile(
                context: context,
                icon: 'edit',
                title: 'Edit Subject',
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              _buildActionTile(
                context: context,
                icon: 'bar_chart',
                title: 'View Statistics',
                onTap: () {
                  Navigator.pop(context);
                  onStatistics();
                },
              ),
              _buildActionTile(
                context: context,
                icon: 'share',
                title: 'Share Subject',
                onTap: () {
                  Navigator.pop(context);
                  onShare();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        size: 24,
        color: AppTheme.lightTheme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
