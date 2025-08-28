import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class NotificationsSegmentedControl extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChanged;
  final int revisionCount;
  final int achievementCount;
  final int systemCount;

  const NotificationsSegmentedControl({
    Key? key,
    required this.currentIndex,
    required this.onChanged,
    required this.revisionCount,
    required this.achievementCount,
    required this.systemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.outline.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: 'Revision Alerts',
              isSelected: currentIndex == 0,
              unreadCount: revisionCount,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              label: 'Achievements',
              isSelected: currentIndex == 1,
              unreadCount: achievementCount,
              onTap: () => onChanged(1),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              label: 'System',
              isSelected: currentIndex == 2,
              unreadCount: systemCount,
              onTap: () => onChanged(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int unreadCount;
  final VoidCallback onTap;

  const _SegmentButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.unreadCount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            if (unreadCount > 0)
              Container(
                margin: EdgeInsets.only(top: 0.5.h),
                padding:
                    EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.error,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$unreadCount',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onError,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
