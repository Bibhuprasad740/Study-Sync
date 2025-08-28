import 'package:flutter/material.dart';

class ExportWidget extends StatelessWidget {
  final VoidCallback? onExportPDF;
  final VoidCallback? onExportCSV;

  const ExportWidget({
    super.key,
    this.onExportPDF,
    this.onExportCSV,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Text(
              'Export Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),

            SizedBox(height: 16),

            // Export options
            _buildExportOption(
              context,
              icon: Icons.picture_as_pdf,
              title: 'PDF Report',
              description:
                  'Complete statistics report with charts and insights',
              color: Theme.of(context).colorScheme.error,
              onTap: onExportPDF,
            ),

            SizedBox(height: 12),

            _buildExportOption(
              context,
              icon: Icons.table_chart,
              title: 'CSV Data',
              description: 'Raw data for analysis in spreadsheet applications',
              color: Theme.of(context).colorScheme.secondary,
              onTap: onExportCSV,
            ),

            SizedBox(height: 12),

            _buildExportOption(
              context,
              icon: Icons.share,
              title: 'Share Summary',
              description: 'Quick overview to share with study partners',
              color: Theme.of(context).colorScheme.primary,
              onTap: () => _shareStatsSummary(context),
            ),

            SizedBox(height: 16),

            // Export options info
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Exported data includes the selected time period and all visible statistics.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),

            SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.outline,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _shareStatsSummary(BuildContext context) {
    Navigator.pop(context);

    // Mock summary data
    final summary = """
📊 StudySync Statistics Summary

🎯 This Week's Highlights:
• 85.4% completion rate
• 7-day study streak
• 12 topics completed
• 42 min average session

🏆 Top Subject: Machine Learning (85% progress)

Keep up the excellent work! 🚀
""";

    // Show share dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share Statistics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Preview:'),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  summary,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Statistics summary copied to clipboard'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text('Share'),
            ),
          ],
        );
      },
    );
  }
}
