import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AnalyticsCard extends StatelessWidget {
  final Map<String, dynamic> analyticsData;
  final VoidCallback? onTap;

  const AnalyticsCard({
    Key? key,
    required this.analyticsData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Study Analytics",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'analytics',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              height: 20.h,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildProgressChart(),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    flex: 1,
                    child: _buildStatsColumn(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tap to view detailed analytics",
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart() {
    final weeklyData = analyticsData["weeklyProgress"] as List;

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: weeklyData.asMap().entries.map((entry) {
              return FlSpot(
                  entry.key.toDouble(), (entry.value as num).toDouble());
            }).toList(),
            isCurved: true,
            color: AppTheme.lightTheme.colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
            ),
          ),
        ],
        minX: 0,
        maxX: (weeklyData.length - 1).toDouble(),
        minY: 0,
        maxY: 100,
      ),
    );
  }

  Widget _buildStatsColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          "Topics",
          "${analyticsData["totalTopics"]}",
          AppTheme.lightTheme.colorScheme.primary,
        ),
        _buildStatItem(
          "Completed",
          "${analyticsData["completedRevisions"]}",
          AppTheme.lightTheme.colorScheme.secondary,
        ),
        _buildStatItem(
          "Pending",
          "${analyticsData["pendingRevisions"]}",
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
