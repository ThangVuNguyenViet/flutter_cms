import 'package:flutter/material.dart';
import 'package:flutter_cms_annotation/flutter_cms_annotation.dart';
import 'package:signals/signals_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../data/models/cms_document.dart';
import '../../data/models/document_list.dart';
import '../core/cms_provider.dart';
import '../core/signals/cms_signals.dart';

/// Document list view for browsing multiple documents of a type
class CmsDocumentListView extends StatefulWidget {
  final CmsDocumentType selectedDocument;
  final IconData? icon;
  final String? filter;
  final VoidCallback? onCreateNew;
  final void Function(String documentId)? onOpenDocument;

  const CmsDocumentListView({
    super.key,
    required this.selectedDocument,
    this.icon,
    this.filter,
    this.onCreateNew,
    this.onOpenDocument,
  });

  @override
  State<CmsDocumentListView> createState() => _CmsDocumentListViewState();
}

class _CmsDocumentListViewState extends State<CmsDocumentListView> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final viewModel = CmsProvider.of(context);

    return Watch((context) {
      final params = viewModel.queryParams.value;
      if (params.documentType == null) {
        return _buildEmpty(theme);
      }

      final resourceState = viewModel.documentsContainer(params).value;
      return resourceState.map<Widget>(
        data: (result) => _buildContent(context, theme, result),
        loading: () => _buildLoading(theme),
        error: (error, stackTrace) => _buildError(theme, error),
      );
    });
  }

  Widget _buildEmpty(ShadThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 64,
            color: theme.colorScheme.mutedForeground,
          ),
          const SizedBox(height: 16),
          Text(
            'Select a document type',
            style: theme.textTheme.large,
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(ShadThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ShadProgress(),
          const SizedBox(height: 16),
          Text('Loading documents...', style: theme.textTheme.muted),
        ],
      ),
    );
  }

  Widget _buildError(ShadThemeData theme, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.destructive,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load documents',
            style: theme.textTheme.large.copyWith(
              color: theme.colorScheme.destructive,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: theme.textTheme.muted,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ShadThemeData theme,
    DocumentList result,
  ) {
    final viewModel = CmsProvider.of(context);
    final documents = result.documents;
    final filteredDocuments = _getFilteredDocuments(
      documents.map((doc) => doc.activeVersionData ?? {}).toList(),
    );

    return Column(
      children: [
        // Header with search and create button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.colorScheme.border, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 28,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.selectedDocument.title,
                          style: theme.textTheme.h2,
                        ),
                        Text(
                          widget.selectedDocument.description,
                          style: theme.textTheme.small.copyWith(
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ShadInputFormField(
                placeholder: const Text('Search documents...'),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                trailing: const Icon(Icons.search),
              ),
              // Search bar
              if (widget.filter != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Filter: ${widget.filter}',
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.mutedForeground,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Document list
        Expanded(
          child:
              filteredDocuments.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 64,
                          color: theme.colorScheme.mutedForeground,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No documents yet'
                              : 'No documents match your search',
                          style: theme.textTheme.large.copyWith(
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: result.documents.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final doc = result.documents[index];
                      return _buildDocumentTile(context, theme, doc, viewModel);
                    },
                  ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredDocuments(
    List<Map<String, dynamic>> documents,
  ) {
    if (_searchQuery.isEmpty) {
      return documents;
    }
    return documents.where((doc) {
      final searchText = doc.values.whereType<String>().join(' ').toLowerCase();
      return searchText.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildDocumentTile(
    BuildContext context,
    ShadThemeData theme,
    CmsDocument doc,
    CmsViewModel viewModel,
  ) {
    final isSelected = viewModel.selectedDocumentId.value == doc.id;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : theme.colorScheme.card,
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.4)
              : theme.colorScheme.border,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          if (doc.id != null) {
            widget.onOpenDocument?.call(doc.id.toString());
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    doc.title,
                    style: theme.textTheme.large.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.foreground,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
            if (doc.slug != null) ...[
              const SizedBox(height: 4),
              Text(
                '/${doc.slug}',
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.mutedForeground,
                  fontFamily: 'monospace',
                ),
              ),
            ],
            if (doc.isDefault) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'DEFAULT',
                  style: theme.textTheme.small.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

