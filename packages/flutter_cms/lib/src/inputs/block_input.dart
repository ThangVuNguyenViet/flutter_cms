import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_cms_annotation/flutter_cms_annotation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:super_editor/super_editor.dart';

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
  final ValueChanged<dynamic>? onChanged;

  const CmsBlockInput({
    super.key,
    required this.field,
    this.data,
    this.onChanged,
  });

  @override
  State<CmsBlockInput> createState() => _CmsBlockInputState();
}

class _CmsBlockInputState extends State<CmsBlockInput> {
  late final Editor _editor;
  late final FocusNode _editorFocusNode;

  @override
  void initState() {
    super.initState();

    _editorFocusNode = FocusNode();

    // Initialize document from data or create empty
    final initialDocument = _createDocumentFromData();

    _editor = createDefaultDocumentEditor(
      document: initialDocument,
      composer: MutableDocumentComposer(),
      isHistoryEnabled: true,
    );
  }

  MutableDocument _createDocumentFromData() {
    final dataValue = widget.data?.value;

    if (dataValue == null || (dataValue is String && dataValue.isEmpty)) {
      // Create empty document with a single paragraph
      return MutableDocument(
        nodes: [
          ParagraphNode(id: Editor.createNodeId(), text: AttributedText()),
        ],
      );
    }

    // For now, treat data as plain text
    final text = dataValue.toString();
    return MutableDocument(
      nodes: [
        ParagraphNode(id: Editor.createNodeId(), text: AttributedText(text)),
      ],
    );
  }

  @override
  void dispose() {
    _editorFocusNode.dispose();
    _editor.dispose();
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
          // Title
          Text(
            widget.field.title,
            style: theme.textTheme.large.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Rich text toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.muted,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                // Text formatting
                ShadIconButton(
                  icon: const Icon(Icons.format_bold, size: 18),
                  onPressed: () {
                    final selection = _editor.composer.selection;
                    if (selection == null) return;
                    _editor.execute([
                      ToggleTextAttributionsRequest(
                        documentRange: selection,
                        attributions: {boldAttribution},
                      ),
                    ]);
                  },
                ),
                ShadIconButton(
                  icon: const Icon(Icons.format_italic, size: 18),
                  onPressed: () {
                    final selection = _editor.composer.selection;
                    if (selection == null) return;
                    _editor.execute([
                      ToggleTextAttributionsRequest(
                        documentRange: selection,
                        attributions: {italicsAttribution},
                      ),
                    ]);
                  },
                ),
                ShadIconButton(
                  icon: const Icon(Icons.format_strikethrough, size: 18),
                  onPressed: () {
                    final selection = _editor.composer.selection;
                    if (selection == null) return;
                    _editor.execute([
                      ToggleTextAttributionsRequest(
                        documentRange: selection,
                        attributions: {strikethroughAttribution},
                      ),
                    ]);
                  },
                ),
                const VerticalDivider(),

                // Headers
                PopupMenuButton<int>(
                  icon: const Icon(Icons.title, size: 18),
                  tooltip: 'Headers',
                  onSelected: (level) {
                    _editor.execute([
                      ChangeParagraphBlockTypeRequest(
                        nodeId: _editor.composer.selection!.extent.nodeId,
                        blockType:
                            level == 1
                                ? header1Attribution
                                : level == 2
                                ? header2Attribution
                                : header3Attribution,
                      ),
                    ]);
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(value: 1, child: Text('Heading 1')),
                        const PopupMenuItem(value: 2, child: Text('Heading 2')),
                        const PopupMenuItem(value: 3, child: Text('Heading 3')),
                      ],
                ),

                // Lists
                ShadIconButton(
                  icon: const Icon(Icons.format_list_bulleted, size: 18),
                  onPressed: () {
                    _editor.execute([
                      ConvertParagraphToListItemRequest(
                        nodeId: _editor.composer.selection!.extent.nodeId,
                        type: ListItemType.unordered,
                      ),
                    ]);
                  },
                ),
                ShadIconButton(
                  icon: const Icon(Icons.format_list_numbered, size: 18),
                  onPressed: () {
                    _editor.execute([
                      ConvertParagraphToListItemRequest(
                        nodeId: _editor.composer.selection!.extent.nodeId,
                        type: ListItemType.ordered,
                      ),
                    ]);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // SuperEditor
          Container(
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.border),
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.background,
            ),
            padding: const EdgeInsets.all(16),
            child: SuperEditor(
              editor: _editor,
              focusNode: _editorFocusNode,
              stylesheet: _buildStylesheet(theme),
              documentOverlayBuilders: [
                DefaultCaretOverlayBuilder(
                  caretStyle: CaretStyle(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Text(
            'Tip: Use Cmd/Ctrl+Z to undo, Cmd/Ctrl+Shift+Z to redo. '
            'Select text and use toolbar for formatting.',
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.mutedForeground,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Stylesheet _buildStylesheet(ShadThemeData theme) {
    return defaultStylesheet.copyWith(
      addRulesAfter: [
        StyleRule(BlockSelector.all, (doc, docNode) {
          return {
            Styles.textStyle: TextStyle(
              color: theme.colorScheme.foreground,
              fontSize: 14,
              height: 1.5,
            ),
          };
        }),
        StyleRule(const BlockSelector('header1'), (doc, docNode) {
          return {
            Styles.textStyle: theme.textTheme.h1.copyWith(
              color: theme.colorScheme.foreground,
            ),
          };
        }),
        StyleRule(const BlockSelector('header2'), (doc, docNode) {
          return {
            Styles.textStyle: theme.textTheme.h2.copyWith(
              color: theme.colorScheme.foreground,
            ),
          };
        }),
        StyleRule(const BlockSelector('header3'), (doc, docNode) {
          return {
            Styles.textStyle: theme.textTheme.h3.copyWith(
              color: theme.colorScheme.foreground,
            ),
          };
        }),
      ],
    );
  }
}
