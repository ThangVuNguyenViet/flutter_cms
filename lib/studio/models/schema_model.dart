import 'field_model.dart';

/// Represents a document schema in CMS Studio
/// This is the main entity for defining content types and their structure
class StudioSchema {
  const StudioSchema({
    required this.id,
    required this.name,
    required this.title,
    this.description,
    required this.fields,
    required this.metadata,
    this.config = const StudioConfiguration(),
    this.generatedCode = '',
  });

  /// Unique identifier for the schema
  final String id;

  /// Schema name (used in code generation, must be valid Dart identifier)
  final String name;

  /// Human-readable display title
  final String title;

  /// Optional description of the schema
  final String? description;

  /// List of field definitions for this schema
  final List<StudioField> fields;

  /// Schema metadata (creation date, version, etc.)
  final SchemaMetadata metadata;

  /// Studio-specific configuration
  final StudioConfiguration config;

  /// Generated Flutter CMS code
  final String generatedCode;

  /// Create a copy of this schema with updated fields
  StudioSchema copyWith({
    String? id,
    String? name,
    String? title,
    String? description,
    List<StudioField>? fields,
    SchemaMetadata? metadata,
    StudioConfiguration? config,
    String? generatedCode,
  }) {
    return StudioSchema(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      fields: fields ?? this.fields,
      metadata: metadata ?? this.metadata,
      config: config ?? this.config,
      generatedCode: generatedCode ?? this.generatedCode,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'fields': fields.map((f) => f.toJson()).toList(),
      'metadata': metadata.toJson(),
      'config': config.toJson(),
      'generatedCode': generatedCode,
    };
  }

  /// Create from JSON
  factory StudioSchema.fromJson(Map<String, dynamic> json) {
    return StudioSchema(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      fields: (json['fields'] as List<dynamic>)
          .map((f) => StudioField.fromJson(f as Map<String, dynamic>))
          .toList(),
      metadata: SchemaMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      config: json['config'] != null
          ? StudioConfiguration.fromJson(json['config'] as Map<String, dynamic>)
          : const StudioConfiguration(),
      generatedCode: json['generatedCode'] as String? ?? '',
    );
  }

  /// Validate this schema for correctness
  List<String> validate() {
    final errors = <String>[];

    // Name validation (Dart identifier rules)
    if (name.isEmpty || !RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(name)) {
      errors.add('Schema name must be a valid Dart identifier');
    }

    // Title validation
    if (title.isEmpty || title.length > 100) {
      errors.add('Schema title must be 1-100 characters');
    }

    // Must have at least one field
    if (fields.isEmpty) {
      errors.add('Schema must have at least one field');
    }

    // Field name uniqueness
    final fieldNames = fields.map((f) => f.name).toList();
    final uniqueNames = fieldNames.toSet();
    if (fieldNames.length != uniqueNames.length) {
      errors.add('Field names must be unique within schema');
    }

    // Validate each field
    for (final field in fields) {
      errors.addAll(field.validate());
    }

    return errors;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudioSchema && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StudioSchema(id: $id, name: $name, title: $title)';
}

/// Metadata associated with a schema
class SchemaMetadata {
  const SchemaMetadata({
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.author,
    this.tags = const [],
  });

  final DateTime createdAt;
  final DateTime updatedAt;
  final String version;
  final String? author;
  final List<String> tags;

  SchemaMetadata copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    String? version,
    String? author,
    List<String>? tags,
  }) {
    return SchemaMetadata(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      author: author ?? this.author,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'version': version,
      'author': author,
      'tags': tags,
    };
  }

  factory SchemaMetadata.fromJson(Map<String, dynamic> json) {
    return SchemaMetadata(
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: json['version'] as String,
      author: json['author'] as String?,
      tags: (json['tags'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}

/// Studio-specific configuration for schemas
class StudioConfiguration {
  const StudioConfiguration({
    this.icon,
    this.preview,
    this.listView = const {},
    this.editView = const {},
  });

  final String? icon;
  final String? preview;
  final Map<String, dynamic> listView;
  final Map<String, dynamic> editView;

  StudioConfiguration copyWith({
    String? icon,
    String? preview,
    Map<String, dynamic>? listView,
    Map<String, dynamic>? editView,
  }) {
    return StudioConfiguration(
      icon: icon ?? this.icon,
      preview: preview ?? this.preview,
      listView: listView ?? this.listView,
      editView: editView ?? this.editView,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'preview': preview,
      'listView': listView,
      'editView': editView,
    };
  }

  factory StudioConfiguration.fromJson(Map<String, dynamic> json) {
    return StudioConfiguration(
      icon: json['icon'] as String?,
      preview: json['preview'] as String?,
      listView: json['listView'] as Map<String, dynamic>? ?? {},
      editView: json['editView'] as Map<String, dynamic>? ?? {},
    );
  }
}