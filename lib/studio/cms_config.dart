import 'package:flutter/widgets.dart';

import '../models/fields.dart';

/// Represents a document type (schema) in the CMS
class CmsDocumentType<T> {
  /// Unique identifier for this document type
  final String name;

  /// Display title for this document type
  final String title;

  /// Description of this document type
  final String description;

  /// List of field configurations for this document type
  final List<CmsFieldConfig> fields;

  /// Optional builder function to create a widget from the config data
  final Widget Function(T config)? builder;

  const CmsDocumentType({
    required this.name,
    required this.title,
    required this.description,
    required this.fields,
    this.builder,
  });

  /// Creates a copy of this document type with the given fields replaced
  CmsDocumentType<T> copyWith({
    String? name,
    String? title,
    String? description,
    List<CmsFieldConfig>? fields,
    Widget Function(T config)? builder,
  }) {
    return CmsDocumentType<T>(
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      fields: fields ?? this.fields,
      builder: builder ?? this.builder,
    );
  }
}
