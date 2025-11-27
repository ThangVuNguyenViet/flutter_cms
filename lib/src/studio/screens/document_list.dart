import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../studio.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SignalBuilder(
      builder: (context, documents) {
        final documents =
            documentStorageSignal[selectedDocumentSignal.value?.name];
        final filteredDocuments = _getFilteredDocuments(documents?.value ?? []);

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
                    trailing: Icon(Icons.search),
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
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredDocuments.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDocuments[index];
                          return widget.selectedDocument.tileBuilder(doc);
                        },
                      ),
            ),
          ],
        );
      },
    );
  }
}
