import 'package:solidart/solidart.dart';
import '../models/schema_model.dart';
import '../models/content_model.dart';
import '../models/session_model.dart';
import '../models/studio_exceptions.dart';

/// Central reactive state management service using SolidArt signals
/// Replaces event bus pattern with reactive signal-based state management
class StudioStateService {
  static final StudioStateService _instance = StudioStateService._internal();
  static StudioStateService get instance => _instance;

  StudioStateService._internal() {
    _initializeEffects();
  }

  // Core Data Signals
  final Signal<List<StudioSchema>> schemas = Signal<List<StudioSchema>>([]);
  final Signal<List<StudioContent>> content = Signal<List<StudioContent>>([]);
  final Signal<StudioSession?> currentSession = Signal<StudioSession?>(null);

  // UI State Signals
  final Signal<String?> selectedSchemaId = Signal<String?>(null);
  final Signal<String?> selectedContentId = Signal<String?>(null);
  final Signal<ThemeMode> currentTheme = Signal<ThemeMode>(ThemeMode.system);
  final Signal<bool> isSidebarVisible = Signal<bool>(true);
  final Signal<bool> isContentListVisible = Signal<bool>(true);

  // Operation State Signals
  final Signal<bool> isLoading = Signal<bool>(false);
  final Signal<bool> isSaving = Signal<bool>(false);
  final Signal<bool> isSyncing = Signal<bool>(false);
  final Signal<List<StudioException>> errors = Signal<List<StudioException>>([]);

  // Computed Signals
  late final ReadSignal<StudioSchema?> selectedSchema = Computed(() {
    final schemaId = selectedSchemaId.value;
    if (schemaId == null) return null;
    return schemas.value.cast<StudioSchema?>().firstWhere(
      (schema) => schema?.id == schemaId,
      orElse: () => null,
    );
  });

  late final ReadSignal<StudioContent?> selectedContent = Computed(() {
    final contentId = selectedContentId.value;
    if (contentId == null) return null;
    return content.value.cast<StudioContent?>().firstWhere(
      (content) => content?.id == contentId,
      orElse: () => null,
    );
  });

  late final ReadSignal<List<StudioContent>> contentForSelectedSchema = Computed(() {
    final schemaId = selectedSchemaId.value;
    if (schemaId == null) return [];
    return content.value.where((content) => content.schemaId == schemaId).toList();
  });

  late final ReadSignal<bool> hasUnsavedChanges = Computed(() {
    return content.value.any((content) => content.syncState == SyncState.local) ||
           schemas.value.any((schema) => schema.metadata.version == '0');
  });

  late final ReadSignal<int> errorCount = Computed(() => errors.value.length);

  late final ReadSignal<WorkspaceState> workspaceState = Computed(() {
    final session = currentSession.value;
    return session?.workspace ?? const WorkspaceState();
  });

  /// Initialize reactive effects for cross-signal synchronization
  void _initializeEffects() {
    // Sync selected schema changes with session
    Effect((_) {
      final session = currentSession.value;
      final selectedId = selectedSchemaId.value;

      if (session != null && session.workspace.activeSchemaId != selectedId) {
        currentSession.value = session.copyWith(
          workspace: session.workspace.copyWith(activeSchemaId: selectedId),
          lastAccessed: DateTime.now(),
        );
      }
    });

    // Sync selected content changes with session
    Effect((_) {
      final session = currentSession.value;
      final selectedId = selectedContentId.value;

      if (session != null && session.workspace.activeContentId != selectedId) {
        currentSession.value = session.copyWith(
          workspace: session.workspace.copyWith(activeContentId: selectedId),
          lastAccessed: DateTime.now(),
        );
      }
    });

    // Sync theme changes with session
    Effect((_) {
      final session = currentSession.value;
      final theme = currentTheme.value;

      if (session != null && session.workspace.theme != theme) {
        currentSession.value = session.copyWith(
          workspace: session.workspace.copyWith(theme: theme),
          lastAccessed: DateTime.now(),
        );
      }
    });

    // Auto-clear errors after 10 seconds
    Effect((_) {
      final currentErrors = errors.value;
      if (currentErrors.isNotEmpty) {
        Future.delayed(const Duration(seconds: 10), () {
          clearErrors();
        });
      }
    });
  }

  // Schema Management Methods
  void addSchema(StudioSchema schema) {
    schemas.value = [...schemas.value, schema];
  }

  void updateSchema(StudioSchema updatedSchema) {
    final currentSchemas = schemas.value;
    final index = currentSchemas.indexWhere((s) => s.id == updatedSchema.id);

    if (index != -1) {
      final newSchemas = List<StudioSchema>.from(currentSchemas);
      newSchemas[index] = updatedSchema;
      schemas.value = newSchemas;
    }
  }

  void removeSchema(String schemaId) {
    schemas.value = schemas.value.where((s) => s.id != schemaId).toList();

    // Clear selection if removed schema was selected
    if (selectedSchemaId.value == schemaId) {
      selectedSchemaId.value = null;
    }

    // Remove associated content
    content.value = content.value.where((c) => c.schemaId != schemaId).toList();
  }

  // Content Management Methods
  void addContent(StudioContent contentItem) {
    content.value = [...content.value, contentItem];
  }

  void updateContent(StudioContent updatedContent) {
    final currentContent = content.value;
    final index = currentContent.indexWhere((c) => c.id == updatedContent.id);

    if (index != -1) {
      final newContent = List<StudioContent>.from(currentContent);
      newContent[index] = updatedContent;
      content.value = newContent;
    }
  }

  void removeContent(String contentId) {
    content.value = content.value.where((c) => c.id != contentId).toList();

    // Clear selection if removed content was selected
    if (selectedContentId.value == contentId) {
      selectedContentId.value = null;
    }
  }

  // Selection Management
  void selectSchema(String? schemaId) {
    selectedSchemaId.value = schemaId;
    // Clear content selection when schema changes
    selectedContentId.value = null;
  }

  void selectContent(String? contentId) {
    selectedContentId.value = contentId;
  }

  // UI State Management
  void setTheme(ThemeMode theme) {
    currentTheme.value = theme;
  }

  void toggleSidebar() {
    isSidebarVisible.value = !isSidebarVisible.value;
  }

  void toggleContentList() {
    isContentListVisible.value = !isContentListVisible.value;
  }

  void setSidebarVisibility(bool visible) {
    isSidebarVisible.value = visible;
  }

  void setContentListVisibility(bool visible) {
    isContentListVisible.value = visible;
  }

  // Session Management
  void setCurrentSession(StudioSession session) {
    currentSession.value = session;

    // Sync workspace state to UI signals
    final workspace = session.workspace;
    selectedSchemaId.value = workspace.activeSchemaId;
    selectedContentId.value = workspace.activeContentId;
    currentTheme.value = workspace.theme;
    isSidebarVisible.value = workspace.layout.sidebarVisible;
    isContentListVisible.value = workspace.layout.contentListVisible;
  }

  void updateSessionPreference(String key, dynamic value) {
    final session = currentSession.value;
    if (session != null) {
      currentSession.value = session.updatePreference(key, value);
    }
  }

  void addRecentDocument(String documentId) {
    final session = currentSession.value;
    if (session != null) {
      currentSession.value = session.addRecentDocument(documentId);
    }
  }

  // Operation State Management
  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void setSaving(bool saving) {
    isSaving.value = saving;
  }

  void setSyncing(bool syncing) {
    isSyncing.value = syncing;
  }

  // Error Management
  void addError(StudioException error) {
    errors.value = [...errors.value, error];
  }

  void removeError(StudioException error) {
    errors.value = errors.value.where((e) => e != error).toList();
  }

  void clearErrors() {
    errors.value = [];
  }

  // Bulk Operations
  void setSchemas(List<StudioSchema> newSchemas) {
    schemas.value = newSchemas;
  }

  void setContent(List<StudioContent> newContent) {
    content.value = newContent;
  }

  void resetState() {
    schemas.value = [];
    content.value = [];
    currentSession.value = null;
    selectedSchemaId.value = null;
    selectedContentId.value = null;
    currentTheme.value = ThemeMode.system;
    isSidebarVisible.value = true;
    isContentListVisible.value = true;
    isLoading.value = false;
    isSaving.value = false;
    isSyncing.value = false;
    errors.value = [];
  }

  // Search and Filter Methods
  List<StudioSchema> searchSchemas(String query) {
    if (query.isEmpty) return schemas.value;

    final lowercaseQuery = query.toLowerCase();
    return schemas.value.where((schema) {
      return schema.name.toLowerCase().contains(lowercaseQuery) ||
             schema.title.toLowerCase().contains(lowercaseQuery) ||
             (schema.description?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  List<StudioContent> searchContent(String query, {String? schemaId}) {
    var searchContent = schemaId != null
        ? content.value.where((c) => c.schemaId == schemaId).toList()
        : content.value;

    if (query.isEmpty) return searchContent;

    final lowercaseQuery = query.toLowerCase();
    return searchContent.where((content) {
      // Search in data values
      return content.data.values.any((value) {
        return value.toString().toLowerCase().contains(lowercaseQuery);
      }) || content.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  List<StudioContent> getContentByStatus(ContentStatus status) {
    return content.value.where((c) => c.status == status).toList();
  }
}