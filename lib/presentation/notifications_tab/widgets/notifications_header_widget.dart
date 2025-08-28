import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationsHeaderWidget extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onSettingsTap;
  final VoidCallback? onMarkAllRead;

  const NotificationsHeaderWidget({
    Key? key,
    required this.unreadCount,
    required this.onSettingsTap,
    this.onMarkAllRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline.withAlpha(26),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                if (unreadCount > 0)
                  Padding(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.3.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unreadCount unread',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onError,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Mark All Read Button
          if (onMarkAllRead != null) ...[
            TextButton(
              onPressed: onMarkAllRead,
              child: Text(
                'Mark all read',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],

          // Settings Button
          IconButton(
            onPressed: onSettingsTap,
            icon: CustomIconWidget(
              iconName: 'settings',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            tooltip: 'Notification Settings',
          ),
        ],
      ),
    );
  }
}
