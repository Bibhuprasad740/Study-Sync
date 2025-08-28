import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import './widgets/achievements_widget.dart';
import './widgets/export_widget.dart';
import './widgets/overview_cards_widget.dart';
import './widgets/progress_chart_widget.dart';
import './widgets/study_habits_widget.dart';
import './widgets/subject_breakdown_widget.dart';
import './widgets/time_period_selector_widget.dart';

class StatisticsDashboard extends StatefulWidget {
  const StatisticsDashboard({super.key});

  @override
  State<StatisticsDashboard> createState() => _StatisticsDashboardState();
}

class _StatisticsDashboardState extends State<StatisticsDashboard> {
  String selectedPeriod = 'Week';
  bool isLoading = false;

  // Mock data based on selected period
  Map<String, dynamic> get mockData => {
        'overview': {
          'totalTopics': selectedPeriod == 'Year'
              ? 156
              : selectedPeriod == 'Month'
                  ? 42
                  : 12,
          'currentStreak': selectedPeriod == 'Year'
              ? 89
              : selectedPeriod == 'Month'
                  ? 23
                  : 7,
          'completionRate': selectedPeriod == 'Year'
              ? 82.5
              : selectedPeriod == 'Month'
                  ? 78.3
                  : 85.4,
          'weeklyProgress': selectedPeriod == 'Year'
              ? 15.2
              : selectedPeriod == 'Month'
                  ? 18.7
                  : 22.1,
        },
        'chartData': _getChartData(),
        'subjects': [
          {
            'name': 'Machine Learning',
            'progress': 85.0,
            'topics': 24,
            'color': '0xFF2563EB'
          },
          {
            'name': 'Data Structures',
            'progress': 92.0,
            'topics': 18,
            'color': '0xFF059669'
          },
          {
            'name': 'Algorithms',
            'progress': 78.0,
            'topics': 16,
            'color': '0xFFF59E0B'
          },
          {
            'name': 'System Design',
            'progress': 65.0,
            'topics': 12,
            'color': '0xFFDC2626'
          },
          {
            'name': 'Database Systems',
            'progress': 88.0,
            'topics': 14,
            'color': '0xFF7C3AED'
          },
        ],
        'achievements': [
          {
            'title': 'Study Streak Master',
            'description': '30 days of consistent studying',
            'icon': 'fire',
            'earned': true,
            'date': '2025-01-15'
          },
          {
            'title': 'Perfect Week',
            'description': 'Completed all scheduled reviews in a week',
            'icon': 'star',
            'earned': true,
            'date': '2025-01-20'
          },
          {
            'title': 'Topic Champion',
            'description': 'Master 50 topics with 90%+ accuracy',
            'icon': 'trophy',
            'earned': false,
            'progress': 0.76
          },
        ],
        'studyHabits': {
          'optimalTime': '2:00 PM - 4:00 PM',
          'averageSession': 42,
          'weeklyFrequency': 4.2,
          'bestDay': 'Tuesday',
          'efficiency': 85.3,
        }
      };

  List<FlSpot> _getChartData() {
    switch (selectedPeriod) {
      case 'Week':
        return [
          FlSpot(0, 6.5),
          FlSpot(1, 7.2),
          FlSpot(2, 8.1),
          FlSpot(3, 7.8),
          FlSpot(4, 8.5),
          FlSpot(5, 9.2),
          FlSpot(6, 8.8)
        ];
      case 'Month':
        return [
          FlSpot(0, 75),
          FlSpot(5, 78),
          FlSpot(10, 82),
          FlSpot(15, 79),
          FlSpot(20, 85),
          FlSpot(25, 88),
          FlSpot(30, 85)
        ];
      case 'Year':
        return [
          FlSpot(0, 65),
          FlSpot(2, 70),
          FlSpot(4, 75),
          FlSpot(6, 78),
          FlSpot(8, 80),
          FlSpot(10, 82),
          FlSpot(12, 85)
        ];
      default:
        return [];
    }
  }

  void _onPeriodChanged(String period) {
    setState(() {
      selectedPeriod = period;
      isLoading = true;
    });

    // Simulate data loading
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  void _exportData() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return ExportWidget(
          onExportPDF: () {
            Navigator.pop(context);
            _showExportSuccess('PDF report generated successfully');
          },
          onExportCSV: () {
            Navigator.pop(context);
            _showExportSuccess('CSV data exported successfully');
          },
        );
      },
    );
  }

  void _showExportSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showComparison() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Period Comparison'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildComparisonRow('This Week', '85.4%', '22.1 topics', true),
                _buildComparisonRow('Last Week', '78.2%', '18.3 topics', false),
                Divider(),
                _buildComparisonRow('This Month', '78.3%', '94 topics', true),
                _buildComparisonRow('Last Month', '82.1%', '89 topics', false),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildComparisonRow(
      String period, String completion, String topics, bool isCurrent) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            period,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                  color:
                      isCurrent ? Theme.of(context).colorScheme.primary : null,
                ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                completion,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                topics,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = mockData;

    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.compare_arrows),
            onPressed: _showComparison,
            tooltip: 'Compare Periods',
          ),
          IconButton(
            icon: Icon(Icons.download_outlined),
            onPressed: _exportData,
            tooltip: 'Export Data',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => isLoading = true);
          await Future.delayed(Duration(seconds: 1));
          setState(() => isLoading = false);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time period selector
              TimePeriodSelectorWidget(
                selectedPeriod: selectedPeriod,
                onPeriodChanged: _onPeriodChanged,
              ),

              SizedBox(height: 24),

              // Overview cards
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                )
              else ...[
                OverviewCardsWidget(
                  totalTopics: data['overview']['totalTopics'],
                  currentStreak: data['overview']['currentStreak'],
                  completionRate: data['overview']['completionRate'],
                  weeklyProgress: data['overview']['weeklyProgress'],
                ),

                SizedBox(height: 32),

                // Progress chart
                Text(
                  'Study Progress Trends',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 16),
                ProgressChartWidget(
                  chartData: data['chartData'],
                  selectedPeriod: selectedPeriod,
                ),

                SizedBox(height: 32),

                // Subject breakdown
                Text(
                  'Subject Progress',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 16),
                SubjectBreakdownWidget(
                  subjects: List<Map<String, dynamic>>.from(data['subjects']),
                ),

                SizedBox(height: 32),

                // Achievements
                Text(
                  'Achievements',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 16),
                AchievementsWidget(
                  achievements:
                      List<Map<String, dynamic>>.from(data['achievements']),
                ),

                SizedBox(height: 32),

                // Study habits analysis
                Text(
                  'Study Habits Analysis',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 16),
                StudyHabitsWidget(
                  studyHabits: Map<String, dynamic>.from(data['studyHabits']),
                ),

                SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
