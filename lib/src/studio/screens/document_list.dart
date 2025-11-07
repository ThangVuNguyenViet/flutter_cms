import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../core/signals/cms_signals.dart';

/// Document list view for browsing multiple documents of a type
class CmsDocumentListView extends StatefulWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final String? filter;
  final VoidCallback? onCreateNew;
  final void Function(String documentId)? onOpenDocument;

  const CmsDocumentListView({
    super.key,
    required this.title,
    this.description,
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

  void _createNewDocument() {
    if (widget.onCreateNew != null) {
      widget.onCreateNew!();
    }
  }

  void _openDocument(Map<String, dynamic> document) {
    if (widget.onOpenDocument != null) {
      // Generate a simple ID for now - in real implementation would use proper document ID
      final documentId = document.hashCode.toString();
      widget.onOpenDocument!(documentId);
    }
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

  String _getDocumentTitle(Map<String, dynamic> docData) {
    // Try to find a title field - common field names
    for (final key in ['title', 'name', 'label', 'displayName']) {
      if (docData.containsKey(key) && docData[key] is String) {
        final title = docData[key] as String;
        if (title.isNotEmpty) {
          return title;
        }
      }
    }

    // Fallback to first string value or "Untitled"
    for (final value in docData.values) {
      if (value is String && value.isNotEmpty) {
        return value.length > 30 ? '${value.substring(0, 30)}...' : value;
      }
    }

    return 'Untitled Document';
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SignalBuilder(
      signal: documentsListSignal,
      builder: (context, documents, child) {
        final filteredDocuments = _getFilteredDocuments(documents);

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
                            Text(widget.title, style: theme.textTheme.h2),
                            if (widget.description != null)
                              Text(
                                widget.description!,
                                style: theme.textTheme.small.copyWith(
                                  color: theme.colorScheme.mutedForeground,
                                ),
                              ),
                          ],
                        ),
                      ),
                      ShadButton(
                        onPressed: _createNewDocument,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 16),
                            SizedBox(width: 8),
                            Text('Create'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  ShadInputFormField(
                    placeholder: const Text('Search documents...'),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
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
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredDocuments.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDocuments[index];
                          final docData = doc;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _openDocument(doc),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colorScheme.border,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      if (widget.icon != null) ...[
                                        Icon(
                                          widget.icon,
                                          size: 20,
                                          color: theme.colorScheme.primary,
                                        ),
                                        const SizedBox(width: 12),
                                      ],
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _getDocumentTitle(docData),
                                              style: theme.textTheme.small
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Document #${index + 1}',
                                              style: theme.textTheme.small
                                                  .copyWith(
                                                    color:
                                                        theme
                                                            .colorScheme
                                                            .mutedForeground,
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        size: 20,
                                        color:
                                            theme.colorScheme.mutedForeground,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        );
      },
    );
  }
}
