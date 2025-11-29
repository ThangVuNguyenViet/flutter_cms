import 'package:flutter_cms_annotation/flutter_cms_annotation.dart';
import 'package:solidart/solidart.dart';

import '../../../data/cms_data_source.dart';
import '../../../data/models/cms_document.dart';
import '../../../data/models/document_list.dart';
import '../../../data/models/document_version.dart';

/// ViewModel for CMS data operations.
///
/// This ViewModel uses Solidart signals and Resources for reactive state
/// management and async data operations via a [CmsDataSource].
///
/// ## Data Flow
///
/// ```
/// selectedDocumentType -> documentsResource (list of documents)
///                      |
///                      v
/// selectedDocumentId -> versionsResource (list of versions for document)
///                    |
///                    v
/// selectedVersionId -> selectedDocumentData (version data for editing)
/// ```
///
/// ## Usage
///
/// ```dart
/// // Create with a data source
/// final client = Client('http://localhost:8080/');
/// final dataSource = ServerpodDataSource(client);
/// final viewModel = CmsViewModel(dataSource);
///
/// // Use the documents resource in a widget
/// SignalBuilder(
///   builder: (context, child) {
///     return viewModel.documentsResource.state.when(
///       ready: (data) => ListView(...),
///       error: (error, _) => Text('Error: $error'),
///       loading: () => CircularProgressIndicator(),
///     );
///   },
/// )
/// ```
class CmsViewModel {
  /// The data source for backend communication.
  final CmsDataSource dataSource;

  // ============================================================
  // Selection Signals
  // ============================================================

  /// Signal for the currently selected document type
  final selectedDocumentType = Signal<CmsDocumentType?>(null);

  /// Signal for the currently selected document ID (null for new documents)
  final selectedDocumentId = Signal<int?>(null);

  /// Signal for the currently selected version ID
  final selectedVersionId = Signal<int?>(null);

  // ============================================================
  // Pagination & Search Signals
  // ============================================================

  /// Signal for pagination - current page
  final page = Signal<int>(1);

  /// Signal for pagination - page size
  final pageSize = Signal<int>(20);

  /// Signal for search query
  final searchQuery = Signal<String?>(null);

  // ============================================================
  // Operation State Signals
  // ============================================================

  /// Signal indicating a save operation is in progress
  final isSaving = Signal<bool>(false);

  // ============================================================
  // Computed Signals
  // ============================================================

  /// Computed signal that combines all document query parameters.
  late final Computed<_DocumentQueryParams> _queryParams = Computed(
    () => _DocumentQueryParams(
      documentType: selectedDocumentType.value?.name,
      page: page.value,
      pageSize: pageSize.value,
      search: searchQuery.value,
    ),
  );

  // ============================================================
  // Resources
  // ============================================================

  /// Resource for fetching documents list.
  /// Automatically refetches when selectedDocumentType, page,
  /// pageSize, or searchQuery changes.
  late final Resource<DocumentList> documentsResource =
      Resource<DocumentList>(
        _fetchDocuments,
        source: _queryParams,
        debounceDelay: const Duration(milliseconds: 300),
      );

  /// Resource for fetching versions of the selected document.
  /// Automatically refetches when selectedDocumentId changes.
  late final Resource<DocumentVersionList> versionsResource =
      Resource<DocumentVersionList>(
        _fetchVersions,
        source: selectedDocumentId,
        debounceDelay: const Duration(milliseconds: 100),
      );

  /// Resource for fetching the selected version data.
  /// Automatically refetches when selectedVersionId changes.
  late final Resource<DocumentVersion?> selectedDocumentData =
      Resource<DocumentVersion?>(
        _fetchSelectedVersion,
        source: selectedVersionId,
        debounceDelay: const Duration(milliseconds: 100),
      );

  // ============================================================
  // Constructor
  // ============================================================

  /// Creates a new CmsViewModel.
  ///
  /// [dataSource] - The data source for backend communication.
  CmsViewModel(this.dataSource);

  // ============================================================
  // Internal Fetch Methods
  // ============================================================

  /// Internal method to fetch documents based on current query params.
  Future<DocumentList> _fetchDocuments() async {
    final params = _queryParams.value;
    final documentType = params.documentType;

    if (documentType == null) {
      return DocumentList.empty();
    }

    final offset = (params.page - 1) * params.pageSize;
    return await dataSource.getDocuments(
      documentType,
      search: params.search,
      limit: params.pageSize,
      offset: offset,
    );
  }

  /// Internal method to fetch versions for the selected document.
  Future<DocumentVersionList> _fetchVersions() async {
    final documentId = selectedDocumentId.value;

    if (documentId == null) {
      return DocumentVersionList.empty();
    }

    return await dataSource.getDocumentVersions(documentId);
  }

  /// Internal method to fetch the selected version data.
  Future<DocumentVersion?> _fetchSelectedVersion() async {
    final versionId = selectedVersionId.value;

    if (versionId == null) {
      return null;
    }

    return await dataSource.getDocumentVersion(versionId);
  }

  // ============================================================
  // Document Type Selection
  // ============================================================

  /// Selects a document type and clears any current selection.
  void selectDocumentType(CmsDocumentType? documentType) {
    selectedDocumentType.value = documentType;
    selectedDocumentId.value = null;
    selectedVersionId.value = null;
  }

  /// Clears the selected document type and all selections.
  void clearSelection() {
    selectedDocumentType.value = null;
    selectedDocumentId.value = null;
    selectedVersionId.value = null;
  }

  // ============================================================
  // Document Selection
  // ============================================================

  /// Selects a document by ID, which will trigger fetching its versions.
  void selectDocument(int documentId) {
    selectedDocumentId.value = documentId;
    selectedVersionId.value = null;
  }

  /// Clears the selected document.
  void clearDocumentSelection() {
    selectedDocumentId.value = null;
    selectedVersionId.value = null;
  }

  // ============================================================
  // Version Selection
  // ============================================================

  /// Selects a version by ID, which will trigger fetching its data.
  void selectVersion(int versionId) {
    selectedVersionId.value = versionId;
  }

  /// Clears the selected version.
  void clearVersionSelection() {
    selectedVersionId.value = null;
  }

  // ============================================================
  // Document Operations
  // ============================================================

  /// Creates a new document with initial version.
  ///
  /// [title] - The document title
  /// [data] - The initial document data
  /// [slug] - Optional URL slug
  /// [isDefault] - Whether this is the default document for this type
  ///
  /// Returns the created document.
  Future<CmsDocument?> createDocument(
    String title,
    Map<String, dynamic> data, {
    String? slug,
    bool isDefault = false,
  }) async {
    final docType = selectedDocumentType.value;
    if (docType == null) return null;

    isSaving.value = true;
    try {
      // Create the document (backend creates initial version automatically)
      final document = await dataSource.createDocument(
        docType.name,
        title,
        data,
        slug: slug,
        isDefault: isDefault,
      );

      // Select the new document
      selectedDocumentId.value = document.id;

      // Refresh the documents list and versions
      documentsResource.refresh();
      versionsResource.refresh();

      // Select the first version (which was just created)
      final versions = await dataSource.getDocumentVersions(document.id!);
      if (versions.versions.isNotEmpty) {
        selectedVersionId.value = versions.versions.first.id;
      }

      return document;
    } finally {
      isSaving.value = false;
    }
  }

  /// Deletes a document by ID.
  ///
  /// Returns true if the document was deleted, false otherwise.
  Future<bool> deleteDocument(int documentId) async {
    final result = await dataSource.deleteDocument(documentId);
    if (result && selectedDocumentId.value == documentId) {
      selectedDocumentId.value = null;
      selectedVersionId.value = null;
    }
    documentsResource.refresh();
    return result;
  }

  // ============================================================
  // Version Operations
  // ============================================================

  /// Creates a new version for the current document.
  ///
  /// [data] - The version data
  /// [changeLog] - Optional description of what changed
  ///
  /// Returns the created version data.
  Future<DocumentVersion?> createVersion(
    Map<String, dynamic> data, {
    String? changeLog,
  }) async {
    final documentId = selectedDocumentId.value;
    if (documentId == null) return null;

    isSaving.value = true;
    try {
      final version = await dataSource.createDocumentVersion(
        documentId,
        data,
        status: 'draft',
        changeLog: changeLog,
      );

      // Select the new version
      selectedVersionId.value = version.id;

      // Refresh the versions list
      versionsResource.refresh();

      return version;
    } finally {
      isSaving.value = false;
    }
  }

  /// Updates the currently selected version.
  ///
  /// [data] - The updated version data
  /// [changeLog] - Optional updated changelog
  ///
  /// Returns the updated version data, or null if no version is selected.
  Future<DocumentVersion?> updateVersion(
    Map<String, dynamic> data, {
    String? changeLog,
  }) async {
    final versionId = selectedVersionId.value;
    if (versionId == null) return null;

    isSaving.value = true;
    try {
      final result = await dataSource.updateDocumentVersion(
        versionId,
        data,
        changeLog: changeLog,
      );

      // Refresh the selected document data
      selectedDocumentData.refresh();

      return result;
    } finally {
      isSaving.value = false;
    }
  }

  /// Publishes the currently selected version.
  ///
  /// Returns the updated version data with published status.
  Future<DocumentVersion?> publishVersion() async {
    final versionId = selectedVersionId.value;
    if (versionId == null) return null;

    isSaving.value = true;
    try {
      final result = await dataSource.publishDocumentVersion(versionId);

      // Refresh resources
      versionsResource.refresh();
      selectedDocumentData.refresh();

      return result;
    } finally {
      isSaving.value = false;
    }
  }

  /// Archives the currently selected version.
  ///
  /// Returns the updated version data with archived status.
  Future<DocumentVersion?> archiveVersion() async {
    final versionId = selectedVersionId.value;
    if (versionId == null) return null;

    isSaving.value = true;
    try {
      final result = await dataSource.archiveDocumentVersion(versionId);

      // Refresh resources
      versionsResource.refresh();
      selectedDocumentData.refresh();

      return result;
    } finally {
      isSaving.value = false;
    }
  }

  /// Deletes a version by ID.
  ///
  /// Returns true if the version was deleted, false otherwise.
  Future<bool> deleteVersion(int versionId) async {
    final result = await dataSource.deleteDocumentVersion(versionId);
    if (result && selectedVersionId.value == versionId) {
      selectedVersionId.value = null;
    }
    versionsResource.refresh();
    return result;
  }

  // ============================================================
  // Pagination & Search
  // ============================================================

  /// Sets the search query.
  void setSearchQuery(String? query) {
    searchQuery.value = query;
  }

  /// Sets the current page.
  void setPage(int value) {
    page.value = value;
  }

  /// Sets the page size.
  void setPageSize(int value) {
    pageSize.value = value;
  }

  // ============================================================
  // Refresh Methods
  // ============================================================

  /// Manually refreshes the documents list.
  void refreshDocuments() {
    documentsResource.refresh();
  }

  /// Manually refreshes the versions list.
  void refreshVersions() {
    versionsResource.refresh();
  }

  /// Manually refreshes the selected document data.
  void refreshSelectedData() {
    selectedDocumentData.refresh();
  }

  // ============================================================
  // Disposal
  // ============================================================

  /// Disposes all resources and signals.
  void dispose() {
    documentsResource.dispose();
    versionsResource.dispose();
    selectedDocumentData.dispose();
    _queryParams.dispose();
    selectedDocumentType.dispose();
    selectedDocumentId.dispose();
    selectedVersionId.dispose();
    page.dispose();
    pageSize.dispose();
    searchQuery.dispose();
    isSaving.dispose();
  }
}

/// Internal class to hold document query parameters.
class _DocumentQueryParams {
  final String? documentType;
  final int page;
  final int pageSize;
  final String? search;

  const _DocumentQueryParams({
    this.documentType,
    required this.page,
    required this.pageSize,
    this.search,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _DocumentQueryParams &&
          documentType == other.documentType &&
          page == other.page &&
          pageSize == other.pageSize &&
          search == other.search;

  @override
  int get hashCode => Object.hash(documentType, page, pageSize, search);
}
