import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RevisionFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final List<String> subjects;
  final String? selectedSubject;
  final Function(String?) onSubjectChanged;

  const RevisionFilterWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.subjects,
    this.selectedSubject,
    required this.onSubjectChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          _buildTimeFilter(context, isDarkMode),
          SizedBox(height: 2.h),
          _buildSubjectFilter(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildTimeFilter(BuildContext context, bool isDarkMode) {
    final List<String> filters = ['Today', 'Overdue', 'Upcoming'];

    return Container(
      height: 5.h,
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        children: filters.map((filter) {
          final bool isSelected = selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: Container(
                margin: EdgeInsets.all(0.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : (isDarkMode
                                  ? AppTheme.textSecondaryDark
                                  : AppTheme.textSecondaryLight),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubjectFilter(BuildContext context, bool isDarkMode) {
    if (subjects.isEmpty) return SizedBox.shrink();

    return Container(
      height: 5.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subjects.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSubjectChip(
              context,
              isDarkMode,
              'All Subjects',
              selectedSubject == null,
              () => onSubjectChanged(null),
            );
          }

          final subject = subjects[index - 1];
          return _buildSubjectChip(
            context,
            isDarkMode,
            subject,
            selectedSubject == subject,
            () => onSubjectChanged(subject),
          );
        },
      ),
    );
  }

  Widget _buildSubjectChip(
    BuildContext context,
    bool isDarkMode,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: FilterChip(
        label: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : (isDarkMode
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor:
            isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        selectedColor: AppTheme.lightTheme.primaryColor,
        side: BorderSide(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : (isDarkMode ? AppTheme.borderDark : AppTheme.borderLight),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
