import 'package:flutter/material.dart';

import './attachment_widget.dart';

class TopicContentWidget extends StatelessWidget {
  final String description;
  final List<Map<String, dynamic>> attachments;
  final bool isEditMode;
  final TextEditingController? descriptionController;

  const TopicContentWidget({
    super.key,
    required this.description,
    required this.attachments,
    this.isEditMode = false,
    this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description section
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 12),

          if (isEditMode && descriptionController != null)
            TextField(
              controller: descriptionController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Add topic description...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: 8,
              minLines: 4,
            )
          else
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                description.isNotEmpty
                    ? description
                    : 'No description available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
              ),
            ),

          // Attachments section
          if (attachments.isNotEmpty) ...[
            SizedBox(height: 32),
            Text(
              'Attachments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 12),
            ...attachments
                .map((attachment) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: AttachmentWidget(
                        name: attachment['name'],
                        type: attachment['type'],
                        url: attachment['url'],
                        size: attachment['size'],
                      ),
                    ))
                .toList(),
          ],

          // Add attachment button in edit mode
          if (isEditMode) ...[
            SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _showAddAttachmentDialog(context),
              icon: Icon(Icons.attach_file),
              label: Text('Add Attachment'),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddAttachmentDialog(BuildContext context) {
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
              ListTile(
                leading: Icon(Icons.photo_outlined),
                title: Text('Photo from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement photo picker
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement camera
                },
              ),
              ListTile(
                leading: Icon(Icons.description_outlined),
                title: Text('Document'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement document picker
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}