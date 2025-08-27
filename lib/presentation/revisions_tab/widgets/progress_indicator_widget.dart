import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int completedToday;
  final int totalDue;
  final int streakCount;

  const ProgressIndicatorWidget({
    Key? key,
    required this.completedToday,
    required this.totalDue,
    required this.streakCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double progressPercentage =
        totalDue > 0 ? (completedToday / totalDue) : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildProgressHeader(context, isDarkMode),
          SizedBox(height: 2.h),
          _buildProgressBar(context, isDarkMode, progressPercentage),
          SizedBox(height: 2.h),
          _buildStatsRow(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Today\'s Progress',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'local_fire_department',
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '$streakCount',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
      BuildContext context, bool isDarkMode, double progressPercentage) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$completedToday of $totalDue completed',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                  ),
            ),
            Text(
              '${(progressPercentage * 100).toInt()}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          height: 1.h,
          decoration: BoxDecoration(
            color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progressPercentage.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.primaryColor,
                    AppTheme.lightTheme.colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            isDarkMode,
            'check_circle',
            'Completed',
            '$completedToday',
            AppTheme.lightTheme.colorScheme.secondary,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: _buildStatItem(
            context,
            isDarkMode,
            'pending',
            'Remaining',
            '${totalDue - completedToday}',
            AppTheme.lightTheme.colorScheme.tertiary,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: _buildStatItem(
            context,
            isDarkMode,
            'trending_up',
            'Streak',
            '$streakCount days',
            AppTheme.lightTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    bool isDarkMode,
    String iconName,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 20,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDarkMode
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
          ),
        ],
      ),
    );
  }
}
