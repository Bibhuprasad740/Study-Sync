import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModal extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterModal({
    Key? key,
    required this.currentFilters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late Map<String, dynamic> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 4.w,
        right: 4.w,
        top: 2.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Filter Goals',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: Text('Clear All'),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Completion Status',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            children: [
              _buildFilterChip('All', 'completion', 'all'),
              _buildFilterChip('Not Started (0%)', 'completion', 'not_started'),
              _buildFilterChip(
                  'In Progress (1-99%)', 'completion', 'in_progress'),
              _buildFilterChip('Completed (100%)', 'completion', 'completed'),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Sort By',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            children: [
              _buildFilterChip('Recently Created', 'sort', 'recent'),
              _buildFilterChip('Alphabetical', 'sort', 'alphabetical'),
              _buildFilterChip('Progress', 'sort', 'progress'),
              _buildFilterChip('Last Studied', 'sort', 'last_studied'),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String filterType, String value) {
    final bool isSelected = _filters[filterType] == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filters[filterType] = selected ? value : null;
        });
      },
      selectedColor:
          AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
      labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.onSurface,
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _filters = {
        'completion': null,
        'sort': null,
      };
    });
  }

  void _applyFilters() {
    widget.onApplyFilters(_filters);
    Navigator.pop(context);
  }
}
