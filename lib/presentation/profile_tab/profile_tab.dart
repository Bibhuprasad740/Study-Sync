import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/analytics_card.dart';
import './widgets/settings_section.dart';
import './widgets/subscription_status_card.dart';
import './widgets/user_info_card.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int _currentIndex = 3; // Profile tab is active

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
    "isPremium": false,
    "studyStreak": 12,
    "completionRate": 78,
    "joinDate": "2024-01-15",
  };

  // Mock subscription data
  final Map<String, dynamic> subscriptionData = {
    "isPremium": false,
    "planName": "Free Plan",
    "nextBilling": "N/A",
    "price": "\$0.00",
  };

  // Mock analytics data
  final Map<String, dynamic> analyticsData = {
    "totalTopics": 45,
    "completedRevisions": 128,
    "pendingRevisions": 12,
    "weeklyProgress": [65, 72, 68, 85, 78, 92, 88],
    "monthlyStreak": 18,
    "averageScore": 82.5,
  };

  // Mock notification settings
  bool _dailyReminders = true;
  bool _achievementNotifications = true;
  bool _weeklyReports = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _showHelpDialog,
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Card
              UserInfoCard(userData: userData),

              // Subscription Status Card
              SubscriptionStatusCard(
                subscriptionData: subscriptionData,
                onUpgradeTap: _showUpgradeDialog,
                onManageTap: _showManageSubscriptionDialog,
              ),

              // Analytics Card
              AnalyticsCard(
                analyticsData: analyticsData,
                onTap: _showDetailedAnalytics,
              ),

              // Account Settings Section
              SettingsSection(
                title: "Account",
                items: [
                  {
                    "title": "Edit Profile",
                    "subtitle": "Update your personal information",
                    "icon": "person",
                    "iconColor": AppTheme.lightTheme.colorScheme.primary,
                    "action": "edit_profile",
                  },
                  {
                    "title": "Change Password",
                    "subtitle": "Update your account password",
                    "icon": "lock",
                    "iconColor": AppTheme.lightTheme.colorScheme.secondary,
                    "action": "change_password",
                  },
                  {
                    "title": "Subscription Management",
                    "subtitle": subscriptionData["isPremium"] as bool
                        ? "Manage your premium plan"
                        : "Upgrade to premium",
                    "icon": "workspace_premium",
                    "iconColor": Colors.orange,
                    "action": "subscription",
                  },
                ],
                onItemTap: _handleAccountAction,
              ),

              // Study Settings Section
              SettingsSection(
                title: "Study Settings",
                items: [
                  {
                    "title": "Revision Intervals",
                    "subtitle": "Customize your spaced repetition schedule",
                    "icon": "schedule",
                    "iconColor": AppTheme.lightTheme.colorScheme.primary,
                    "action": "revision_intervals",
                  },
                  {
                    "title": "Daily Reminders",
                    "subtitle": "Get notified about pending revisions",
                    "icon": "notifications",
                    "iconColor": AppTheme.lightTheme.colorScheme.secondary,
                    "action": "daily_reminders",
                    "hasSwitch": true,
                    "switchValue": _dailyReminders,
                  },
                  {
                    "title": "Achievement Notifications",
                    "subtitle": "Celebrate your study milestones",
                    "icon": "emoji_events",
                    "iconColor": Colors.orange,
                    "action": "achievement_notifications",
                    "hasSwitch": true,
                    "switchValue": _achievementNotifications,
                  },
                  {
                    "title": "Weekly Reports",
                    "subtitle": "Receive weekly progress summaries",
                    "icon": "assessment",
                    "iconColor": AppTheme.lightTheme.colorScheme.primary,
                    "action": "weekly_reports",
                    "hasSwitch": true,
                    "switchValue": _weeklyReports,
                  },
                ],
                onItemTap: _handleStudySettingsAction,
              ),

              // Data & Privacy Section
              SettingsSection(
                title: "Data & Privacy",
                items: [
                  {
                    "title": "Export Data",
                    "subtitle": "Download your study data as CSV",
                    "icon": "download",
                    "iconColor": AppTheme.lightTheme.colorScheme.secondary,
                    "action": "export_data",
                  },
                  {
                    "title": "Backup & Sync",
                    "subtitle": "Manage your data synchronization",
                    "icon": "cloud_sync",
                    "iconColor": AppTheme.lightTheme.colorScheme.primary,
                    "action": "backup_sync",
                  },
                  {
                    "title": "Privacy Policy",
                    "subtitle": "Read our privacy policy",
                    "icon": "privacy_tip",
                    "iconColor": Colors.grey,
                    "action": "privacy_policy",
                  },
                ],
                onItemTap: _handleDataAction,
              ),

              // Help & Support Section
              SettingsSection(
                title: "Help & Support",
                items: [
                  {
                    "title": "FAQ",
                    "subtitle": "Frequently asked questions",
                    "icon": "quiz",
                    "iconColor": AppTheme.lightTheme.colorScheme.primary,
                    "action": "faq",
                  },
                  {
                    "title": "Contact Support",
                    "subtitle": "Get help from our support team",
                    "icon": "support_agent",
                    "iconColor": AppTheme.lightTheme.colorScheme.secondary,
                    "action": "contact_support",
                  },
                  {
                    "title": "App Version",
                    "subtitle": "StudySync v1.2.0 (Build 120)",
                    "icon": "info",
                    "iconColor": Colors.grey,
                    "action": "app_version",
                  },
                ],
                onItemTap: _handleHelpAction,
              ),

              // Logout Button
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(4.w),
                child: ElevatedButton(
                  onPressed: _showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.error,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'logout',
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "Logout",
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'school',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Studies',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Revisions',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/studies-tab');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/revisions-tab');
        break;
      case 2:
        // Navigate to notifications tab when implemented
        break;
      case 3:
        // Already on profile tab
        break;
    }
  }

  void _handleAccountAction(String action) {
    switch (action) {
      case 'edit_profile':
        _showEditProfileDialog();
        break;
      case 'change_password':
        _showChangePasswordDialog();
        break;
      case 'subscription':
        if (subscriptionData["isPremium"] as bool) {
          _showManageSubscriptionDialog();
        } else {
          _showUpgradeDialog();
        }
        break;
    }
  }

  void _handleStudySettingsAction(String action) {
    switch (action) {
      case 'revision_intervals':
        _showRevisionIntervalsDialog();
        break;
      case 'daily_reminders_toggle':
        setState(() {
          _dailyReminders = !_dailyReminders;
        });
        _showSnackBar(_dailyReminders
            ? "Daily reminders enabled"
            : "Daily reminders disabled");
        break;
      case 'achievement_notifications_toggle':
        setState(() {
          _achievementNotifications = !_achievementNotifications;
        });
        _showSnackBar(_achievementNotifications
            ? "Achievement notifications enabled"
            : "Achievement notifications disabled");
        break;
      case 'weekly_reports_toggle':
        setState(() {
          _weeklyReports = !_weeklyReports;
        });
        _showSnackBar(_weeklyReports
            ? "Weekly reports enabled"
            : "Weekly reports disabled");
        break;
    }
  }

  void _handleDataAction(String action) {
    switch (action) {
      case 'export_data':
        _exportData();
        break;
      case 'backup_sync':
        _showBackupSyncDialog();
        break;
      case 'privacy_policy':
        _showPrivacyPolicyDialog();
        break;
    }
  }

  void _handleHelpAction(String action) {
    switch (action) {
      case 'faq':
        _showFAQDialog();
        break;
      case 'contact_support':
        _showContactSupportDialog();
        break;
      case 'app_version':
        _showAppVersionDialog();
        break;
    }
  }

  void _showDetailedAnalytics() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Detailed Analytics",
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    Text(
                      "Comprehensive analytics dashboard coming soon with premium features including subject-wise progress tracking, performance trends, and achievement milestones.",
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Upgrade to Premium"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Unlock premium features:"),
            SizedBox(height: 2.h),
            Text("• Unlimited topics and revisions"),
            Text("• Advanced analytics dashboard"),
            Text("• Priority customer support"),
            Text("• Custom revision intervals"),
            SizedBox(height: 2.h),
            Text(
              "Only \$9.99/month",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Maybe Later"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar("Upgrade feature coming soon!");
            },
            child: Text("Upgrade Now"),
          ),
        ],
      ),
    );
  }

  void _showManageSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Manage Subscription"),
        content: Text(
            "Manage your premium subscription settings and billing information."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar("Subscription management coming soon!");
            },
            child: Text("Manage"),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Profile"),
        content: Text(
            "Update your profile information including name, email, and avatar."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar("Profile editing coming soon!");
            },
            child: Text("Edit"),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Change Password"),
        content: Text("Update your account password for better security."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar("Password change coming soon!");
            },
            child: Text("Change"),
          ),
        ],
      ),
    );
  }

  void _showRevisionIntervalsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Revision Intervals"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current intervals (days):"),
            SizedBox(height: 1.h),
            Text("• First revision: 0 days"),
            Text("• Second revision: 7 days"),
            Text("• Third revision: 20 days"),
            Text("• Fourth revision: 50 days"),
            Text("• Fifth revision: 100 days"),
            SizedBox(height: 2.h),
            Text(
              "Customize these intervals with premium plan.",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showUpgradeDialog();
            },
            child: Text("Customize"),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Export Data"),
        content: Text(
            "Export your study data including topics, revisions, and progress statistics as a CSV file."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar("Data export feature coming soon!");
            },
            child: Text("Export"),
          ),
        ],
      ),
    );
  }

  void _showBackupSyncDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Backup & Sync"),
        content:
            Text("Manage your data backup and synchronization across devices."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar("Backup & sync coming soon!");
            },
            child: Text("Manage"),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Privacy Policy"),
        content: SingleChildScrollView(
          child: Text(
            "StudySync Privacy Policy\n\nWe respect your privacy and are committed to protecting your personal data. This privacy policy explains how we collect, use, and protect your information when you use our app.\n\nData Collection:\n• Account information (name, email)\n• Study progress and statistics\n• App usage analytics\n\nData Usage:\n• Provide personalized study experience\n• Track your learning progress\n• Improve app functionality\n\nData Protection:\n• All data is encrypted in transit and at rest\n• We never share personal data with third parties\n• You can request data deletion at any time",
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showFAQDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Frequently Asked Questions"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Q: How does spaced repetition work?",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "A: StudySync schedules revisions at increasing intervals (0, 7, 20, 50, 100 days) to optimize long-term retention.",
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              SizedBox(height: 2.h),
              Text(
                "Q: What's included in the premium plan?",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "A: Premium includes unlimited topics/revisions, advanced analytics, custom intervals, and priority support.",
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              SizedBox(height: 2.h),
              Text(
                "Q: Can I sync data across devices?",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "A: Yes, your data automatically syncs across all your devices when you're logged in.",
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Contact Support"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Need help? Contact our support team:"),
            SizedBox(height: 2.h),
            Text("📧 Email: support@studysync.app"),
            Text("💬 Live Chat: Available 9 AM - 6 PM EST"),
            Text("📱 Response Time: Within 24 hours"),
            SizedBox(height: 2.h),
            Text(
              "Premium users get priority support with faster response times.",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar("Opening support chat...");
            },
            child: Text("Contact Now"),
          ),
        ],
      ),
    );
  }

  void _showAppVersionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("App Information"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("StudySync - Spaced Repetition Learning"),
            SizedBox(height: 1.h),
            Text("Version: 1.2.0"),
            Text("Build: 120"),
            Text("Release Date: August 25, 2024"),
            SizedBox(height: 2.h),
            Text("What's New:"),
            Text("• Improved analytics dashboard"),
            Text("• Enhanced notification system"),
            Text("• Bug fixes and performance improvements"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Help & Tips"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quick Tips:"),
            SizedBox(height: 1.h),
            Text("• Create goals to organize your subjects"),
            Text("• Add topics under each subject"),
            Text("• Complete revisions on time for better retention"),
            Text("• Check your analytics to track progress"),
            Text("• Enable notifications for daily reminders"),
            SizedBox(height: 2.h),
            Text(
              "Need more help? Check our FAQ or contact support.",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text(
            "Are you sure you want to logout? Your data will be synced before logging out."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    // Simulate logout process
    _showSnackBar("Logging out...");

    // Navigate to login screen after a brief delay
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login-screen',
        (route) => false,
      );
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
