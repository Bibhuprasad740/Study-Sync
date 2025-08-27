import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoalCardWidget extends StatelessWidget {
  final Map<String, dynamic> goal;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onStatistics;

  const GoalCardWidget({
    Key? key,
    required this.goal,
    required this.onTap,
    required this.onLongPress,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    required this.onStatistics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int subjectCount = (goal['subjects'] as List?)?.length ?? 0;
    final double completionPercentage =
        (goal['completionPercentage'] as num?)?.toDouble() ?? 0.0;
    final String lastStudied = goal['lastStudied'] as String? ?? 'Never';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
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
                      child: Text(
                        goal['title'] as String? ?? 'Untitled Goal',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit();
                            break;
                          case 'delete':
                            onDelete();
                            break;
                          case 'share':
                            onShare();
                            break;
                          case 'statistics':
                            onStatistics();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'edit',
                                size: 18,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                              SizedBox(width: 2.w),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'statistics',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'analytics',
                                size: 18,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                              SizedBox(width: 2.w),
                              Text('Statistics'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'share',
                                size: 18,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                              SizedBox(width: 2.w),
                              Text('Share'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'delete',
                                size: 18,
                                color: AppTheme.errorLight,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Delete',
                                style: TextStyle(color: AppTheme.errorLight),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: CustomIconWidget(
                        iconName: 'more_vert',
                        size: 20,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$subjectCount Subjects',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Last studied: $lastStudied',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${completionPercentage.toInt()}%',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: completionPercentage >= 80
                                ? AppTheme.successLight
                                : completionPercentage >= 50
                                    ? AppTheme.warningLight
                                    : AppTheme.errorLight,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          width: 20.w,
                          height: 0.5.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: completionPercentage / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: completionPercentage >= 80
                                    ? AppTheme.successLight
                                    : completionPercentage >= 50
                                        ? AppTheme.warningLight
                                        : AppTheme.errorLight,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
