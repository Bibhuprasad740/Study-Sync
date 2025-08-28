import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_topics_widget.dart';
import './widgets/topic_card_widget.dart';
import './widgets/topic_detail_modal_widget.dart';
import './widgets/topics_header_widget.dart';
import './widgets/topics_search_widget.dart';

class TopicsView extends StatefulWidget {
  const TopicsView({Key? key}) : super(key: key);

  @override
  State<TopicsView> createState() => _TopicsViewState();
}

class _TopicsViewState extends State<TopicsView> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<Map<String, dynamic>> _topics = [];
  List<Map<String, dynamic>> _filteredTopics = [];
  Map<String, dynamic>? _subjectData;
  bool _isLoading = false;
  bool _isSelectionMode = false;
  Set<int> _selectedTopics = {};

  // Mock topics data
  final List<Map<String, dynamic>> _mockTopics = [
    {
      "id": 1,
      "title": "Arrays and Strings",
      "description": "Fundamental data structures and string manipulation",
      "createdAt": DateTime.now().subtract(Duration(days: 15)),
      "lastStudied": DateTime.now().subtract(Duration(days: 2)),
      "revisionStatus":
          "due", // due, upcoming, completed, overdue "nextRevision": DateTime.now().add(Duration(hours: 6)),
      "completedRevisions": 3,
      "totalRevisions": 5,
      "notes": "Focus on two-pointer technique and sliding window patterns",
      "difficulty": "medium",
      "timeEstimate": 45,
    },
    {
      "id": 2,
      "title": "Linked Lists",
      "description": "Single, double, and circular linked list operations",
      "createdAt": DateTime.now().subtract(Duration(days: 12)),
      "lastStudied": DateTime.now().subtract(Duration(days: 1)),
      "revisionStatus": "completed",
      "nextRevision": DateTime.now().add(Duration(days: 3)),
      "completedRevisions": 4,
      "totalRevisions": 4,
      "notes": "Master fast and slow pointer patterns",
      "difficulty": "easy",
      "timeEstimate": 30,
    },
    {
      "id": 3,
      "title": "Binary Trees",
      "description": "Tree traversal, binary search trees, and balanced trees",
      "createdAt": DateTime.now().subtract(Duration(days: 10)),
      "lastStudied": DateTime.now().subtract(Duration(days: 3)),
      "revisionStatus": "upcoming",
      "nextRevision": DateTime.now().add(Duration(days: 1)),
      "completedRevisions": 2,
      "totalRevisions": 6,
      "notes": "Practice inorder, preorder, and postorder traversals",
      "difficulty": "hard",
      "timeEstimate": 60,
    },
    {
      "id": 4,
      "title": "Dynamic Programming",
      "description": "Memoization and tabulation techniques",
      "createdAt": DateTime.now().subtract(Duration(days: 8)),
      "lastStudied": DateTime.now().subtract(Duration(days: 5)),
      "revisionStatus": "overdue",
      "nextRevision": DateTime.now().subtract(Duration(hours: 12)),
      "completedRevisions": 1,
      "totalRevisions": 8,
      "notes": "Start with 1D DP then move to 2D problems",
      "difficulty": "hard",
      "timeEstimate": 90,
    },
    {
      "id": 5,
      "title": "Hash Tables",
      "description": "Hash functions, collision resolution, and applications",
      "createdAt": DateTime.now().subtract(Duration(days: 5)),
      "lastStudied": null,
      "revisionStatus": "upcoming",
      "nextRevision": DateTime.now().add(Duration(hours: 2)),
      "completedRevisions": 0,
      "totalRevisions": 4,
      "notes": "Focus on practical implementations and time complexity",
      "difficulty": "medium",
      "timeEstimate": 40,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      setState(() {
        _subjectData = args;
      });
      _loadTopics();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTopics() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 600));

    setState(() {
      _topics = List<Map<String, dynamic>>.from(_mockTopics);
      _filteredTopics = List<Map<String, dynamic>>.from(_topics);
      _isLoading = false;
    });

    _applySearch();
  }

  Future<void> _refreshTopics() async {
    HapticFeedback.lightImpact();
    await _loadTopics();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Topics updated'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _applySearch() {
    List<Map<String, dynamic>> filtered =
        List<Map<String, dynamic>>.from(_topics);

    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((topic) {
        final title = (topic['title'] as String? ?? '').toLowerCase();
        final description =
            (topic['description'] as String? ?? '').toLowerCase();
        final notes = (topic['notes'] as String? ?? '').toLowerCase();

        return title.contains(searchTerm) ||
            description.contains(searchTerm) ||
            notes.contains(searchTerm);
      }).toList();
    }

    // Sort by revision status priority and next revision time
    filtered.sort((a, b) {
      final aStatus = a['revisionStatus'] as String;
      final bStatus = b['revisionStatus'] as String;

      // Priority order: overdue > due > upcoming > completed
      final statusPriority = {
        'overdue': 1,
        'due': 2,
        'upcoming': 3,
        'completed': 4,
      };

      final aPriority = statusPriority[aStatus] ?? 5;
      final bPriority = statusPriority[bStatus] ?? 5;

      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }

      // If same status, sort by next revision time
      final aNext = a['nextRevision'] as DateTime?;
      final bNext = b['nextRevision'] as DateTime?;

      if (aNext == null && bNext == null) return 0;
      if (aNext == null) return 1;
      if (bNext == null) return -1;

      return aNext.compareTo(bNext);
    });

    setState(() {
      _filteredTopics = filtered;
    });
  }

  void _onSearchChanged(String value) {
    _applySearch();
  }

  void _onTopicTap(Map<String, dynamic> topic) {
    if (_isSelectionMode) {
      _toggleTopicSelection(topic['id']);
    } else {
      HapticFeedback.lightImpact();
      _showTopicDetailModal(topic);
    }
  }

  void _onTopicLongPress(Map<String, dynamic> topic) {
    HapticFeedback.mediumImpact();
    if (!_isSelectionMode) {
      setState(() {
        _isSelectionMode = true;
        _selectedTopics.add(topic['id']);
      });
    }
  }

  void _toggleTopicSelection(int topicId) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_selectedTopics.contains(topicId)) {
        _selectedTopics.remove(topicId);
      } else {
        _selectedTopics.add(topicId);
      }

      if (_selectedTopics.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedTopics.clear();
    });
  }

  void _showTopicDetailModal(Map<String, dynamic> topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TopicDetailModalWidget(
        topic: topic,
        onEdit: (updatedTopic) => _updateTopic(updatedTopic),
        onMarkComplete: () => _markTopicComplete(topic),
        onReschedule: () => _rescheduleTopicRevision(topic),
      ),
    );
  }

  void _updateTopic(Map<String, dynamic> updatedTopic) {
    setState(() {
      final index = _topics.indexWhere((t) => t['id'] == updatedTopic['id']);
      if (index != -1) {
        _topics[index] = updatedTopic;
      }
    });
    _applySearch();
  }

  void _markTopicComplete(Map<String, dynamic> topic) {
    HapticFeedback.lightImpact();
    setState(() {
      final index = _topics.indexWhere((t) => t['id'] == topic['id']);
      if (index != -1) {
        _topics[index]['revisionStatus'] = 'completed';
        _topics[index]['lastStudied'] = DateTime.now();
        _topics[index]['completedRevisions'] =
            (_topics[index]['completedRevisions'] as int) + 1;
      }
    });
    _applySearch();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Topic "${topic['title']}" marked as complete'),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _rescheduleTopicRevision(Map<String, dynamic> topic) {
    HapticFeedback.lightImpact();
    // TODO: Implement reschedule functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reschedule functionality coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteSelectedTopics() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Topics'),
        content: Text(
            'Are you sure you want to delete ${_selectedTopics.length} topic(s)? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _topics.removeWhere(
                    (topic) => _selectedTopics.contains(topic['id']));
              });
              _applySearch();
              _exitSelectionMode();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_selectedTopics.length} topics deleted'),
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

  void _rescheduleSelectedTopics() {
    HapticFeedback.lightImpact();
    // TODO: Implement bulk reschedule
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bulk reschedule functionality coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddTopicDialog() {
    HapticFeedback.mediumImpact();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Topic'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Topic Title',
                hintText: 'Enter topic title',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter topic description',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                final newTopic = {
                  "id": _topics.length + 1,
                  "title": titleController.text.trim(),
                  "description": descriptionController.text.trim(),
                  "createdAt": DateTime.now(),
                  "lastStudied": null,
                  "revisionStatus": "upcoming",
                  "nextRevision": DateTime.now().add(Duration(days: 1)),
                  "completedRevisions": 0,
                  "totalRevisions": 4,
                  "notes": "",
                  "difficulty": "medium",
                  "timeEstimate": 30,
                };

                setState(() {
                  _topics.insert(0, newTopic);
                });
                _applySearch();
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Topic "${newTopic['title']}" added successfully!'),
                    backgroundColor: AppTheme.successLight,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text('Add Topic'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjectName = _subjectData?['name'] ?? 'Unknown Subject';
    final goalName = _subjectData?['goalName'] ?? 'Unknown Goal';

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
        leading: _isSelectionMode
            ? IconButton(
                onPressed: _exitSelectionMode,
                icon: CustomIconWidget(
                  iconName: 'close',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              )
            : IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
        title: _isSelectionMode
            ? Text('${_selectedTopics.length} selected')
            : null,
        actions: _isSelectionMode
            ? [
                IconButton(
                  onPressed: _rescheduleSelectedTopics,
                  icon: CustomIconWidget(
                    iconName: 'schedule',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: _deleteSelectedTopics,
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    size: 24,
                    color: AppTheme.errorLight,
                  ),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    // TODO: Implement topic statistics
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Topic statistics coming soon!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'bar_chart',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Breadcrumb and Header
            if (!_isSelectionMode)
              TopicsHeaderWidget(
                goalName: goalName,
                subjectName: subjectName,
                topicCount: _filteredTopics.length,
              ),

            // Search Bar
            if (!_isSelectionMode)
              TopicsSearchWidget(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),

            // Main Content
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    )
                  : _filteredTopics.isEmpty
                      ? _topics.isEmpty
                          ? EmptyTopicsWidget(onAddTopic: _showAddTopicDialog)
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
                                      'No topics match your search',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'Try adjusting your search terms',
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
                          onRefresh: _refreshTopics,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 2.h),
                            itemCount: _filteredTopics.length,
                            itemBuilder: (context, index) {
                              final topic = _filteredTopics[index];
                              final isSelected =
                                  _selectedTopics.contains(topic['id']);

                              return TopicCardWidget(
                                topic: topic,
                                isSelected: isSelected,
                                isSelectionMode: _isSelectionMode,
                                onTap: () => _onTopicTap(topic),
                                onLongPress: () => _onTopicLongPress(topic),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton(
              onPressed: _showAddTopicDialog,
              child: CustomIconWidget(
                iconName: 'add',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
              tooltip: 'Add New Topic',
            ),
    );
  }
}
