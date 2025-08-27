import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class RevisionCardWidget extends StatelessWidget {
  final Map<String, dynamic> revision;
  final VoidCallback onMarkComplete;
  final VoidCallback onReschedule;
  final VoidCallback onTap;
  final bool isExpanded;

  const RevisionCardWidget({
    Key? key,
    required this.revision,
    required this.onMarkComplete,
    required this.onReschedule,
    required this.onTap,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final int daysOverdue = revision['daysOverdue'] ?? 0;
    final bool isOverdue = daysOverdue > 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: isOverdue ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isOverdue
              ? BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error, width: 1)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDarkMode, isOverdue),
                SizedBox(height: 2.h),
                _buildContent(isDarkMode),
                if (isExpanded) ...[
                  SizedBox(height: 2.h),
                  _buildExpandedContent(isDarkMode),
                ],
                SizedBox(height: 2.h),
                _buildActionButton(isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode, bool isOverdue) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                revision['topicTitle'] ?? 'Untitled Topic',
                style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isOverdue
                          ? AppTheme.lightTheme.colorScheme.error
                          : (isDarkMode
                              ? AppTheme.textPrimaryDark
                              : AppTheme.textPrimaryLight),
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                revision['subjectName'] ?? 'General',
                style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (isOverdue) _buildOverdueBadge(),
      ],
    );
  }

  Widget _buildOverdueBadge() {
    final int daysOverdue = revision['daysOverdue'] ?? 0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$daysOverdue day${daysOverdue > 1 ? 's' : ''} overdue',
        style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Widget _buildContent(bool isDarkMode) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'schedule',
          color: isDarkMode
              ? AppTheme.textSecondaryDark
              : AppTheme.textSecondaryLight,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Text(
          'Due: ${revision['dueDate'] ?? 'Today'}',
          style: TextStyle(
                fontSize: 12,
                color: isDarkMode
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
              ),
        ),
        Spacer(),
        CustomIconWidget(
          iconName: 'repeat',
          color: isDarkMode
              ? AppTheme.textSecondaryDark
              : AppTheme.textSecondaryLight,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          'Cycle ${revision['cycleNumber'] ?? 1}',
          style: TextStyle(
                fontSize: 12,
                color: isDarkMode
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
              ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: (isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight)
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (revision['notes'] != null &&
              (revision['notes'] as String).isNotEmpty) ...[
            Text(
              'Study Notes:',
              style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode
                        ? AppTheme.textPrimaryDark
                        : AppTheme.textPrimaryLight,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              revision['notes'] ?? '',
              style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.5.h),
          ],
          Text(
            'Revision History:',
            style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Last completed: ${revision['lastCompleted'] ?? 'Never'}',
            style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton.icon(
        onPressed: onMarkComplete,
        icon: CustomIconWidget(
          iconName: 'check_circle',
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          'Mark Complete',
          style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}