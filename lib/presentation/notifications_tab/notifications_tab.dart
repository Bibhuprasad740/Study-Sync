import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_notifications_widget.dart';
import './widgets/notification_card_widget.dart';
import './widgets/notifications_header_widget.dart';
import './widgets/notifications_segmented_control.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({Key? key}) : super(key: key);

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late PageController _pageController;
  int _currentSegmentIndex = 0;
  List<Map<String, dynamic>> _allNotifications = [];
  List<Map<String, dynamic>> _revisionNotifications = [];
  List<Map<String, dynamic>> _achievementNotifications = [];
  List<Map<String, dynamic>> _systemNotifications = [];
  bool _isLoading = false;
  int _unreadCount = 0;

  // Mock notifications data
  final List<Map<String, dynamic>> _mockNotifications = [
    {
      "id": 1,
      "type": "revision",
      "title": "Arrays and Strings - Revision Due",
      "description": "Your spaced repetition session is ready",
      "timestamp": DateTime.now().subtract(Duration(minutes: 15)),
      "isRead": false,
      "topicId": 1,
      "topicTitle": "Arrays and Strings",
      "subjectTitle": "Data Structures",
      "priority": "high",
      "actionUrl": "/topics-view",
    },
    {
      "id": 2,
      "type": "achievement",
      "title": "Week Streak Achieved! 🎉",
      "description": "You've completed revisions for 7 days straight",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "isRead": false,
      "achievementType": "streak",
      "streakDays": 7,
      "points": 100,
      "badge": "week_warrior",
    },
    {
      "id": 3,
      "type": "revision",
      "title": "Binary Trees - Due Tomorrow",
      "description": "Upcoming revision session in 18 hours",
      "timestamp": DateTime.now().subtract(Duration(hours: 6)),
      "isRead": true,
      "topicId": 3,
      "topicTitle": "Binary Trees",
      "subjectTitle": "Data Structures",
      "priority": "medium",
      "actionUrl": "/topics-view",
    },
    {
      "id": 4,
      "type": "system",
      "title": "StudySync Updated",
      "description": "New features: Topic statistics and progress analytics",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "isRead": true,
      "updateVersion": "2.1.0",
      "featureHighlights": [
        "Statistics Dashboard",
        "Progress Analytics",
        "Export Options"
      ],
    },
    {
      "id": 5,
      "type": "achievement",
      "title": "Subject Master! 📚",
      "description": "You've completed all topics in Data Structures",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "isRead": false,
      "achievementType": "subject_completion",
      "subjectTitle": "Data Structures",
      "completionRate": 100,
      "points": 250,
      "badge": "subject_master",
    },
    {
      "id": 6,
      "type": "revision",
      "title": "Dynamic Programming - Overdue",
      "description": "This revision was scheduled 12 hours ago",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "isRead": true,
      "topicId": 4,
      "topicTitle": "Dynamic Programming",
      "subjectTitle": "Algorithms",
      "priority": "high",
      "isOverdue": true,
      "actionUrl": "/topics-view",
    },
    {
      "id": 7,
      "type": "system",
      "title": "Backup Reminder",
      "description": "Your study data was last backed up 7 days ago",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "isRead": false,
      "actionType": "backup_reminder",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadNotifications();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 500));

    _allNotifications = List<Map<String, dynamic>>.from(_mockNotifications);

    // Sort by timestamp (newest first)
    _allNotifications.sort((a, b) =>
        (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    // Categorize notifications
    _revisionNotifications =
        _allNotifications.where((n) => n['type'] == 'revision').toList();

    _achievementNotifications =
        _allNotifications.where((n) => n['type'] == 'achievement').toList();

    _systemNotifications =
        _allNotifications.where((n) => n['type'] == 'system').toList();

    // Count unread notifications
    _unreadCount =
        _allNotifications.where((n) => !(n['isRead'] as bool)).length;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshNotifications() async {
    HapticFeedback.lightImpact();
    await _loadNotifications();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notifications updated'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _onSegmentChanged(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentSegmentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentSegmentIndex = index;
    });
  }

  List<Map<String, dynamic>> _getCurrentNotifications() {
    switch (_currentSegmentIndex) {
      case 0:
        return _revisionNotifications;
      case 1:
        return _achievementNotifications;
      case 2:
        return _systemNotifications;
      default:
        return [];
    }
  }

  String _getCurrentTitle() {
    switch (_currentSegmentIndex) {
      case 0:
        return 'Revision Alerts';
      case 1:
        return 'Achievements';
      case 2:
        return 'System Updates';
      default:
        return 'Notifications';
    }
  }

  void _markAsRead(Map<String, dynamic> notification) {
    if (notification['isRead'] as bool) return;

    HapticFeedback.lightImpact();
    setState(() {
      notification['isRead'] = true;
      _unreadCount =
          _allNotifications.where((n) => !(n['isRead'] as bool)).length;
    });
  }

  void _deleteNotification(Map<String, dynamic> notification) {
    HapticFeedback.mediumImpact();
    setState(() {
      _allNotifications.removeWhere((n) => n['id'] == notification['id']);
      _revisionNotifications.removeWhere((n) => n['id'] == notification['id']);
      _achievementNotifications
          .removeWhere((n) => n['id'] == notification['id']);
      _systemNotifications.removeWhere((n) => n['id'] == notification['id']);

      if (!(notification['isRead'] as bool)) {
        _unreadCount--;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // TODO: Implement undo functionality
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onNotificationTap(Map<String, dynamic> notification) {
    _markAsRead(notification);

    // Navigate based on notification type
    switch (notification['type']) {
      case 'revision':
        final actionUrl = notification['actionUrl'] as String?;
        if (actionUrl != null) {
          Navigator.pushNamed(context, actionUrl, arguments: {
            'topicId': notification['topicId'],
            'subjectTitle': notification['subjectTitle'],
          });
        }
        break;
      case 'achievement':
        // TODO: Show achievement detail modal
        _showAchievementDetail(notification);
        break;
      case 'system':
        // TODO: Handle system notification actions
        _handleSystemNotification(notification);
        break;
    }
  }

  void _showAchievementDetail(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🎉 Achievement Unlocked!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.successLight.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'military_tech',
                size: 32,
                color: AppTheme.successLight,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              notification['title'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              notification['description'] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${notification['points']} points',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.successLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Share Achievement'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  void _handleSystemNotification(Map<String, dynamic> notification) {
    // TODO: Implement system notification actions
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('System notification action coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _markAllAsRead() {
    HapticFeedback.lightImpact();
    final currentNotifications = _getCurrentNotifications();
    setState(() {
      for (var notification in currentNotifications) {
        notification['isRead'] = true;
      }
      _unreadCount =
          _allNotifications.where((n) => !(n['isRead'] as bool)).length;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSettings() {
    HapticFeedback.lightImpact();
    // TODO: Show notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification settings coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentNotifications = _getCurrentNotifications();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            NotificationsHeaderWidget(
              unreadCount: _unreadCount,
              onSettingsTap: _showSettings,
              onMarkAllRead:
                  currentNotifications.any((n) => !(n['isRead'] as bool))
                      ? _markAllAsRead
                      : null,
            ),

            // Segmented Control
            NotificationsSegmentedControl(
              currentIndex: _currentSegmentIndex,
              onChanged: _onSegmentChanged,
              revisionCount: _revisionNotifications
                  .where((n) => !(n['isRead'] as bool))
                  .length,
              achievementCount: _achievementNotifications
                  .where((n) => !(n['isRead'] as bool))
                  .length,
              systemCount: _systemNotifications
                  .where((n) => !(n['isRead'] as bool))
                  .length,
            ),

            // Main Content
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    )
                  : PageView(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      children: [
                        // Revision Alerts
                        _buildNotificationList(_revisionNotifications),
                        // Achievements
                        _buildNotificationList(_achievementNotifications),
                        // System Updates
                        _buildNotificationList(_systemNotifications),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return EmptyNotificationsWidget(
        title: 'No ${_getCurrentTitle()}',
        description: 'You\'re all caught up! Check back later for updates.',
        iconName: _currentSegmentIndex == 0
            ? 'notifications_active'
            : _currentSegmentIndex == 1
                ? 'emoji_events'
                : 'info',
      );
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshNotifications,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 2.h),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationCardWidget(
            notification: notification,
            onTap: () => _onNotificationTap(notification),
            onMarkRead: () => _markAsRead(notification),
            onDelete: () => _deleteNotification(notification),
          );
        },
      ),
    );
  }
}
