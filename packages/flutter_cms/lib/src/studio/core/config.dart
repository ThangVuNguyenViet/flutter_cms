import 'package:flutter/widgets.dart';

import '../../../annotations.dart';
import '../../core/serializable.dart';
/// Represents a document type (schema) in the CMS
class CmsDocumentType<T extends CmsConfigToDocument<dynamic>> {
  /// Unique identifier for this document type
  final String name;
  /// Display title for this document type
  final String title;
  /// Description of this document type
  final String description;
  /// List of fields for this document type
  final List<CmsField> fields;
  /// Required builder function to create a widget from the config data
  final Widget Function(Map<String, dynamic> data) builder;
  /// Tile builder function for displaying a summary tile
  final Widget Function(Map<String, dynamic> data) tileBuilder;
  /// Function to create a default instance of T
  final T? defaultValue;
  const CmsDocumentType({
    required this.name,
    required this.title,
    required this.description,
    required this.fields,
    required this.builder,
    required this.tileBuilder,
    this.defaultValue,
  });
}
