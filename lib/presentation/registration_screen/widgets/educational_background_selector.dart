import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EducationalBackgroundSelector extends StatelessWidget {
  final String? selectedBackground;
  final Function(String?) onChanged;

  const EducationalBackgroundSelector({
    Key? key,
    required this.selectedBackground,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Educational Background',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedBackground,
              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                child: Text(
                  'Select your educational background',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              isExpanded: true,
              icon: Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              items: _getEducationalBackgrounds().map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      value,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (selectedBackground != null) ...[
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _getBackgroundDescription(selectedBackground!),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<String> _getEducationalBackgrounds() {
    return [
      'High School Student',
      'Undergraduate Student',
      'Graduate Student',
      'Competitive Exam Aspirant',
      'Professional Certification',
      'Lifelong Learner',
      'Other',
    ];
  }

  String _getBackgroundDescription(String background) {
    switch (background) {
      case 'High School Student':
        return 'Optimized revision intervals for foundational learning';
      case 'Undergraduate Student':
        return 'Balanced intervals for semester-based learning';
      case 'Graduate Student':
        return 'Extended intervals for research and advanced topics';
      case 'Competitive Exam Aspirant':
        return 'Intensive revision schedule for exam preparation';
      case 'Professional Certification':
        return 'Focused intervals for skill-based learning';
      case 'Lifelong Learner':
        return 'Flexible intervals for continuous learning';
      case 'Other':
        return 'Standard revision intervals that can be customized';
      default:
        return 'Standard revision intervals';
    }
  }
}
