import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectsHeaderWidget extends StatelessWidget {
  final String goalName;
  final int subjectCount;
  final VoidCallback onBack;
  final VoidCallback onSearch;

  const SubjectsHeaderWidget({
    Key? key,
    required this.goalName,
    required this.subjectCount,
    required this.onBack,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 10.w,
                    minHeight: 6.h,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subjects',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Text(
                            goalName,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'chevron_right',
                            size: 16,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Subjects',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onSearch,
                  icon: CustomIconWidget(
                    iconName: 'search',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  tooltip: 'Search subjects',
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'school',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$subjectCount ${subjectCount == 1 ? 'Subject' : 'Subjects'}',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          subjectCount == 0
                              ? 'Start by adding your first subject'
                              : 'Tap a subject to view topics',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (subjectCount > 0)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$subjectCount',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
