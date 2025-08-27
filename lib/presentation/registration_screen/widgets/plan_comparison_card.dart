import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlanComparisonCard extends StatelessWidget {
  const PlanComparisonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'workspace_premium',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Choose Your Plan',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: _buildPlanColumn(
                    title: 'Free Plan',
                    price: '\$0/month',
                    features: [
                      '2 topics per day',
                      '1 revision per day',
                      'Basic analytics',
                      'Standard support',
                    ],
                    isRecommended: false,
                  ),
                ),
                Container(
                  width: 1,
                  height: 20.h,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildPlanColumn(
                    title: 'Premium Plan',
                    price: '\$9.99/month',
                    features: [
                      'Unlimited topics',
                      'Unlimited revisions',
                      'Advanced analytics',
                      'Priority support',
                      'Export data',
                      'Custom intervals',
                    ],
                    isRecommended: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanColumn({
    required String title,
    required String price,
    required List<String> features,
    required bool isRecommended,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRecommended) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.successLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'RECOMMENDED',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 8.sp,
                ),
              ),
            ),
            SizedBox(height: 1.h),
          ],
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            price,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          ...features
              .map((feature) => Padding(
                    padding: EdgeInsets.only(bottom: 1.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.successLight,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            feature,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
