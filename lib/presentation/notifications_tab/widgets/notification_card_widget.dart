import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationCardWidget extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  const NotificationCardWidget({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onMarkRead,
    required this.onDelete,
  }) : super(key: key);

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  Widget _getNotificationIcon() {
    final type = notification['type'] as String;
    switch (type) {
      case 'revision':
        final priority = notification['priority'] as String?;
        final isOverdue = notification['isOverdue'] as bool? ?? false;
        return Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: isOverdue
                ? AppTheme.errorLight.withAlpha(26)
                : priority == 'high'
                    ? AppTheme.warningLight.withAlpha(26)
                    : AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: isOverdue ? 'schedule_send' : 'schedule',
            size: 20,
            color: isOverdue
                ? AppTheme.errorLight
                : priority == 'high'
                    ? AppTheme.warningLight
                    : AppTheme.lightTheme.colorScheme.primary,
          ),
        );
      case 'achievement':
        return Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.successLight.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'emoji_events',
            size: 20,
            color: AppTheme.successLight,
          ),
        );
      case 'system':
        return Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.onSurfaceVariant.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'info',
            size: 20,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        );
      default:
        return Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.outline.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'notifications',
            size: 20,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        );
    }
  }

  Widget _buildActionButtons() {
    final type = notification['type'] as String;

    switch (type) {
      case 'revision':
        return Row(
          children: [
            TextButton(
              onPressed: () {
                // TODO: Implement reschedule
              },
              child: Text(
                'Reschedule',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: 2.w),
            ElevatedButton(
              onPressed: onTap,
              child: Text(
                'Study Now',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 0,
              ),
            ),
          ],
        );
      case 'achievement':
        return ElevatedButton.icon(
          onPressed: onTap,
          icon: CustomIconWidget(
            iconName: 'share',
            size: 16,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
          label: Text(
            'Share',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.successLight,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 0,
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = notification['isRead'] as bool;
    final title = notification['title'] as String;
    final description = notification['description'] as String;
    final timestamp = notification['timestamp'] as DateTime;

    return Dismissible(
      key: Key('notification_${notification['id']}'),
      direction: DismissDirection.horizontal,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: AppTheme.successLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 6.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'mark_email_read',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Mark Read',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: AppTheme.errorLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Delete',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onError,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'delete',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onError,
                ),
              ],
            ),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onMarkRead();
          return false;
        } else {
          return true;
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isRead
                    ? AppTheme.lightTheme.colorScheme.surface
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isRead
                      ? AppTheme.lightTheme.colorScheme.outline.withAlpha(26)
                      : AppTheme.lightTheme.colorScheme.primary.withAlpha(77),
                  width: isRead ? 1 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _getNotificationIcon(),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (!isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: EdgeInsets.only(right: 2.w),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: isRead
                                          ? FontWeight.w500
                                          : FontWeight.w600,
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                Text(
                                  _formatTimestamp(timestamp),
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              description,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Subject/Topic Context (for revision notifications)
                  if (notification['type'] == 'revision' &&
                      notification['subjectTitle'] != null)
                    Container(
                      margin: EdgeInsets.only(left: 14.w, top: 1.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withAlpha(26),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${notification['subjectTitle']} • ${notification['topicTitle']}',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                  // Action Buttons
                  if (notification['type'] == 'revision' ||
                      notification['type'] == 'achievement')
                    Container(
                      margin: EdgeInsets.only(left: 14.w, top: 1.5.h),
                      child: _buildActionButtons(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
