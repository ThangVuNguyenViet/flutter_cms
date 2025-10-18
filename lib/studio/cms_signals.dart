import 'package:solidart/solidart.dart';

import 'cms_config.dart';

/// Global signal for the currently selected document type
final selectedDocumentSignal = Signal<CmsDocumentType?>(null);

/// Global signal for the currently edited document data
final documentDataSignal = Signal<dynamic>(null);

/// Helper functions for selected document signal
extension SelectedDocumentSignalExtension on Signal<CmsDocumentType?> {
  /// Updates the selected document type
  void selectDocument(CmsDocumentType? documentType) {
    value = documentType;
  }

  /// Clears the selected document
  void clearSelection() {
    value = null;
  }

  /// Gets the currently selected document type
  CmsDocumentType? get selectedDocument => value;
}

/// Helper functions for document data signal
extension DocumentDataSignalExtension on Signal<dynamic> {
  /// Updates the document data
  void updateData(dynamic data) {
    value = data;
  }

  /// Updates a specific field in the document data (for Map-like data)
  void updateField(String key, dynamic newValue) {
    if (value is Map<String, dynamic>) {
      final newData = Map<String, dynamic>.from(value);
      newData[key] = newValue;
      value = newData;
    }
  }

  /// Clears the document data
  void clearData() {
    value = null;
  }

  /// Gets the current document data
  dynamic get data => value;
}
