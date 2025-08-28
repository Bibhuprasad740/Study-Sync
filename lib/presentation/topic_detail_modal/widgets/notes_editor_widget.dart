import 'package:flutter/material.dart';

class NotesEditorWidget extends StatefulWidget {
  final String notes;
  final bool isEditMode;
  final TextEditingController? notesController;

  const NotesEditorWidget({
    super.key,
    required this.notes,
    this.isEditMode = false,
    this.notesController,
  });

  @override
  State<NotesEditorWidget> createState() => _NotesEditorWidgetState();
}

class _NotesEditorWidgetState extends State<NotesEditorWidget> {
  bool _showFormattingToolbar = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Formatting toolbar (shown in edit mode)
        if (widget.isEditMode && _showFormattingToolbar)
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFormattingButton(Icons.format_bold, 'Bold',
                      () => _insertFormatting('**', '**')),
                  _buildFormattingButton(Icons.format_italic, 'Italic',
                      () => _insertFormatting('_', '_')),
                  _buildFormattingButton(Icons.format_list_bulleted, 'Bullet',
                      () => _insertFormatting('• ', '')),
                  _buildFormattingButton(Icons.format_list_numbered, 'Number',
                      () => _insertFormatting('1. ', '')),
                  _buildFormattingButton(Icons.link, 'Link',
                      () => _insertFormatting('[', '](url)')),
                  _buildFormattingButton(
                      Icons.code, 'Code', () => _insertFormatting('`', '`')),
                ],
              ),
            ),
          ),

        // Notes content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Study Notes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (widget.isEditMode)
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _showFormattingToolbar = !_showFormattingToolbar;
                          });
                        },
                        icon: Icon(Icons.text_format),
                        label: Text('Format'),
                      ),
                  ],
                ),
                SizedBox(height: 12),
                if (widget.isEditMode && widget.notesController != null)
                  TextField(
                    controller: widget.notesController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText:
                          'Add your study notes here...\n\nYou can use formatting:\n• **bold text**\n• _italic text_\n• Bullet points\n• Code `snippets`',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    maxLines: null,
                    minLines: 15,
                    textInputAction: TextInputAction.newline,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.notes.isNotEmpty)
                          _buildFormattedText(widget.notes)
                        else
                          Text(
                            'No notes available. Tap the edit button to add study notes.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                      ],
                    ),
                  ),
                if (widget.isEditMode) ...[
                  SizedBox(height: 16),
                  Text(
                    'Formatting Help:',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 8),
                  _buildFormattingHelp(context),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormattingButton(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  void _insertFormatting(String prefix, String suffix) {
    if (widget.notesController == null) return;

    final controller = widget.notesController!;
    final text = controller.text;
    final selection = controller.selection;

    if (selection.isValid) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.substring(0, selection.start) +
          prefix +
          selectedText +
          suffix +
          text.substring(selection.end);

      controller.text = newText;
      controller.selection = TextSelection.fromPosition(
        TextPosition(
            offset: selection.start +
                prefix.length +
                selectedText.length +
                suffix.length),
      );
    } else {
      final newText = text + prefix + suffix;
      controller.text = newText;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length - suffix.length),
      );
    }
  }

  Widget _buildFormattedText(String text) {
    // Simple markdown-like formatting
    List<TextSpan> spans = [];
    List<String> lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];

      // Handle bullet points
      if (line.trim().startsWith('•')) {
        spans.add(TextSpan(
          text: line + (i < lines.length - 1 ? '\n' : ''),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ));
      }
      // Handle bold text
      else if (line.contains('**')) {
        List<String> parts = line.split('**');
        for (int j = 0; j < parts.length; j++) {
          spans.add(TextSpan(
            text: parts[j],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: j % 2 == 1 ? FontWeight.w600 : FontWeight.normal,
                  height: 1.5,
                ),
          ));
        }
        if (i < lines.length - 1) spans.add(TextSpan(text: '\n'));
      }
      // Handle regular text
      else {
        spans.add(TextSpan(
          text: line + (i < lines.length - 1 ? '\n' : ''),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ));
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildFormattingHelp(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('**bold text** - Make text bold'),
          Text('_italic text_ - Make text italic'),
          Text('• bullet point - Create bullet points'),
          Text('`code` - Inline code formatting'),
          Text('[link text](url) - Create links'),
        ]
            .map((text) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    text.data!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
