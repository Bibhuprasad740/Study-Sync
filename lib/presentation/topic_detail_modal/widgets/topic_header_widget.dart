import 'package:flutter/material.dart';

class TopicHeaderWidget extends StatelessWidget {
  final String title;
  final String subject;
  final double completionRate;
  final bool isEditMode;
  final TextEditingController? titleController;

  const TopicHeaderWidget({
    super.key,
    required this.title,
    required this.subject,
    required this.completionRate,
    this.isEditMode = false,
    this.titleController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              subject,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          SizedBox(height: 12),

          // Title
          if (isEditMode && titleController != null)
            TextField(
              controller: titleController,
              style: Theme.of(context).textTheme.headlineSmall,
              decoration: InputDecoration(
                hintText: 'Topic title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: 2,
            )
          else
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          SizedBox(height: 16),

          // Progress indicator
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: completionRate / 100.0,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Text(
                '${completionRate.toInt()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
