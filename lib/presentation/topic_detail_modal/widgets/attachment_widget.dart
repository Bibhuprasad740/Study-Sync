import 'package:flutter/material.dart';

class AttachmentWidget extends StatelessWidget {
  final String name;
  final String type;
  final String? url;
  final String size;

  const AttachmentWidget({
    super.key,
    required this.name,
    required this.type,
    this.url,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        leading: _buildAttachmentIcon(context),
        title: Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${type.toUpperCase()} • $size',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.visibility_outlined, size: 20),
              onPressed: () => _viewAttachment(context),
              tooltip: 'View',
            ),
            IconButton(
              icon: Icon(Icons.more_vert, size: 20),
              onPressed: () => _showAttachmentMenu(context),
              tooltip: 'More options',
            ),
          ],
        ),
        onTap: () => _viewAttachment(context),
      ),
    );
  }

  Widget _buildAttachmentIcon(BuildContext context) {
    IconData icon;
    Color color;

    switch (type.toLowerCase()) {
      case 'image':
        icon = Icons.image_outlined;
        color = Theme.of(context).colorScheme.secondary;
        break;
      case 'pdf':
        icon = Icons.picture_as_pdf_outlined;
        color = Theme.of(context).colorScheme.error;
        break;
      case 'document':
      case 'doc':
      case 'docx':
        icon = Icons.description_outlined;
        color = Theme.of(context).colorScheme.primary;
        break;
      case 'video':
        icon = Icons.video_file_outlined;
        color = Theme.of(context).colorScheme.tertiary;
        break;
      default:
        icon = Icons.attach_file;
        color = Theme.of(context).colorScheme.outline;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  void _viewAttachment(BuildContext context) {
    if (type.toLowerCase() == 'image' && url != null) {
      _showImageViewer(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening $name...')),
      );
      // Implement file viewing logic based on type
    }
  }

  void _showImageViewer(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      url!,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 200,
                          height: 200,
                          color: Theme.of(context).colorScheme.surface,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 200,
                          color: Theme.of(context).colorScheme.surface,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 48,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Failed to load image',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    shape: CircleBorder(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAttachmentMenu(BuildContext context) {
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
                leading: Icon(Icons.download_outlined),
                title: Text('Download'),
                onTap: () {
                  Navigator.pop(context);
                  _downloadAttachment(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.share_outlined),
                title: Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  _shareAttachment(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Rename'),
                onTap: () {
                  Navigator.pop(context);
                  _renameAttachment(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error),
                title: Text('Delete',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteAttachment(context);
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _downloadAttachment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading $name...')),
    );
    // Implement download functionality
  }

  void _shareAttachment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing $name...')),
    );
    // Implement share functionality
  }

  void _renameAttachment(BuildContext context) {
    String newName = name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename Attachment'),
          content: TextField(
            controller: TextEditingController(text: name),
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => newName = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Attachment renamed to $newName')),
                );
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAttachment(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Attachment'),
          content: Text(
              'Are you sure you want to delete "$name"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name deleted')),
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
}
