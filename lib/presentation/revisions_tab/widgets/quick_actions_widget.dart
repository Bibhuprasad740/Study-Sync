import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final bool hasSelectedItems;
  final int selectedCount;
  final VoidCallback onCompleteAll;
  final VoidCallback onRescheduleSelected;
  final VoidCallback onClearSelection;

  const QuickActionsWidget({
    Key? key,
    required this.hasSelectedItems,
    required this.selectedCount,
    required this.onCompleteAll,
    required this.onRescheduleSelected,
    required this.onClearSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (!hasSelectedItems) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSelectionHeader(context, isDarkMode),
            SizedBox(height: 2.h),
            _buildActionButtons(context, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionHeader(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'check_circle',
          color: AppTheme.lightTheme.primaryColor,
          size: 20,
        ),
        SizedBox(width: 2.w),
        Text(
          '$selectedCount item${selectedCount > 1 ? 's' : ''} selected',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
        ),
        Spacer(),
        TextButton(
          onPressed: onClearSelection,
          child: Text(
            'Clear',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            'Complete All',
            'check_circle',
            AppTheme.lightTheme.colorScheme.secondary,
            onCompleteAll,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildActionButton(
            context,
            'Reschedule',
            'schedule',
            AppTheme.lightTheme.colorScheme.tertiary,
            onRescheduleSelected,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    String iconName,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 5.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: CustomIconWidget(
          iconName: iconName,
          color: Colors.white,
          size: 18,
        ),
        label: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
