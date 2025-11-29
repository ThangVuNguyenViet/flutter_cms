import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:signals/signals_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../core/cms_provider.dart';
import 'document_editor.dart';
import 'document_list.dart';

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
    final viewModel = CmsProvider.of(context);

    return Container(
      decoration: BoxDecoration(color: theme.colorScheme.background),
      child: Watch((context) {
        final viewModel = CmsProvider.of(context);
        final selectedDocument = viewModel.selectedDocumentType.value;
        if (selectedDocument == null) {
            return _buildEmptyState(
              icon: Icons.edit,
              title: 'Document Editor',
              description:
                  'Select a document type from the sidebar to start editing',
            );
          }

          // Build document editor with padding for better spacing
          return CmsDocumentEditor(
            fields: selectedDocument.fields,
            title: selectedDocument.title,
            description: selectedDocument.description,
          );
        }),
    );
  }

  Widget _buildContentPreview() {
    final theme = ShadTheme.of(context);
    final viewModel = CmsProvider.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        border: Border(left: BorderSide(color: theme.colorScheme.border)),
      ),
      child: Watch((context) {
        final viewModel = CmsProvider.of(context);
        final selectedDocument = viewModel.selectedDocumentType.value;
        if (selectedDocument == null) {
            return _buildEmptyState(
              icon: Icons.visibility,
              title: 'Content Preview',
              description:
                  'Select a document type from the sidebar to see preview',
            );
          }

          // Use the documentDataContainer for preview
          final versionId = viewModel.selectedVersionId.value;
          if (versionId == null) {
            return _buildEmptyState(
              icon: Icons.article,
              title: 'Content Preview',
              description: 'No version selected',
            );
          }

          final versionState = viewModel.documentDataContainer(versionId).value;

          return versionState.map<Widget>(
            loading: () => _buildEmptyState(
              icon: Icons.article,
              title: 'Content Preview',
              description: 'Loading document...',
              showProgress: true,
            ),
            error: (error, stackTrace) => _buildEmptyState(
              icon: Icons.error,
              title: 'Error',
              description: 'Failed to load document: $error',
            ),
            data: (versionData) {
              if (versionData == null) {
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
                child: selectedDocument.builder(versionData.data),
              );
            },
          );
        }),
    );
  }

  Widget _buildDocumentsList() {
    final theme = ShadTheme.of(context);
    final viewModel = CmsProvider.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        border: Border(right: BorderSide(color: theme.colorScheme.border)),
      ),
      child: Watch((context) {
        final viewModel = CmsProvider.of(context);
        final selectedDocument = viewModel.selectedDocumentType.value;

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
              selectedDocument: selectedDocument,
              icon: Icons.description,
              onCreateNew: () {
                // Clear selections to create new document
                viewModel.clearDocumentSelection();
              },
              onOpenDocument: (documentId) {
                // Select the document by ID
                final docId = int.tryParse(documentId);
                if (docId != null) {
                  viewModel.selectDocument(docId);
                }
              },
            ),
          );
        }),
    );
  }

  Widget _buildSidebar() {
    final theme = ShadTheme.of(context);

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: theme.colorScheme.muted.withValues(alpha: 0.3),
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
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
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
              size: ResizableSize.ratio(0.2),
              child: _buildSidebar(),
            ),

            // Documents list panel (resizable)
            ResizableChild(
              size: ResizableSize.ratio(0.2),
              child: _buildDocumentsList(),
            ),

            // Content preview panel (resizable)
            ResizableChild(
              size: ResizableSize.ratio(0.4),
              child: _buildContentPreview(),
            ),

            // Document editor panel (resizable)
            ResizableChild(
              size: ResizableSize.ratio(0.2),
              child: _buildEditor(),
            ),
          ],
        ),
      ),
    );
  }
}
