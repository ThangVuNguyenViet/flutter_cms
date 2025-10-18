import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms/models/cms_data.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../models/fields/block_field.dart';

@Preview(name: 'CmsBlockInput')
Widget preview() => ShadApp(
      home: CmsBlockInput(
        field: const CmsBlockField(
          name: 'content',
          title: 'Content',
          option: CmsBlockOption(),
        ),
      ),
    );

class CmsBlockInput extends StatefulWidget {
  final CmsBlockField field;
  final CmsData? data;

  const CmsBlockInput({super.key, required this.field, this.data});

  @override
  State<CmsBlockInput> createState() => _CmsBlockInputState();
}

class _CmsBlockInputState extends State<CmsBlockInput> {
  late TextEditingController _controller;
  bool _isBold = false;
  bool _isItalic = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.data?.value?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.field.option.hidden) {
      return const SizedBox.shrink();
    }

    final theme = ShadTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.field.title,
            style: theme.textTheme.large.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Rich text toolbar (placeholder)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.muted,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.format_bold,
                    size: 18,
                    color: _isBold ? theme.colorScheme.primary : null,
                  ),
                  onPressed: () {
                    setState(() {
                      _isBold = !_isBold;
                    });
                  },
                  tooltip: 'Bold',
                ),
                IconButton(
                  icon: Icon(
                    Icons.format_italic,
                    size: 18,
                    color: _isItalic ? theme.colorScheme.primary : null,
                  ),
                  onPressed: () {
                    setState(() {
                      _isItalic = !_isItalic;
                    });
                  },
                  tooltip: 'Italic',
                ),
                const VerticalDivider(),
                IconButton(
                  icon: const Icon(Icons.format_list_bulleted, size: 18),
                  onPressed: () {
                    // TODO: Implement bullet list
                  },
                  tooltip: 'Bullet list',
                ),
                IconButton(
                  icon: const Icon(Icons.format_list_numbered, size: 18),
                  onPressed: () {
                    // TODO: Implement numbered list
                  },
                  tooltip: 'Numbered list',
                ),
                const VerticalDivider(),
                IconButton(
                  icon: const Icon(Icons.link, size: 18),
                  onPressed: () {
                    // TODO: Implement link insertion
                  },
                  tooltip: 'Insert link',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Rich text editor (using textarea as placeholder)
          ShadInputFormField(
            controller: _controller,
            placeholder: const Text('Start typing...'),
            maxLines: 10,
          ),
          const SizedBox(height: 8),
          Text(
            'Note: Full rich text editor (Portable Text) support coming soon',
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.mutedForeground,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
