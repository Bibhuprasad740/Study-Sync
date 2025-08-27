import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Function(String)? onItemTap;

  const SettingsSection({
    Key? key,
    required this.title,
    required this.items,
    this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 1.h),
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              indent: 4.w,
              endIndent: 4.w,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () => onItemTap?.call(item["action"] as String),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: (item["iconColor"] as Color)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: item["icon"] as String,
                            color: item["iconColor"] as Color,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (item["subtitle"] != null) ...[
                              SizedBox(height: 0.5.h),
                              Text(
                                item["subtitle"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (item["hasSwitch"] == true) ...[
                        Switch(
                          value: item["switchValue"] as bool,
                          onChanged: (value) =>
                              onItemTap?.call("${item["action"]}_toggle"),
                        ),
                      ] else ...[
                        CustomIconWidget(
                          iconName: 'chevron_right',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
