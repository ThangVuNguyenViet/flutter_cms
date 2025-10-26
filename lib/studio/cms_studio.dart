import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'document_editor.dart';
import 'document_list.dart';
import 'signals/cms_signals.dart';

class CmsStudio extends StatefulWidget {
  final Widget header;
  final Widget sidebar;

  const CmsStudio({super.key, required this.header, required this.sidebar});

  @override
  State<CmsStudio> createState() => _CmsStudioState();
}

class _CmsStudioState extends State<CmsStudio> {
  Widget _buildEditor() {
    final theme = ShadTheme.of(context);

    return Container(
      decoration: BoxDecoration(color: theme.colorScheme.background),
      child: SignalBuilder(
        signal: selectedDocumentSignal,
        builder: (context, selectedDocument, child) {
          if (selectedDocument == null) {
            return _buildEmptyState(
              icon: Icons.edit,
              title: 'Document Editor',
              description:
                  'Select a document type from the sidebar to start editing',
            );
          }

          // Build document editor with padding for better spacing
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: CmsDocumentEditor(
              fields: selectedDocument.fields,
              title: selectedDocument.title,
              description: selectedDocument.description,
              documentId: 'new', // TODO: Handle document IDs properly
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentPreview() {
    final theme = ShadTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        border: Border(left: BorderSide(color: theme.colorScheme.border)),
      ),
      child: SignalBuilder(
        signal: selectedDocumentSignal,
        builder: (context, selectedDocument, child) {
          if (selectedDocument == null) {
            return _buildEmptyState(
              icon: Icons.visibility,
              title: 'Content Preview',
              description:
                  'Select a document type from the sidebar to see preview',
            );
          }

          // Use the builder (now required)
          return SignalBuilder(
            signal: documentDataSignal,
            builder: (context, documentData, child) {
              if (documentData.isEmpty) {
                return _buildEmptyState(
                  icon: Icons.article,
                  title: 'Content Preview',
                  description:
                      'Start editing your document to see the preview here',
                  showProgress: false,
                );
              }

              // Wrap preview content with proper padding
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: selectedDocument.builder(documentData),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDocumentsList() {
    final theme = ShadTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        border: Border(right: BorderSide(color: theme.colorScheme.border)),
      ),
      child: SignalBuilder(
        signal: selectedDocumentSignal,
        builder: (context, selectedDocument, child) {
          if (selectedDocument == null) {
            return _buildEmptyState(
              icon: Icons.folder_open,
              title: 'Documents',
              description: 'Select a document type to see available documents',
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: CmsDocumentListView(
              title: selectedDocument.title,
              description: selectedDocument.description,
              icon: Icons.description,
              onCreateNew: () {
                selectedDocumentSignal.createNewDocument();
              },
              onOpenDocument: (documentId) {
                // Find and load the document by ID
                final documents =
                    selectedDocumentSignal.getDocumentsForSelectedType();
                // For now, use hash code as simple ID lookup
                final document = documents.firstWhere(
                  (doc) => doc.hashCode.toString() == documentId,
                  orElse:
                      () =>
                          documents.isNotEmpty
                              ? documents.first
                              : throw StateError('No documents found'),
                );
                selectedDocumentSignal.loadDocument(document);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSidebar() {
    final theme = ShadTheme.of(context);

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: theme.colorScheme.muted.withOpacity(0.3),
        border: Border(right: BorderSide(color: theme.colorScheme.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with improved styling
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.border),
              ),
            ),
            child: widget.header,
          ),
          // Sidebar content with padding
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: widget.sidebar,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build consistent empty states
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String description,
    bool showProgress = false,
  }) {
    final theme = ShadTheme.of(context);

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: ShadCard(
          width: 320,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 32, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.h4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: theme.textTheme.muted,
                  textAlign: TextAlign.center,
                ),
                if (showProgress) ...[
                  const SizedBox(height: 16),
                  const ShadProgress(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          // Add subtle backdrop to entire studio
        ),
        child: ResizableContainer(
          direction: Axis.horizontal,
          children: [
            // Sidebar (fixed, non-resizable)
            ResizableChild(
              size: ResizableSize.pixels(250),
              child: _buildSidebar(),
            ),

            // Documents list panel (resizable)
            ResizableChild(
              size: ResizableSize.pixels(300),
              child: _buildDocumentsList(),
            ),

            // Content preview panel (resizable)
            ResizableChild(
              size: ResizableSize.expand(flex: 1),
              child: _buildContentPreview(),
            ),

            // Document editor panel (resizable)
            ResizableChild(
              size: ResizableSize.pixels(500),
              child: _buildEditor(),
            ),
          ],
        ),
      ),
    );
  }
}
