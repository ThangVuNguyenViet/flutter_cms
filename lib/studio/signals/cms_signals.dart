import 'package:solidart/solidart.dart';

import '../cms_config.dart';

/// Global signal for the currently selected document type
final selectedDocumentSignal = Signal<CmsDocumentType?>(null);

/// Global signal for the currently edited document data
final documentDataSignal = MapSignal<String, dynamic>({});

/// Global signal for the list of documents of the selected document type
final documentsListSignal = Computed<List<Map<String, dynamic>>>(() {
  final selectedDoc = selectedDocumentSignal.value;
  if (selectedDoc == null) {
    return <Map<String, dynamic>>[];
  }

  // Return documents from storage for the selected document type
  return _documentStorage[selectedDoc.name] ?? <Map<String, dynamic>>[];
});

/// Helper functions for selected document signal
extension SelectedDocumentSignalExtension on Signal<CmsDocumentType?> {
  /// Updates the selected document type and initializes document data with default value
  void selectDocument(CmsDocumentType? documentType) {
    value = documentType;

    // Initialize document data with default value of T if available
    if (documentType?.createDefault != null) {
      final defaultInstance = documentType!.createDefault!();
      documentDataSignal.updateData(defaultInstance.toMap());
    } else {
      documentDataSignal.clearData();
    }
  }

  /// Clears the selected document
  void clearSelection() {
    value = null;
    documentDataSignal.clearData();
  }

  /// Gets the currently selected document type
  CmsDocumentType? get selectedDocument => value;
}

/// Helper functions for document data signal
extension DocumentDataSignalExtension on MapSignal {
  /// Updates the document data with a complete map
  void updateData(Map<String, dynamic>? data) {
    if (data == null) {
      clear();
    } else {
      clear();
      addAll(data);
    }
  }

  /// Updates a specific field in the document data
  void updateField(String key, dynamic newValue) {
    this[key] = newValue;
  }

  /// Clears the document data
  void clearData() {
    clear();
  }

  /// Gets the current document data as a map
  Map<String, dynamic> get dataAsMap => Map<String, dynamic>.from(this);
}

/// Storage for documents by document type - temporary in-memory storage
final Map<String, List<Map<String, dynamic>>> _documentStorage = {};

/// Helper functions for documents list management
extension DocumentsListManagement on Signal<CmsDocumentType?> {
  /// Creates a new document for the selected document type
  void createNewDocument() {
    final selectedDoc = value;
    if (selectedDoc == null) return;

    if (selectedDoc.createDefault != null) {
      final newDoc = selectedDoc.createDefault!();
      final newDocMap = newDoc.toMap();

      // Add to storage
      final typeName = selectedDoc.name;
      if (!_documentStorage.containsKey(typeName)) {
        _documentStorage[typeName] = [];
      }
      _documentStorage[typeName]!.add(Map<String, dynamic>.from(newDocMap));

      // Set as current document
      documentDataSignal.updateData(newDocMap);
    }
  }

  /// Loads a document as the current editing document
  void loadDocument(Map<String, dynamic> document) {
    documentDataSignal.updateData(document);
  }

  /// Gets all documents for the selected document type
  List<Map<String, dynamic>> getDocumentsForSelectedType() {
    final selectedDoc = value;
    if (selectedDoc == null) return [];

    return _documentStorage[selectedDoc.name] ?? [];
  }

  /// Saves the current document data
  void saveCurrentDocument() {
    final selectedDoc = value;
    final currentData = documentDataSignal.dataAsMap;

    if (selectedDoc == null) return;

    final typeName = selectedDoc.name;
    if (!_documentStorage.containsKey(typeName)) {
      _documentStorage[typeName] = [];
    }

    // Create a copy of the current data to store
    final documentCopy = Map<String, dynamic>.from(currentData);

    // For now, just add as new document (in real implementation, would need proper ID handling)
    _documentStorage[typeName]!.add(documentCopy);
  }
}
