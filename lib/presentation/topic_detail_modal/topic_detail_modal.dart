import 'package:flutter/material.dart';

import './widgets/notes_editor_widget.dart';
import './widgets/revision_history_widget.dart';
import './widgets/topic_content_widget.dart';
import './widgets/topic_header_widget.dart';
import './widgets/topic_statistics_widget.dart';

class TopicDetailModal extends StatefulWidget {
  const TopicDetailModal({super.key});

  @override
  State<TopicDetailModal> createState() => _TopicDetailModalState();
}

class _TopicDetailModalState extends State<TopicDetailModal>
    with TickerProviderStateMixin {
  String? topicId;
  String topicTitle = '';
  bool isEditMode = false;
  bool isLoading = false;
  bool hasUnsavedChanges = false;

  // Tab controller for sections
  late TabController _tabController;

  // Controllers for edit mode
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;

  // Mock data
  Map<String, dynamic> topicData = {
    'title': 'Neural Networks & Deep Learning',
    'description':
        'Comprehensive study of artificial neural networks, including feedforward networks, backpropagation, convolutional neural networks, and recurrent neural networks.',
    'notes':
        'Key concepts:\n• Perceptron model\n• Gradient descent optimization\n• Activation functions (ReLU, Sigmoid, Tanh)\n• Regularization techniques\n• CNN architectures\n• LSTM and GRU networks',
    'subject': 'Machine Learning',
    'completionRate': 75.0,
    'averagePerformance': 8.5,
    'streak': 12,
    'lastReviewed': '2025-01-25',
    'nextReview': '2025-01-28',
    'revisionHistory': [
      {
        'date': '2025-01-25',
        'performance': 9.0,
        'duration': 45,
        'notes': 'Great understanding of CNN architectures'
      },
      {
        'date': '2025-01-22',
        'performance': 8.0,
        'duration': 38,
        'notes': 'Need more practice with RNN implementations'
      },
      {
        'date': '2025-01-19',
        'performance': 7.5,
        'duration': 42,
        'notes': 'Backpropagation algorithm concepts clear'
      },
    ],
    'attachments': [
      {
        'name': 'neural_network_diagram.png',
        'type': 'image',
        'url':
            'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400&h=300&fit=crop',
        'size': '245 KB'
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _titleController = TextEditingController(text: topicData['title']);
    _descriptionController =
        TextEditingController(text: topicData['description']);
    _notesController = TextEditingController(text: topicData['notes']);

    _setupControllerListeners();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      topicId = args['topicId'] as String?;
      topicTitle = args['title'] as String? ?? 'Topic Details';
    }
  }

  void _setupControllerListeners() {
    void onTextChanged() {
      if (isEditMode && !hasUnsavedChanges) {
        setState(() => hasUnsavedChanges = true);
      }
    }

    _titleController.addListener(onTextChanged);
    _descriptionController.addListener(onTextChanged);
    _notesController.addListener(onTextChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    if (isEditMode && hasUnsavedChanges) {
      _showSaveConfirmationDialog();
    } else {
      setState(() {
        isEditMode = !isEditMode;
        hasUnsavedChanges = false;
      });
    }
  }

  void _showSaveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Changes?',
              style: Theme.of(context).textTheme.titleMedium),
          content: Text(
            'You have unsaved changes. Do you want to save them?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _discardChanges();
              },
              child: Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveChanges();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() async {
    setState(() => isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      topicData['title'] = _titleController.text;
      topicData['description'] = _descriptionController.text;
      topicData['notes'] = _notesController.text;
      isEditMode = false;
      hasUnsavedChanges = false;
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Topic updated successfully'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _discardChanges() {
    setState(() {
      _titleController.text = topicData['title'];
      _descriptionController.text = topicData['description'];
      _notesController.text = topicData['notes'];
      isEditMode = false;
      hasUnsavedChanges = false;
    });
  }

  void _showMoreActionsMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildActionItem(Icons.copy_outlined, 'Duplicate Topic', () {
                Navigator.pop(context);
                _duplicateTopic();
              }),
              _buildActionItem(
                  Icons.drive_file_move_outlined, 'Move to Subject', () {
                Navigator.pop(context);
                _moveToSubject();
              }),
              _buildActionItem(Icons.share_outlined, 'Share Topic', () {
                Navigator.pop(context);
                _shareTopic();
              }),
              Divider(),
              _buildActionItem(Icons.delete_outline, 'Delete Topic', () {
                Navigator.pop(context);
                _deleteTopic();
              }, isDestructive: true),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Theme.of(context).colorScheme.error : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Theme.of(context).colorScheme.error : null,
        ),
      ),
      onTap: onTap,
    );
  }

  void _duplicateTopic() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Topic duplicated successfully')),
    );
  }

  void _moveToSubject() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Move to subject functionality')),
    );
  }

  void _shareTopic() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share functionality')),
    );
  }

  void _deleteTopic() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Topic'),
          content: Text(
              'Are you sure you want to delete this topic? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Topic deleted')),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (hasUnsavedChanges) {
      final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Discard Changes?'),
            content: Text(
                'You have unsaved changes. Are you sure you want to leave?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Discard'),
              ),
            ],
          );
        },
      );
      return result ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && hasUnsavedChanges) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode
              ? 'Edit Topic'
              : topicTitle.isNotEmpty
                  ? topicTitle
                  : 'Topic Details'),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              if (hasUnsavedChanges) {
                final shouldPop = await _onWillPop();
                if (shouldPop && context.mounted) {
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            if (isEditMode) ...[
              if (hasUnsavedChanges)
                TextButton(
                  onPressed: isLoading ? null : _saveChanges,
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Save'),
                ),
            ] else ...[
              IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: _toggleEditMode,
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: _showMoreActionsMenu,
              ),
            ],
          ],
        ),
        body: Column(
          children: [
            TopicHeaderWidget(
              title: topicData['title'],
              subject: topicData['subject'],
              completionRate: topicData['completionRate'],
              isEditMode: isEditMode,
              titleController: _titleController,
            ),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Overview'),
                Tab(text: 'Notes'),
                Tab(text: 'History'),
                Tab(text: 'Stats'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TopicContentWidget(
                    description: topicData['description'],
                    attachments: List<Map<String, dynamic>>.from(
                        topicData['attachments']),
                    isEditMode: isEditMode,
                    descriptionController: _descriptionController,
                  ),
                  NotesEditorWidget(
                    notes: topicData['notes'],
                    isEditMode: isEditMode,
                    notesController: _notesController,
                  ),
                  RevisionHistoryWidget(
                    revisionHistory: List<Map<String, dynamic>>.from(
                        topicData['revisionHistory']),
                    nextReview: topicData['nextReview'],
                  ),
                  TopicStatisticsWidget(
                    completionRate: topicData['completionRate'],
                    averagePerformance: topicData['averagePerformance'],
                    streak: topicData['streak'],
                    lastReviewed: topicData['lastReviewed'],
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _tabController.index == 1 && !isEditMode
            ? FloatingActionButton(
                onPressed: () {
                  setState(() => isEditMode = true);
                  _tabController.animateTo(1);
                },
                child: Icon(Icons.add),
                tooltip: 'Add Note',
              )
            : null,
      ),
    );
  }
}
