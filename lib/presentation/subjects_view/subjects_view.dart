import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_subject_dialog_widget.dart';
import './widgets/empty_subjects_widget.dart';
import './widgets/subject_card_widget.dart';
import './widgets/subjects_header_widget.dart';
import './widgets/subjects_search_widget.dart';

class SubjectsView extends StatefulWidget {
  const SubjectsView({Key? key}) : super(key: key);

  @override
  State<SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<SubjectsView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final RefreshIndicator _refreshIndicatorKey = RefreshIndicator(
    onRefresh: () async {},
    child: Container(),
  );

  bool _isSearchVisible = false;
  bool _isSelectionMode = false;
  bool _isLoading = false;
  String _searchQuery = '';
  Set<int> _selectedSubjects = {};

  // Mock data for subjects
  List<Map<String, dynamic>> _allSubjects = [
    {
      'id': 1,
      'name': 'Mathematics',
      'description': 'Advanced calculus and algebra concepts',
      'topicCount': 12,
      'completionPercentage': 75.0,
      'lastActivity': '2 hours ago',
      'createdAt': DateTime.now().subtract(Duration(days: 5)),
    },
    {
      'id': 2,
      'name': 'Physics',
      'description': 'Mechanics, thermodynamics, and quantum physics',
      'topicCount': 8,
      'completionPercentage': 45.0,
      'lastActivity': '1 day ago',
      'createdAt': DateTime.now().subtract(Duration(days: 3)),
    },
    {
      'id': 3,
      'name': 'Computer Science',
      'description': 'Data structures, algorithms, and programming',
      'topicCount': 15,
      'completionPercentage': 90.0,
      'lastActivity': '30 minutes ago',
      'createdAt': DateTime.now().subtract(Duration(days: 7)),
    },
    {
      'id': 4,
      'name': 'Chemistry',
      'description': 'Organic and inorganic chemistry fundamentals',
      'topicCount': 6,
      'completionPercentage': 30.0,
      'lastActivity': '3 days ago',
      'createdAt': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'id': 5,
      'name': 'English Literature',
      'description': 'Classic and modern literary works analysis',
      'topicCount': 10,
      'completionPercentage': 60.0,
      'lastActivity': '5 hours ago',
      'createdAt': DateTime.now().subtract(Duration(days: 4)),
    },
  ];

  List<Map<String, dynamic>> _filteredSubjects = [];
  String _goalName = 'GATE 2025 Preparation'; // Mock goal name

  @override
  void initState() {
    super.initState();
    _filteredSubjects = List.from(_allSubjects);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isSearchVisible) {
      // Auto-hide search when scrolling down
    }
  }

  List<Map<String, dynamic>> get _displayedSubjects {
    if (_searchQuery.isEmpty) {
      return _filteredSubjects;
    }
    return _filteredSubjects.where((subject) {
      final name = (subject['name'] as String).toLowerCase();
      final description =
          (subject['description'] as String? ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || description.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          SubjectsHeaderWidget(
            goalName: _goalName,
            subjectCount: _displayedSubjects.length,
            onBack: _handleBack,
            onSearch: _toggleSearch,
          ),
          if (_isSearchVisible)
            SubjectsSearchWidget(
              onSearchChanged: _handleSearchChanged,
              onClear: _handleSearchClear,
              isVisible: _isSearchVisible,
            ),
          if (_isSelectionMode) _buildSelectionToolbar(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton:
          _isSelectionMode ? null : _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_displayedSubjects.isEmpty && _searchQuery.isNotEmpty) {
      return _buildNoSearchResults();
    }

    if (_displayedSubjects.isEmpty) {
      return EmptySubjectsWidget(
        onAddSubject: _showAddSubjectDialog,
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(
          top: 2.h,
          bottom: 10.h, // Space for FAB
        ),
        itemCount: _displayedSubjects.length,
        itemBuilder: (context, index) {
          final subject = _displayedSubjects[index];
          final isSelected = _selectedSubjects.contains(subject['id']);

          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(vertical: 0.5.h),
            decoration: _isSelectionMode && isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    ),
                  )
                : null,
            child: SubjectCardWidget(
              subject: subject,
              onTap: () => _handleSubjectTap(subject),
              onLongPress: () => _handleSubjectLongPress(subject),
              onEdit: () => _handleEditSubject(subject),
              onStatistics: () => _handleViewStatistics(subject),
              onShare: () => _handleShareSubject(subject),
              onDelete: () => _handleDeleteSubject(subject),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(4.w),
              height: 20.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60.w,
                    height: 2.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 30.w,
                    height: 1.5.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: double.infinity,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 15.w,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 3.h),
            Text(
              'No subjects found',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try searching with different keywords or add a new subject.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () {
                _handleSearchClear();
                _showAddSubjectDialog();
              },
              icon: CustomIconWidget(
                iconName: 'add',
                size: 20,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              label: Text('Add New Subject'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _exitSelectionMode,
            icon: CustomIconWidget(
              iconName: 'close',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            '${_selectedSubjects.length} selected',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: _selectedSubjects.isNotEmpty ? _handleBulkDelete : null,
            icon: CustomIconWidget(
              iconName: 'delete',
              size: 24,
              color: _selectedSubjects.isNotEmpty
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            tooltip: 'Delete selected',
          ),
          IconButton(
            onPressed: _selectedSubjects.isNotEmpty ? _handleBulkArchive : null,
            icon: CustomIconWidget(
              iconName: 'archive',
              size: 24,
              color: _selectedSubjects.isNotEmpty
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            tooltip: 'Archive selected',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showAddSubjectDialog,
      icon: CustomIconWidget(
        iconName: 'add',
        size: 24,
        color: AppTheme.lightTheme.colorScheme.onPrimary,
      ),
      label: Text(
        'Add Subject',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      elevation: 4,
    );
  }

  // Event Handlers
  void _handleBack() {
    if (_isSelectionMode) {
      _exitSelectionMode();
    } else {
      Navigator.pushReplacementNamed(context, '/studies-tab');
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchQuery = '';
      }
    });
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _handleSearchClear() {
    setState(() {
      _searchQuery = '';
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subjects updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleSubjectTap(Map<String, dynamic> subject) {
    if (_isSelectionMode) {
      _toggleSubjectSelection(subject['id']);
    } else {
      // Navigate to topics view
      Navigator.pushNamed(
        context,
        '/topics-view',
        arguments: {
          'subjectId': subject['id'],
          'subjectName': subject['name'],
          'goalName': _goalName,
        },
      );
    }
  }

  void _handleSubjectLongPress(Map<String, dynamic> subject) {
    if (!_isSelectionMode) {
      setState(() {
        _isSelectionMode = true;
        _selectedSubjects.add(subject['id']);
      });
    }
  }

  void _toggleSubjectSelection(int subjectId) {
    setState(() {
      if (_selectedSubjects.contains(subjectId)) {
        _selectedSubjects.remove(subjectId);
        if (_selectedSubjects.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedSubjects.add(subjectId);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedSubjects.clear();
    });
  }

  void _showAddSubjectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddSubjectDialogWidget(
          onAddSubject: _handleAddSubject,
        );
      },
    );
  }

  void _handleAddSubject(String name, String description) {
    final newSubject = {
      'id': _allSubjects.length + 1,
      'name': name,
      'description': description,
      'topicCount': 0,
      'completionPercentage': 0.0,
      'lastActivity': 'Just created',
      'createdAt': DateTime.now(),
    };

    setState(() {
      _allSubjects.add(newSubject);
      _filteredSubjects = List.from(_allSubjects);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subject "$name" added successfully'),
        action: SnackBarAction(
          label: 'Add Topics',
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/topics-view',
              arguments: {
                'subjectId': newSubject['id'],
                'subjectName': newSubject['name'],
                'goalName': _goalName,
              },
            );
          },
        ),
      ),
    );
  }

  void _handleEditSubject(Map<String, dynamic> subject) {
    // Show edit dialog (similar to add dialog but pre-filled)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit subject: ${subject['name']}')),
    );
  }

  void _handleViewStatistics(Map<String, dynamic> subject) {
    // Navigate to statistics view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Statistics for: ${subject['name']}')),
    );
  }

  void _handleShareSubject(Map<String, dynamic> subject) {
    // Share subject functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing: ${subject['name']}')),
    );
  }

  void _handleDeleteSubject(Map<String, dynamic> subject) {
    setState(() {
      _allSubjects.removeWhere((s) => s['id'] == subject['id']);
      _filteredSubjects = List.from(_allSubjects);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subject "${subject['name']}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allSubjects.add(subject);
              _filteredSubjects = List.from(_allSubjects);
            });
          },
        ),
      ),
    );
  }

  void _handleBulkDelete() {
    final selectedCount = _selectedSubjects.length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Subjects'),
          content: Text(
            'Are you sure you want to delete $selectedCount ${selectedCount == 1 ? 'subject' : 'subjects'}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performBulkDelete();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _performBulkDelete() {
    final deletedSubjects =
        _allSubjects.where((s) => _selectedSubjects.contains(s['id'])).toList();

    setState(() {
      _allSubjects.removeWhere((s) => _selectedSubjects.contains(s['id']));
      _filteredSubjects = List.from(_allSubjects);
      _isSelectionMode = false;
      _selectedSubjects.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedSubjects.length} subjects deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allSubjects.addAll(deletedSubjects);
              _filteredSubjects = List.from(_allSubjects);
            });
          },
        ),
      ),
    );
  }

  void _handleBulkArchive() {
    final selectedCount = _selectedSubjects.length;

    setState(() {
      _isSelectionMode = false;
      _selectedSubjects.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '$selectedCount ${selectedCount == 1 ? 'subject' : 'subjects'} archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Restore from archive
          },
        ),
      ),
    );
  }
}
