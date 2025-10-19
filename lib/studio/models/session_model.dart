/// Represents a user session in CMS Studio
/// Manages workspace state, preferences, and session data
class StudioSession {
  const StudioSession({
    required this.userId,
    required this.lastAccessed,
    required this.workspace,
    this.recentDocuments = const [],
    this.preferences = const {},
    this.syncConfig = const SyncConfiguration(),
  });

  /// User identifier for this session
  final String userId;

  /// Last time this session was accessed
  final DateTime lastAccessed;

  /// Workspace state and layout configuration
  final WorkspaceState workspace;

  /// Recently accessed content document IDs
  final List<String> recentDocuments;

  /// User preferences as key-value pairs
  final Map<String, dynamic> preferences;

  /// Synchronization configuration
  final SyncConfiguration syncConfig;

  /// Create a copy of this session with updated fields
  StudioSession copyWith({
    String? userId,
    DateTime? lastAccessed,
    WorkspaceState? workspace,
    List<String>? recentDocuments,
    Map<String, dynamic>? preferences,
    SyncConfiguration? syncConfig,
  }) {
    return StudioSession(
      userId: userId ?? this.userId,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      workspace: workspace ?? this.workspace,
      recentDocuments: recentDocuments ?? List<String>.from(this.recentDocuments),
      preferences: preferences ?? Map<String, dynamic>.from(this.preferences),
      syncConfig: syncConfig ?? this.syncConfig,
    );
  }

  /// Add a document to recent documents (LRU behavior)
  StudioSession addRecentDocument(String documentId) {
    final newRecent = List<String>.from(recentDocuments);
    newRecent.remove(documentId); // Remove if already exists
    newRecent.insert(0, documentId); // Add to front

    // Keep only the last 10 documents
    if (newRecent.length > 10) {
      newRecent.removeRange(10, newRecent.length);
    }

    return copyWith(
      recentDocuments: newRecent,
      lastAccessed: DateTime.now(),
    );
  }

  /// Update a preference value
  StudioSession updatePreference(String key, dynamic value) {
    final newPreferences = Map<String, dynamic>.from(preferences);
    newPreferences[key] = value;

    return copyWith(
      preferences: newPreferences,
      lastAccessed: DateTime.now(),
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'lastAccessed': lastAccessed.toIso8601String(),
      'workspace': workspace.toJson(),
      'recentDocuments': recentDocuments,
      'preferences': preferences,
      'syncConfig': syncConfig.toJson(),
    };
  }

  /// Create from JSON
  factory StudioSession.fromJson(Map<String, dynamic> json) {
    return StudioSession(
      userId: json['userId'] as String,
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
      workspace: WorkspaceState.fromJson(json['workspace'] as Map<String, dynamic>),
      recentDocuments: (json['recentDocuments'] as List<dynamic>? ?? []).cast<String>(),
      preferences: Map<String, dynamic>.from(json['preferences'] as Map<String, dynamic>? ?? {}),
      syncConfig: json['syncConfig'] != null
          ? SyncConfiguration.fromJson(json['syncConfig'] as Map<String, dynamic>)
          : const SyncConfiguration(),
    );
  }

  @override
  String toString() => 'StudioSession(userId: $userId, lastAccessed: $lastAccessed)';
}

/// Workspace state for UI layout and preferences
class WorkspaceState {
  const WorkspaceState({
    this.activeSchemaId,
    this.activeContentId,
    this.layout = const PanelLayout(),
    this.filters = const {},
    this.theme = ThemeMode.system,
  });

  /// Currently selected schema ID
  final String? activeSchemaId;

  /// Currently editing content ID
  final String? activeContentId;

  /// Three-pane layout configuration
  final PanelLayout layout;

  /// Content list filters by schema
  final Map<String, FilterState> filters;

  /// Theme preference
  final ThemeMode theme;

  WorkspaceState copyWith({
    String? activeSchemaId,
    String? activeContentId,
    PanelLayout? layout,
    Map<String, FilterState>? filters,
    ThemeMode? theme,
  }) {
    return WorkspaceState(
      activeSchemaId: activeSchemaId ?? this.activeSchemaId,
      activeContentId: activeContentId ?? this.activeContentId,
      layout: layout ?? this.layout,
      filters: filters ?? Map<String, FilterState>.from(this.filters),
      theme: theme ?? this.theme,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeSchemaId': activeSchemaId,
      'activeContentId': activeContentId,
      'layout': layout.toJson(),
      'filters': filters.map((k, v) => MapEntry(k, v.toJson())),
      'theme': theme.name,
    };
  }

  factory WorkspaceState.fromJson(Map<String, dynamic> json) {
    final filtersJson = json['filters'] as Map<String, dynamic>? ?? {};
    final filters = filtersJson.map(
      (k, v) => MapEntry(k, FilterState.fromJson(v as Map<String, dynamic>)),
    );

    return WorkspaceState(
      activeSchemaId: json['activeSchemaId'] as String?,
      activeContentId: json['activeContentId'] as String?,
      layout: json['layout'] != null
          ? PanelLayout.fromJson(json['layout'] as Map<String, dynamic>)
          : const PanelLayout(),
      filters: filters,
      theme: ThemeMode.values.byName(json['theme'] as String? ?? 'system'),
    );
  }
}

/// Theme mode for the studio
enum ThemeMode {
  light('Light'),
  dark('Dark'),
  system('System');

  const ThemeMode(this.label);
  final String label;
}

/// Panel layout configuration for three-pane layout
class PanelLayout {
  const PanelLayout({
    this.sidebarWidth = 250.0,
    this.contentListWidth = 400.0,
    this.sidebarVisible = true,
    this.contentListVisible = true,
  });

  final double sidebarWidth;
  final double contentListWidth;
  final bool sidebarVisible;
  final bool contentListVisible;

  PanelLayout copyWith({
    double? sidebarWidth,
    double? contentListWidth,
    bool? sidebarVisible,
    bool? contentListVisible,
  }) {
    return PanelLayout(
      sidebarWidth: sidebarWidth ?? this.sidebarWidth,
      contentListWidth: contentListWidth ?? this.contentListWidth,
      sidebarVisible: sidebarVisible ?? this.sidebarVisible,
      contentListVisible: contentListVisible ?? this.contentListVisible,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sidebarWidth': sidebarWidth,
      'contentListWidth': contentListWidth,
      'sidebarVisible': sidebarVisible,
      'contentListVisible': contentListVisible,
    };
  }

  factory PanelLayout.fromJson(Map<String, dynamic> json) {
    return PanelLayout(
      sidebarWidth: (json['sidebarWidth'] as num?)?.toDouble() ?? 250.0,
      contentListWidth: (json['contentListWidth'] as num?)?.toDouble() ?? 400.0,
      sidebarVisible: json['sidebarVisible'] as bool? ?? true,
      contentListVisible: json['contentListVisible'] as bool? ?? true,
    );
  }
}

/// Filter state for content lists
class FilterState {
  const FilterState({
    this.status,
    this.searchQuery = '',
    this.tags = const [],
    this.dateRange,
  });

  final String? status;
  final String searchQuery;
  final List<String> tags;
  final DateRange? dateRange;

  FilterState copyWith({
    String? status,
    String? searchQuery,
    List<String>? tags,
    DateRange? dateRange,
  }) {
    return FilterState(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      tags: tags ?? List<String>.from(this.tags),
      dateRange: dateRange ?? this.dateRange,
    );
  }

  bool get hasActiveFilters {
    return status != null ||
        searchQuery.isNotEmpty ||
        tags.isNotEmpty ||
        dateRange != null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'searchQuery': searchQuery,
      'tags': tags,
      'dateRange': dateRange?.toJson(),
    };
  }

  factory FilterState.fromJson(Map<String, dynamic> json) {
    return FilterState(
      status: json['status'] as String?,
      searchQuery: json['searchQuery'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>? ?? []).cast<String>(),
      dateRange: json['dateRange'] != null
          ? DateRange.fromJson(json['dateRange'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Date range for filtering
class DateRange {
  const DateRange({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;

  Map<String, dynamic> toJson() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );
  }
}

/// Synchronization configuration
class SyncConfiguration {
  const SyncConfiguration({
    this.autoSync = true,
    this.syncInterval = const Duration(minutes: 5),
    this.maxRetries = 3,
  });

  final bool autoSync;
  final Duration syncInterval;
  final int maxRetries;

  SyncConfiguration copyWith({
    bool? autoSync,
    Duration? syncInterval,
    int? maxRetries,
  }) {
    return SyncConfiguration(
      autoSync: autoSync ?? this.autoSync,
      syncInterval: syncInterval ?? this.syncInterval,
      maxRetries: maxRetries ?? this.maxRetries,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoSync': autoSync,
      'syncInterval': syncInterval.inMinutes,
      'maxRetries': maxRetries,
    };
  }

  factory SyncConfiguration.fromJson(Map<String, dynamic> json) {
    return SyncConfiguration(
      autoSync: json['autoSync'] as bool? ?? true,
      syncInterval: Duration(minutes: json['syncInterval'] as int? ?? 5),
      maxRetries: json['maxRetries'] as int? ?? 3,
    );
  }
}