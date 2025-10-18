/// Represents a content instance in CMS Studio
/// Content instances conform to a specific schema definition
class StudioContent {
  const StudioContent({
    required this.id,
    required this.schemaId,
    required this.data,
    required this.metadata,
    this.status = ContentStatus.draft,
    this.syncState = SyncState.local,
    this.conflictData,
    this.tags = const [],
  });

  /// Unique identifier for this content instance
  final String id;

  /// Reference to the schema this content conforms to
  final String schemaId;

  /// Content field values as key-value pairs
  final Map<String, dynamic> data;

  /// Content metadata (creation date, author, etc.)
  final ContentMetadata metadata;

  /// Current publication status
  final ContentStatus status;

  /// Current synchronization state
  final SyncState syncState;

  /// Server version data for conflict resolution (when conflicts exist)
  final Map<String, dynamic>? conflictData;

  /// Optional content tags
  final List<String> tags;

  /// Create a copy of this content with updated fields
  StudioContent copyWith({
    String? id,
    String? schemaId,
    Map<String, dynamic>? data,
    ContentMetadata? metadata,
    ContentStatus? status,
    SyncState? syncState,
    Map<String, dynamic>? conflictData,
    List<String>? tags,
  }) {
    return StudioContent(
      id: id ?? this.id,
      schemaId: schemaId ?? this.schemaId,
      data: data ?? Map<String, dynamic>.from(this.data),
      metadata: metadata ?? this.metadata,
      status: status ?? this.status,
      syncState: syncState ?? this.syncState,
      conflictData: conflictData ?? this.conflictData,
      tags: tags ?? List<String>.from(this.tags),
    );
  }

  /// Update a specific field value
  StudioContent updateField(String fieldName, dynamic value) {
    final newData = Map<String, dynamic>.from(data);
    newData[fieldName] = value;

    return copyWith(
      data: newData,
      metadata: metadata.copyWith(updatedAt: DateTime.now()),
      syncState: SyncState.local, // Mark as local when modified
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schemaId': schemaId,
      'data': data,
      'metadata': metadata.toJson(),
      'status': status.name,
      'syncState': syncState.name,
      'conflictData': conflictData,
      'tags': tags,
    };
  }

  /// Create from JSON
  factory StudioContent.fromJson(Map<String, dynamic> json) {
    return StudioContent(
      id: json['id'] as String,
      schemaId: json['schemaId'] as String,
      data: Map<String, dynamic>.from(json['data'] as Map<String, dynamic>),
      metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      status: ContentStatus.values.byName(json['status'] as String),
      syncState: SyncState.values.byName(json['syncState'] as String),
      conflictData: json['conflictData'] as Map<String, dynamic>?,
      tags: (json['tags'] as List<dynamic>? ?? []).cast<String>(),
    );
  }

  /// Get display title from content data
  String get displayTitle {
    // Try common title fields in order of preference
    const titleFields = ['title', 'name', 'label', 'headline'];

    for (final field in titleFields) {
      final value = data[field];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    // Fallback to first string field or content ID
    for (final entry in data.entries) {
      if (entry.value is String && (entry.value as String).isNotEmpty) {
        return entry.value as String;
      }
    }

    return 'Untitled ($id)';
  }

  /// Get content excerpt for preview
  String get excerpt {
    const excerptFields = ['excerpt', 'description', 'body', 'content'];

    for (final field in excerptFields) {
      final value = data[field];
      if (value is String && value.isNotEmpty) {
        final text = value.replaceAll(RegExp(r'<[^>]*>'), ''); // Strip HTML tags
        return text.length > 100 ? '${text.substring(0, 100)}...' : text;
      }
    }

    return '';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudioContent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StudioContent(id: $id, schemaId: $schemaId, status: $status)';
}

/// Content publication status
enum ContentStatus {
  draft('Draft'),
  published('Published'),
  archived('Archived'),
  deleted('Deleted');

  const ContentStatus(this.label);
  final String label;
}

/// Content synchronization state
enum SyncState {
  local('Local'),
  syncing('Syncing'),
  synced('Synced'),
  conflict('Conflict'),
  error('Error');

  const SyncState(this.label);
  final String label;
}

/// Metadata associated with content
class ContentMetadata {
  const ContentMetadata({
    required this.createdAt,
    required this.updatedAt,
    this.author,
    this.version = 1,
    this.slug,
  });

  final DateTime createdAt;
  final DateTime updatedAt;
  final String? author;
  final int version;
  final String? slug;

  ContentMetadata copyWith({
    DateTime? createdAt,
    DateTime? updatedAt,
    String? author,
    int? version,
    String? slug,
  }) {
    return ContentMetadata(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      author: author ?? this.author,
      version: version ?? this.version,
      slug: slug ?? this.slug,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'author': author,
      'version': version,
      'slug': slug,
    };
  }

  factory ContentMetadata.fromJson(Map<String, dynamic> json) {
    return ContentMetadata(
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      author: json['author'] as String?,
      version: json['version'] as int? ?? 1,
      slug: json['slug'] as String?,
    );
  }
}

/// Summary view of content for list displays
class ContentSummary {
  const ContentSummary({
    required this.id,
    required this.schemaId,
    required this.title,
    required this.status,
    required this.metadata,
    required this.syncState,
    this.excerpt = '',
  });

  final String id;
  final String schemaId;
  final String title;
  final ContentStatus status;
  final ContentMetadata metadata;
  final SyncState syncState;
  final String excerpt;

  factory ContentSummary.fromContent(StudioContent content) {
    return ContentSummary(
      id: content.id,
      schemaId: content.schemaId,
      title: content.displayTitle,
      status: content.status,
      metadata: content.metadata,
      syncState: content.syncState,
      excerpt: content.excerpt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schemaId': schemaId,
      'title': title,
      'status': status.name,
      'metadata': metadata.toJson(),
      'syncState': syncState.name,
      'excerpt': excerpt,
    };
  }

  factory ContentSummary.fromJson(Map<String, dynamic> json) {
    return ContentSummary(
      id: json['id'] as String,
      schemaId: json['schemaId'] as String,
      title: json['title'] as String,
      status: ContentStatus.values.byName(json['status'] as String),
      metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      syncState: SyncState.values.byName(json['syncState'] as String),
      excerpt: json['excerpt'] as String? ?? '',
    );
  }
}