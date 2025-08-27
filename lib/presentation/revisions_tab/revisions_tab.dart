import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/revision_card_widget.dart';
import './widgets/revision_filter_widget.dart';

class RevisionsTab extends StatefulWidget {
  const RevisionsTab({Key? key}) : super(key: key);

  @override
  State<RevisionsTab> createState() => _RevisionsTabState();
}

class _RevisionsTabState extends State<RevisionsTab>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Today';
  String? _selectedSubject;
  Set<int> _selectedRevisions = {};
  Map<int, bool> _expandedCards = {};
  bool _isLoading = false;

  // Mock data for revisions
  final List<Map<String, dynamic>> _allRevisions = [
    {
      "id": 1,
      "topicTitle": "Data Structures and Algorithms",
      "subjectName": "Computer Science",
      "dueDate": "Today",
      "daysOverdue": 0,
      "cycleNumber": 3,
      "notes":
          "Focus on time complexity analysis and space optimization techniques. Review sorting algorithms and their applications.",
      "lastCompleted": "3 days ago",
      "createdDate": DateTime.now().subtract(Duration(days: 21)),
      "isCompleted": false,
      "difficulty": "Hard",
    },
    {
      "id": 2,
      "topicTitle": "Organic Chemistry Reactions",
      "subjectName": "Chemistry",
      "dueDate": "Today",
      "daysOverdue": 0,
      "cycleNumber": 2,
      "notes":
          "Review mechanism of SN1 and SN2 reactions. Practice identifying reaction products.",
      "lastCompleted": "7 days ago",
      "createdDate": DateTime.now().subtract(Duration(days: 14)),
      "isCompleted": false,
      "difficulty": "Medium",
    },
    {
      "id": 3,
      "topicTitle": "Constitutional Law Principles",
      "subjectName": "Law",
      "dueDate": "Yesterday",
      "daysOverdue": 1,
      "cycleNumber": 1,
      "notes":
          "Study fundamental rights and directive principles. Focus on landmark cases and their implications.",
      "lastCompleted": "Never",
      "createdDate": DateTime.now().subtract(Duration(days: 8)),
      "isCompleted": false,
      "difficulty": "Hard",
    },
    {
      "id": 4,
      "topicTitle": "Calculus Integration Techniques",
      "subjectName": "Mathematics",
      "dueDate": "2 days ago",
      "daysOverdue": 2,
      "cycleNumber": 4,
      "notes":
          "Practice integration by parts and substitution methods. Solve complex definite integrals.",
      "lastCompleted": "20 days ago",
      "createdDate": DateTime.now().subtract(Duration(days: 50)),
      "isCompleted": false,
      "difficulty": "Medium",
    },
    {
      "id": 5,
      "topicTitle": "World War II Timeline",
      "subjectName": "History",
      "dueDate": "Tomorrow",
      "daysOverdue": 0,
      "cycleNumber": 1,
      "notes":
          "Memorize key dates, battles, and political decisions. Focus on causes and consequences.",
      "lastCompleted": "Never",
      "createdDate": DateTime.now().subtract(Duration(days: 6)),
      "isCompleted": false,
      "difficulty": "Easy",
    },
    {
      "id": 6,
      "topicTitle": "Thermodynamics Laws",
      "subjectName": "Physics",
      "dueDate": "Next week",
      "daysOverdue": 0,
      "cycleNumber": 2,
      "notes":
          "Understand the four laws of thermodynamics and their applications in real-world scenarios.",
      "lastCompleted": "14 days ago",
      "createdDate": DateTime.now().subtract(Duration(days: 21)),
      "isCompleted": false,
      "difficulty": "Hard",
    },
  ];

  // Mock statistics
  int _completedToday = 2;
  int _streakCount = 7;
  bool _isPremiumUser = false;
  int _dailyCompletionLimit = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      final filters = ['Today', 'Overdue', 'Upcoming'];
      setState(() {
        _selectedFilter = filters[_tabController.index];
        _selectedRevisions.clear();
      });
    }
  }

  List<Map<String, dynamic>> get _filteredRevisions {
    List<Map<String, dynamic>> filtered = _allRevisions;

    // Filter by time period
    switch (_selectedFilter) {
      case 'Today':
        filtered = filtered
            .where((revision) =>
                revision['dueDate'] == 'Today' && revision['daysOverdue'] == 0)
            .toList();
        break;
      case 'Overdue':
        filtered = filtered
            .where((revision) => (revision['daysOverdue'] as int) > 0)
            .toList();
        break;
      case 'Upcoming':
        filtered = filtered
            .where((revision) =>
                revision['dueDate'] != 'Today' && revision['daysOverdue'] == 0)
            .toList();
        break;
    }

    // Filter by subject if selected
    if (_selectedSubject != null) {
      filtered = filtered
          .where((revision) => revision['subjectName'] == _selectedSubject)
          .toList();
    }

    return filtered;
  }

  List<String> get _availableSubjects {
    return _allRevisions
        .map((revision) => revision['subjectName'] as String)
        .toSet()
        .toList()
      ..sort();
  }

  int get _totalDueToday {
    return _allRevisions
        .where((revision) =>
            revision['dueDate'] == 'Today' && revision['daysOverdue'] == 0)
        .length;
  }

  void _markRevisionComplete(int revisionId) {
    if (!_isPremiumUser && _completedToday >= _dailyCompletionLimit) {
      _showUpgradeDialog();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _completedToday++;
        _isLoading = false;
        _selectedRevisions.remove(revisionId);
      });

      // Show completion feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Revision completed! Great job! 🎉'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _rescheduleRevision(int revisionId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildRescheduleBottomSheet(revisionId),
    );
  }

  void _toggleCardExpansion(int revisionId) {
    setState(() {
      _expandedCards[revisionId] = !(_expandedCards[revisionId] ?? false);
    });
  }

  void _toggleRevisionSelection(int revisionId) {
    setState(() {
      _selectedRevisions.contains(revisionId)
          ? _selectedRevisions.remove(revisionId)
          : _selectedRevisions.add(revisionId);
    });
  }

  void _completeAllSelected() {
    if (!_isPremiumUser &&
        _completedToday + _selectedRevisions.length > _dailyCompletionLimit) {
      _showUpgradeDialog();
      return;
    }

    setState(() {
      _completedToday += _selectedRevisions.length;
      _selectedRevisions.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All selected revisions completed! 🚀'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _rescheduleSelected() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildRescheduleBottomSheet(null),
    );
  }

  void _clearSelection() {
    setState(() {
      _selectedRevisions.clear();
    });
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upgrade to Premium'),
        content: Text(
          'You\'ve reached your daily limit of $_dailyCompletionLimit revision${_dailyCompletionLimit > 1 ? 's' : ''}. Upgrade to Premium for unlimited revisions!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile-tab');
            },
            child: Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshRevisions() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API refresh
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Revisions updated!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final filteredRevisions = _filteredRevisions;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: _buildAppBar(isDarkMode),
      body: Column(
        children: [
          ProgressIndicatorWidget(
            completedToday: _completedToday,
            totalDue: _totalDueToday,
            streakCount: _streakCount,
          ),
          RevisionFilterWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
                _selectedRevisions.clear();
              });
              _tabController
                  .animateTo(['Today', 'Overdue', 'Upcoming'].indexOf(filter));
            },
            subjects: _availableSubjects,
            selectedSubject: _selectedSubject,
            onSubjectChanged: (subject) {
              setState(() {
                _selectedSubject = subject;
                _selectedRevisions.clear();
              });
            },
          ),
          Expanded(
            child: _buildTabBarView(filteredRevisions),
          ),
        ],
      ),
      bottomNavigationBar: QuickActionsWidget(
        hasSelectedItems: _selectedRevisions.isNotEmpty,
        selectedCount: _selectedRevisions.length,
        onCompleteAll: _completeAllSelected,
        onRescheduleSelected: _rescheduleSelected,
        onClearSelection: _clearSelection,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      title: Text(
        'Revisions',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      centerTitle: true,
      actions: [
        if (_totalDueToday > 0)
          Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$_totalDueToday',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: 'Today'),
          Tab(text: 'Overdue'),
          Tab(text: 'Upcoming'),
        ],
      ),
    );
  }

  Widget _buildTabBarView(List<Map<String, dynamic>> filteredRevisions) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildRevisionsList(filteredRevisions, 'Today'),
        _buildRevisionsList(filteredRevisions, 'Overdue'),
        _buildRevisionsList(filteredRevisions, 'Upcoming'),
      ],
    );
  }

  Widget _buildRevisionsList(
      List<Map<String, dynamic>> revisions, String filterType) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.primaryColor,
        ),
      );
    }

    if (revisions.isEmpty) {
      return EmptyStateWidget(
        filterType: filterType,
        streakCount: _streakCount,
        onCreateStudy: () => Navigator.pushNamed(context, '/studies-tab'),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshRevisions,
      color: AppTheme.lightTheme.primaryColor,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 10.h),
        itemCount: revisions.length,
        itemBuilder: (context, index) {
          final revision = revisions[index];
          final revisionId = revision['id'] as int;
          final isSelected = _selectedRevisions.contains(revisionId);
          final isExpanded = _expandedCards[revisionId] ?? false;

          return GestureDetector(
            onLongPress: () => _toggleRevisionSelection(revisionId),
            child: Container(
              decoration: isSelected
                  ? BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppTheme.lightTheme.primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              margin: isSelected
                  ? EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h)
                  : null,
              child: RevisionCardWidget(
                revision: revision,
                isExpanded: isExpanded,
                onTap: () => _toggleCardExpansion(revisionId),
                onMarkComplete: () => _markRevisionComplete(revisionId),
                onReschedule: () => _rescheduleRevision(revisionId),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRescheduleBottomSheet(int? revisionId) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    DateTime selectedDate = DateTime.now().add(Duration(days: 1));

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                revisionId != null
                    ? 'Reschedule Revision'
                    : 'Reschedule Selected',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 3.h),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isDarkMode ? AppTheme.borderDark : AppTheme.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'New Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (date != null) {
                          setModalState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: Text('Change'),
                    ),
                  ],
                ),
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
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Revision rescheduled successfully!'),
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.secondary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        if (revisionId == null) {
                          setState(() {
                            _selectedRevisions.clear();
                          });
                        }
                      },
                      child: Text('Reschedule'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }
}
