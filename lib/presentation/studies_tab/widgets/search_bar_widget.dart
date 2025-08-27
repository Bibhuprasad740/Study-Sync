import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final String hintText;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
    this.hintText = 'Search goals, subjects, topics...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            controller.clear();
                            onChanged('');
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            size: 20,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onFilterTap,
              icon: CustomIconWidget(
                iconName: 'filter_list',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
