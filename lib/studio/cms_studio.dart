import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'cms_signals.dart';
import 'document_editor.dart';

/// Main CMS Studio widget
///
/// This widget provides the main interface for the CMS with:
/// - Configurable header widget
/// - Configurable sidebar widget
/// - Signal-based document selection
/// - Dynamic content based on selected document
class CmsStudio extends StatefulWidget {
  final Widget header;
  final Widget sidebar;

  const CmsStudio({super.key, required this.header, required this.sidebar});

  @override
  State<CmsStudio> createState() => _CmsStudioState();
}

class _CmsStudioState extends State<CmsStudio> {
  Widget _buildEditor() {
    return SignalBuilder(
      signal: selectedDocumentSignal,
      builder: (context, selectedDocument, child) {
        if (selectedDocument == null) {
          return Center(
            child: Text(
              'Select a document type from the sidebar',
              style: ShadTheme.of(context).textTheme.large,
            ),
          );
        }

        // Build document editor based on selected document type
        return CmsDocumentEditor(
          fields: selectedDocument.fields,
          title: selectedDocument.title,
          description: selectedDocument.description,
          documentId: 'new', // TODO: Handle document IDs properly
        );
      },
    );
  }

  Widget _buildContent() {
    return SignalBuilder(
      signal: selectedDocumentSignal,
      builder: (context, selectedDocument, child) {
        if (selectedDocument == null) {
          return Center(
            child: Text(
              'Select a document type from the sidebar to see preview',
              style: ShadTheme.of(context).textTheme.large,
            ),
          );
        }

        // Use the builder if available
        if (selectedDocument.builder != null) {
          return SignalBuilder(
            signal: documentDataSignal,
            builder: (context, documentData, child) {
              // For now, we'll show a placeholder since we need proper CMS config data
              // TODO: Convert documentData to proper typed CMS config
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.preview,
                      size: 48,
                      color: ShadTheme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Content Preview',
                      style: ShadTheme.of(context).textTheme.large,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Builder: ${selectedDocument.name}',
                      style: ShadTheme.of(context).textTheme.small,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Live preview will appear here when editor data is connected',
                      style: ShadTheme.of(context).textTheme.small,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        }

        return Center(
          child: Text(
            'No builder defined for ${selectedDocument.title}',
            style: ShadTheme.of(context).textTheme.large,
          ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    final theme = ShadTheme.of(context);

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(
          right: BorderSide(color: theme.colorScheme.border, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom header
          widget.header,
          // Custom sidebar content
          Expanded(child: widget.sidebar),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSidebar(),
          // Editor panel (left side of main content)
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: ShadTheme.of(context).colorScheme.border,
                    width: 1,
                  ),
                ),
              ),
              child: _buildContent(),
            ),
          ),
          // Content preview panel (right side of main content)
          Expanded(flex: 1, child: _buildEditor()),
        ],
      ),
    );
  }
}
