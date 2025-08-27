import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_modal.dart';
import './widgets/goal_card_widget.dart';
import './widgets/goal_creation_modal.dart';
import './widgets/search_bar_widget.dart';

class StudiesTab extends StatefulWidget {
  const StudiesTab({Key? key}) : super(key: key);

  @override
  State<StudiesTab> createState() => _StudiesTabState();
}

class _StudiesTabState extends State<StudiesTab> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<Map<String, dynamic>> _goals = [];
  List<Map<String, dynamic>> _filteredGoals = [];
  Map<String, dynamic> _currentFilters = {
    'completion': null,
    'sort': null,
  };
  bool _isLoading = false;
  int _currentBottomNavIndex = 0;

  // Mock data for goals
  final List<Map<String, dynamic>> _mockGoals = [
    {
      "id": 1,
      "title": "GATE Computer Science 2025",
      "description":
          "Comprehensive preparation for GATE CS examination covering all core subjects",
      "subjects": [
        {"id": 1, "name": "Data Structures", "topicCount": 15},
        {"id": 2, "name": "Algorithms", "topicCount": 12},
        {"id": 3, "name": "Operating Systems", "topicCount": 10},
        {"id": 4, "name": "Database Management", "topicCount": 8},
      ],
      "completionPercentage": 65.5,
      "lastStudied": "2 days ago",
      "createdAt": DateTime.now().subtract(Duration(days: 30)),
      "totalTopics": 45,
      "completedTopics": 29,
    },
    {
      "id": 2,
      "title": "Machine Learning Fundamentals",
      "description":
          "Building strong foundation in ML concepts and practical implementation",
      "subjects": [
        {"id": 5, "name": "Linear Algebra", "topicCount": 8},
        {"id": 6, "name": "Statistics", "topicCount": 10},
        {"id": 7, "name": "Python for ML", "topicCount": 12},
      ],
      "completionPercentage": 32.0,
      "lastStudied": "1 week ago",
      "createdAt": DateTime.now().subtract(Duration(days: 15)),
      "totalTopics": 30,
      "completedTopics": 10,
    },
    {
      "id": 3,
      "title": "AWS Cloud Practitioner",
      "description":
          "Preparation for AWS Cloud Practitioner certification exam",
      "subjects": [
        {"id": 8, "name": "Cloud Concepts", "topicCount": 6},
        {"id": 9, "name": "AWS Services", "topicCount": 20},
        {"id": 10, "name": "Security", "topicCount": 8},
        {"id": 11, "name": "Pricing", "topicCount": 4},
      ],
      "completionPercentage": 88.2,
      "lastStudied": "Yesterday",
      "createdAt": DateTime.now().subtract(Duration(days: 60)),
      "totalTopics": 38,
      "completedTopics": 34,
    },
    {
      "id": 4,
      "title": "Data Science with Python",
      "description":
          "Complete data science workflow from data collection to model deployment",
      "subjects": [
        {"id": 12, "name": "Pandas", "topicCount": 15},
        {"id": 13, "name": "NumPy", "topicCount": 10},
        {"id": 14, "name": "Matplotlib", "topicCount": 8},
        {"id": 15, "name": "Scikit-learn", "topicCount": 18},
      ],
      "completionPercentage": 0.0,
      "lastStudied": "Never",
      "createdAt": DateTime.now().subtract(Duration(days: 5)),
      "totalTopics": 51,
      "completedTopics": 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGoals() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      _goals = List<Map<String, dynamic>>.from(_mockGoals);
      _filteredGoals = List<Map<String, dynamic>>.from(_goals);
      _isLoading = false;
    });

    _applyFiltersAndSearch();
  }

  Future<void> _refreshGoals() async {
    HapticFeedback.lightImpact();
    await _loadGoals();
  }

  void _applyFiltersAndSearch() {
    List<Map<String, dynamic>> filtered =
        List<Map<String, dynamic>>.from(_goals);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((goal) {
        final title = (goal['title'] as String? ?? '').toLowerCase();
        final description =
            (goal['description'] as String? ?? '').toLowerCase();
        final subjects = (goal['subjects'] as List?)
                ?.map((s) => (s['name'] as String? ?? '').toLowerCase())
                .join(' ') ??
            '';

        return title.contains(searchTerm) ||
            description.contains(searchTerm) ||
            subjects.contains(searchTerm);
      }).toList();
    }

    // Apply completion filter
    if (_currentFilters['completion'] != null) {
      switch (_currentFilters['completion']) {
        case 'not_started':
          filtered = filtered
              .where((goal) => (goal['completionPercentage'] as num?) == 0)
              .toList();
          break;
        case 'in_progress':
          filtered = filtered.where((goal) {
            final completion = (goal['completionPercentage'] as num?) ?? 0;
            return completion > 0 && completion < 100;
          }).toList();
          break;
        case 'completed':
          filtered = filtered
              .where((goal) => (goal['completionPercentage'] as num?) == 100)
              .toList();
          break;
      }
    }

    // Apply sorting
    switch (_currentFilters['sort']) {
      case 'recent':
        filtered.sort((a, b) =>
            (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime));
        break;
      case 'alphabetical':
        filtered.sort(
            (a, b) => (a['title'] as String).compareTo(b['title'] as String));
        break;
      case 'progress':
        filtered.sort((a, b) => (b['completionPercentage'] as num)
            .compareTo(a['completionPercentage'] as num));
        break;
      case 'last_studied':
        filtered.sort((a, b) {
          final aLastStudied = a['lastStudied'] as String;
          final bLastStudied = b['lastStudied'] as String;
          if (aLastStudied == 'Never' && bLastStudied == 'Never') return 0;
          if (aLastStudied == 'Never') return 1;
          if (bLastStudied == 'Never') return -1;
          return 0; // For simplicity, keeping same order for non-"Never" items
        });
        break;
      default:
        filtered.sort((a, b) =>
            (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime));
    }

    setState(() {
      _filteredGoals = filtered;
    });
  }

  void _onSearchChanged(String value) {
    _applyFiltersAndSearch();
  }

  void _showFilterModal() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModal(
        currentFilters: _currentFilters,
        onApplyFilters: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _applyFiltersAndSearch();
        },
      ),
    );
  }

  void _showGoalCreationModal() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GoalCreationModal(
        onCreateGoal: _createNewGoal,
      ),
    );
  }

  void _createNewGoal(String title, String description) {
    final newGoal = {
      "id": _goals.length + 1,
      "title": title,
      "description": description,
      "subjects": <Map<String, dynamic>>[],
      "completionPercentage": 0.0,
      "lastStudied": "Never",
      "createdAt": DateTime.now(),
      "totalTopics": 0,
      "completedTopics": 0,
    };

    setState(() {
      _goals.insert(0, newGoal);
    });

    _applyFiltersAndSearch();
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Goal "$title" created successfully!'),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onGoalTap(Map<String, dynamic> goal) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/subjects-view', arguments: goal);
  }

  void _onGoalLongPress(Map<String, dynamic> goal) {
    HapticFeedback.mediumImpact();
    // Long press handled by popup menu in GoalCardWidget
  }

  void _editGoal(Map<String, dynamic> goal) {
    HapticFeedback.lightImpact();
    // TODO: Implement goal editing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit goal functionality coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteGoal(Map<String, dynamic> goal) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Goal'),
        content: Text(
            'Are you sure you want to delete "${goal['title']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _goals.removeWhere((g) => g['id'] == goal['id']);
              });
              _applyFiltersAndSearch();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Goal "${goal['title']}" deleted'),
                  backgroundColor: AppTheme.errorLight,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorLight),
            ),
          ),
        ],
      ),
    );
  }

  void _shareGoal(Map<String, dynamic> goal) {
    HapticFeedback.lightImpact();
    // TODO: Implement goal sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share goal functionality coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showGoalStatistics(Map<String, dynamic> goal) {
    HapticFeedback.lightImpact();
    // TODO: Implement goal statistics
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Goal statistics functionality coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentBottomNavIndex) return;

    HapticFeedback.lightImpact();

    switch (index) {
      case 0:
        // Already on Studies tab
        break;
      case 1:
        Navigator.pushNamed(context, '/revisions-tab');
        break;
      case 2:
        // TODO: Navigate to notifications tab
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notifications tab coming soon!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-tab');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'StudySync',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement notifications
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Notifications coming soon!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: CustomIconWidget(
                      iconName: 'notifications_outlined',
                      size: 24,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onFilterTap: _showFilterModal,
            ),

            // Main Content
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    )
                  : _filteredGoals.isEmpty
                      ? _goals.isEmpty
                          ? EmptyStateWidget(
                              onCreateGoal: _showGoalCreationModal)
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'search_off',
                                      size: 48,
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'No goals match your search',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'Try adjusting your search terms or filters',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                      : RefreshIndicator(
                          key: _refreshIndicatorKey,
                          onRefresh: _refreshGoals,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 2.h),
                            itemCount: _filteredGoals.length,
                            itemBuilder: (context, index) {
                              final goal = _filteredGoals[index];
                              return GoalCardWidget(
                                goal: goal,
                                onTap: () => _onGoalTap(goal),
                                onLongPress: () => _onGoalLongPress(goal),
                                onEdit: () => _editGoal(goal),
                                onDelete: () => _deleteGoal(goal),
                                onShare: () => _shareGoal(goal),
                                onStatistics: () => _showGoalStatistics(goal),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showGoalCreationModal,
        child: CustomIconWidget(
          iconName: 'add',
          size: 24,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
        tooltip: 'Create New Goal',
      ),
    );
  }
}
