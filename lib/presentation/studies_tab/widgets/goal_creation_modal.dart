import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoalCreationModal extends StatefulWidget {
  final Function(String title, String description) onCreateGoal;

  const GoalCreationModal({
    Key? key,
    required this.onCreateGoal,
  }) : super(key: key);

  @override
  State<GoalCreationModal> createState() => _GoalCreationModalState();
}

class _GoalCreationModalState extends State<GoalCreationModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Create New Goal',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
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
            SizedBox(height: 3.h),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Goal Title',
                hintText: 'Enter your study goal title',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'flag',
                    size: 20,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a goal title';
                }
                if (value.trim().length < 3) {
                  return 'Title must be at least 3 characters long';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Describe your study goal',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'description',
                    size: 20,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
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
                    onPressed: _createGoal,
                    child: Text('Create Goal'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createGoal() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onCreateGoal(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
      );
      Navigator.pop(context);
    }
  }
}
