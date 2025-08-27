import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectsSearchWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onClear;
  final bool isVisible;

  const SubjectsSearchWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onClear,
    required this.isVisible,
  }) : super(key: key);

  @override
  State<SubjectsSearchWidget> createState() => _SubjectsSearchWidgetState();
}

class _SubjectsSearchWidgetState extends State<SubjectsSearchWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void didUpdateWidget(SubjectsSearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
        Future.delayed(Duration(milliseconds: 100), () {
          _focusNode.requestFocus();
        });
      } else {
        _animationController.reverse();
        _focusNode.unfocus();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Search subjects...',
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
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          widget.onClear();
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          size: 20,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.lightTheme.colorScheme.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                _focusNode.unfocus();
              },
            ),
          ),
        );
      },
    );
  }
}
