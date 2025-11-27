import 'package:solidart/solidart.dart';

import '../config.dart';

/// Global signal for the currently selected document type
final selectedDocumentSignal = Signal<CmsDocumentType?>(null);

/// Global signal for the currently edited document data
final documentDataSignal = MapSignal<String, dynamic>({});

/// Storage for documents by document type - temporary in-memory storage
final documentStorageSignal = MapSignal(
  <String, ListSignal<Map<String, dynamic>>>{},
);

/// Helper functions for selected document signal
extension SelectedDocumentSignalExtension on Signal<CmsDocumentType?> {
  /// Updates the selected document type and initializes document data with default value
  void selectDocument(CmsDocumentType? documentType) {
    value = documentType;

    // Initialize document data with default value of T if available
    if (documentType?.defaultValue != null) {
      final defaultInstance = documentType!.defaultValue!;
      documentDataSignal.value = defaultInstance.toMap();
    } else {
      documentDataSignal.clear();
    }
  }

  /// Clears the selected document
  void clearSelection() {
    value = null;
    documentDataSignal.clear();
  }

  /// Gets the currently selected document type
  CmsDocumentType? get selectedDocument => value;
}

/// Helper functions for documents list management
extension DocumentsListManagement on Signal<CmsDocumentType?> {
  /// Creates a new document for the selected document type
  void createNewDocument() {
    final selectedDoc = value;
    if (selectedDoc == null) return;

    final newDoc = selectedDoc.defaultValue;
    final newDocMap = newDoc?.toMap() ?? {};

    // Add to storage
    final typeName = selectedDoc.name;
    if (!documentStorageSignal.containsKey(typeName)) {
      documentStorageSignal[typeName] = ListSignal<Map<String, dynamic>>([]);
    }
    documentStorageSignal[typeName]!.add(Map<String, dynamic>.from(newDocMap));

    // Set as current document
    documentDataSignal.value = newDocMap;
  }

  /// Gets all documents for the selected document type
  List<Map<String, dynamic>> getDocumentsForSelectedType() {
    final selectedDoc = value;
    if (selectedDoc == null) return [];

    return documentStorageSignal[selectedDoc.name] ?? [];
  }

  /// Saves the current document data
  void saveCurrentDocument() {
    final selectedDoc = value;
    final currentData = Map<String, dynamic>.from(documentDataSignal);

    if (selectedDoc == null) return;

    final typeName = selectedDoc.name;
    if (!documentStorageSignal.containsKey(typeName)) {
      documentStorageSignal[typeName] = ListSignal<Map<String, dynamic>>([]);
    }

    // Create a copy of the current data to store
    final documentCopy = Map<String, dynamic>.from(currentData);

    // For now, just add as new document (in real implementation, would need proper ID handling)
    documentStorageSignal[typeName]!.add(documentCopy);
  }
}
