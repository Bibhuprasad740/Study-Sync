import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          child: Row(
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                iconName: 'school',
                label: 'Studies',
                isSelected: currentIndex == 0,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                iconName: 'refresh',
                label: 'Revisions',
                isSelected: currentIndex == 1,
              ),
              _buildNavItem(
                context: context,
                index: 2,
                iconName: 'notifications',
                label: 'Notifications',
                isSelected: currentIndex == 2,
              ),
              _buildNavItem(
                context: context,
                index: 3,
                iconName: 'person',
                label: 'Profile',
                isSelected: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String iconName,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: iconName,
                size: 24,
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
