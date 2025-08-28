import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TopicDetailModalWidget extends StatefulWidget {
  final Map<String, dynamic> topic;
  final Function(Map<String, dynamic>) onEdit;
  final VoidCallback onMarkComplete;
  final VoidCallback onReschedule;

  const TopicDetailModalWidget({
    Key? key,
    required this.topic,
    required this.onEdit,
    required this.onMarkComplete,
    required this.onReschedule,
  }) : super(key: key);

  @override
  State<TopicDetailModalWidget> createState() => _TopicDetailModalWidgetState();
}

class _TopicDetailModalWidgetState extends State<TopicDetailModalWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _notesController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _notesController =
        TextEditingController(text: widget.topic['notes'] as String? ?? '');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'overdue':
        return 'Overdue';
      case 'due':
        return 'Due Today';
      case 'upcoming':
        return 'Upcoming';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'overdue':
        return AppTheme.errorLight;
      case 'due':
        return AppTheme.warningLight;
      case 'upcoming':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'completed':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  void _saveNotes() {
    HapticFeedback.lightImpact();
    final updatedTopic = Map<String, dynamic>.from(widget.topic);
    updatedTopic['notes'] = _notesController.text;
    widget.onEdit(updatedTopic);

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notes saved successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.topic['revisionStatus'] as String;
    final statusColor = _getStatusColor(status);
    final completedRevisions = widget.topic['completedRevisions'] as int;
    final totalRevisions = widget.topic['totalRevisions'] as int;
    final progress =
        totalRevisions > 0 ? completedRevisions / totalRevisions : 0.0;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: EdgeInsets.only(top: 1.h, bottom: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.topic['title'] as String,
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatusText(status),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
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
          ),

          SizedBox(height: 2.h),

          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Overview'),
                Tab(text: 'Progress'),
                Tab(text: 'Notes'),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Overview Tab
                SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        'Description',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        widget.topic['description'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Details Cards
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.primaryContainer
                                    .withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'timer',
                                    size: 24,
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    '${widget.topic['timeEstimate']}',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    'minutes',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.secondaryContainer
                                    .withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'school',
                                    size: 24,
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    widget.topic['difficulty'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    'difficulty',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Progress Tab
                SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress Circle
                      Center(
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 40.w,
                                height: 40.w,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 8,
                                  backgroundColor: AppTheme
                                      .lightTheme.colorScheme.outline
                                      .withAlpha(51),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      statusColor),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${(progress * 100).toInt()}%',
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                      ),
                                    ),
                                    Text(
                                      'Complete',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Progress Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '$completedRevisions',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.successLight,
                                ),
                              ),
                              Text(
                                'Completed',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${totalRevisions - completedRevisions}',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.warningLight,
                                ),
                              ),
                              Text(
                                'Remaining',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '$totalRevisions',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                'Total',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Notes Tab
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Study Notes',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_isEditing) {
                                _saveNotes();
                              } else {
                                setState(() {
                                  _isEditing = true;
                                });
                              }
                            },
                            child: Text(_isEditing ? 'Save' : 'Edit'),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Expanded(
                        child: TextField(
                          controller: _notesController,
                          enabled: _isEditing,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            hintText: 'Add your study notes here...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: EdgeInsets.all(4.w),
                          ),
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline.withAlpha(26),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                if (status != 'completed') ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onReschedule();
                      },
                      icon: CustomIconWidget(
                        iconName: 'schedule',
                        size: 20,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                      label: Text('Reschedule'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onMarkComplete();
                      },
                      icon: CustomIconWidget(
                        iconName: 'check',
                        size: 20,
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                      label: Text('Mark Complete'),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Implement review again functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Review again functionality coming soon!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'refresh',
                        size: 20,
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                      label: Text('Review Again'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
