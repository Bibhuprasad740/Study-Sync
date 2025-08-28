import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyTopicsWidget extends StatelessWidget {
  final VoidCallback onAddTopic;

  const EmptyTopicsWidget({
    Key? key,
    required this.onAddTopic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'topic',
                size: 48,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),

            SizedBox(height: 3.h),

            // Title
            Text(
              'No Topics Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 1.h),

            // Description
            Text(
              'Add your first topic to start organizing your study materials with spaced repetition.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // CTA Button
            ElevatedButton.icon(
              onPressed: onAddTopic,
              icon: CustomIconWidget(
                iconName: 'add',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              label: Text(
                'Add Your First Topic',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),

            SizedBox(height: 2.h),

            // Helper Text
            Text(
              'You can also import topics from templates',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
