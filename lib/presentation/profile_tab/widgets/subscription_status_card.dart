import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SubscriptionStatusCard extends StatelessWidget {
  final Map<String, dynamic> subscriptionData;
  final VoidCallback? onUpgradeTap;
  final VoidCallback? onManageTap;

  const SubscriptionStatusCard({
    Key? key,
    required this.subscriptionData,
    this.onUpgradeTap,
    this.onManageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPremium = subscriptionData["isPremium"] as bool;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: isPremium
            ? LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.secondary,
                  AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPremium ? null : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName:
                        isPremium ? 'workspace_premium' : 'account_circle',
                    color: isPremium
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    isPremium ? "Premium Plan" : "Free Plan",
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isPremium
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              if (isPremium)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "ACTIVE",
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          if (isPremium) ...[
            _buildFeatureItem(
              "Unlimited topics and revisions",
              true,
              isPremium,
            ),
            _buildFeatureItem(
              "Advanced analytics dashboard",
              true,
              isPremium,
            ),
            _buildFeatureItem(
              "Priority customer support",
              true,
              isPremium,
            ),
            SizedBox(height: 2.h),
            Text(
              "Next billing: ${subscriptionData["nextBilling"]}",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ] else ...[
            _buildFeatureItem(
              "2 topics per day limit",
              false,
              isPremium,
            ),
            _buildFeatureItem(
              "1 revision per day limit",
              false,
              isPremium,
            ),
            _buildFeatureItem(
              "Basic analytics only",
              false,
              isPremium,
            ),
          ],
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isPremium ? onManageTap : onUpgradeTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPremium
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: isPremium
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isPremium ? "Manage Subscription" : "Upgrade to Premium",
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isPremium
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, bool isIncluded, bool isPremium) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isIncluded ? 'check_circle' : 'cancel',
            color: isPremium
                ? (isIncluded
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.6))
                : (isIncluded
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.error),
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isPremium
                    ? Colors.white.withValues(alpha: 0.9)
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
