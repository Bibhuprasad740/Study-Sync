import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String filterType;
  final int streakCount;
  final VoidCallback? onCreateStudy;

  const EmptyStateWidget({
    Key? key,
    required this.filterType,
    required this.streakCount,
    this.onCreateStudy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIllustration(context, isDarkMode),
          SizedBox(height: 4.h),
          _buildTitle(context, isDarkMode),
          SizedBox(height: 2.h),
          _buildDescription(context, isDarkMode),
          if (filterType == 'Today' && streakCount > 0) ...[
            SizedBox(height: 3.h),
            _buildStreakCelebration(context, isDarkMode),
          ],
          if (onCreateStudy != null) ...[
            SizedBox(height: 4.h),
            _buildActionButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildIllustration(BuildContext context, bool isDarkMode) {
    String iconName;
    Color iconColor;

    switch (filterType) {
      case 'Today':
        iconName = 'celebration';
        iconColor = AppTheme.lightTheme.colorScheme.secondary;
        break;
      case 'Overdue':
        iconName = 'schedule';
        iconColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case 'Upcoming':
        iconName = 'upcoming';
        iconColor = AppTheme.lightTheme.primaryColor;
        break;
      default:
        iconName = 'book';
        iconColor = AppTheme.lightTheme.primaryColor;
    }

    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: iconName,
          color: iconColor,
          size: 15.w,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, bool isDarkMode) {
    String title;

    switch (filterType) {
      case 'Today':
        title =
            streakCount > 0 ? 'All Done for Today!' : 'No Revisions Due Today';
        break;
      case 'Overdue':
        title = 'No Overdue Revisions';
        break;
      case 'Upcoming':
        title = 'No Upcoming Revisions';
        break;
      default:
        title = 'No Revisions Found';
    }

    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDarkMode
                ? AppTheme.textPrimaryDark
                : AppTheme.textPrimaryLight,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context, bool isDarkMode) {
    String description;

    switch (filterType) {
      case 'Today':
        description = streakCount > 0
            ? 'Great job! You\'ve completed all your revisions for today. Keep up the momentum!'
            : 'You don\'t have any revisions scheduled for today. Take some time to create new study materials.';
        break;
      case 'Overdue':
        description =
            'Excellent! You\'re all caught up with your revisions. Stay consistent to maintain your progress.';
        break;
      case 'Upcoming':
        description =
            'No upcoming revisions scheduled. Your future study sessions will appear here as you create more topics.';
        break;
      default:
        description =
            'Start by creating some study topics to begin your revision journey.';
    }

    return Text(
      description,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDarkMode
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondaryLight,
            height: 1.5,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStreakCelebration(BuildContext context, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'local_fire_department',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                '$streakCount Day Streak!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'You\'re on fire! Keep this momentum going.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDarkMode
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: 60.w,
      height: 6.h,
      child: ElevatedButton.icon(
        onPressed: onCreateStudy,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          'Create Study Topic',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
