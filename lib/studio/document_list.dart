import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
  List<Map<String, dynamic>> _documents = [];
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Implement actual document loading with filter
    // For now, showing empty state until backend implementation

    setState(() {
      _documents = [];
      _isLoading = false;
    });
  }

  void _createNewDocument() {
    if (widget.onCreateNew != null) {
      widget.onCreateNew!();
    }
  }

  void _openDocument(String documentId) {
    if (widget.onOpenDocument != null) {
      widget.onOpenDocument!(documentId);
    }
  }

  List<Map<String, dynamic>> get _filteredDocuments {
    if (_searchQuery.isEmpty) {
      return _documents;
    }
    return _documents.where((doc) {
      final title = doc['title']?.toString().toLowerCase() ?? '';
      return title.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      children: [
        // Header with search and create button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.border,
                width: 1,
              ),
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
                          widget.title,
                          style: theme.textTheme.h2,
                        ),
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredDocuments.isEmpty
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
                          const SizedBox(height: 8),
                          if (_searchQuery.isEmpty)
                            ShadButton(
                              onPressed: _createNewDocument,
                              child: const Text('Create your first document'),
                            ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredDocuments.length,
                      itemBuilder: (context, index) {
                        final doc = _filteredDocuments[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _openDocument(doc['_id']),
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
                                            doc['title'] ?? 'Untitled',
                                            style: theme.textTheme.small
                                                .copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Updated: ${_formatDate(doc['updatedAt'])}',
                                            style: theme.textTheme.small
                                                .copyWith(
                                              color: theme
                                                  .colorScheme.mutedForeground,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                      color: theme.colorScheme.mutedForeground,
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
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}
