import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddSubjectDialogWidget extends StatefulWidget {
  final Function(String, String) onAddSubject;

  const AddSubjectDialogWidget({
    Key? key,
    required this.onAddSubject,
  }) : super(key: key);

  @override
  State<AddSubjectDialogWidget> createState() => _AddSubjectDialogWidgetState();
}

class _AddSubjectDialogWidgetState extends State<AddSubjectDialogWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 90.w,
          maxHeight: 80.h,
        ),
        padding: EdgeInsets.all(6.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'school',
                      size: 24,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Add New Subject',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      size: 24,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 8.w,
                      minHeight: 6.h,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                'Subject Name',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Mathematics, Physics, History',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'subject',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppTheme.lightTheme.colorScheme.surface,
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a subject name';
                  }
                  if (value.trim().length < 2) {
                    return 'Subject name must be at least 2 characters';
                  }
                  return null;
                },
                maxLength: 50,
                buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) {
                  return Text(
                    '$currentLength/${maxLength ?? 0}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
              SizedBox(height: 3.h),
              Text(
                'Description (Optional)',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Brief description of what you\'ll study...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'description',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppTheme.lightTheme.colorScheme.surface,
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                maxLength: 200,
                buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) {
                  return Text(
                    '$currentLength/${maxLength ?? 0}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.all(4.w),
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
                    CustomIconWidget(
                      iconName: 'info_outline',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'After creating the subject, you can add topics to organize your study materials.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleAddSubject,
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text('Add Subject'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddSubject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(Duration(milliseconds: 500)); // Simulate API call

      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      widget.onAddSubject(name, description);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add subject. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
