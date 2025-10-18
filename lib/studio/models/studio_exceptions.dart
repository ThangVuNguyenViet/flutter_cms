/// Custom exception classes for CMS Studio operations
/// Provides structured error handling with context and recovery information
library;

/// Base exception class for all studio operations
abstract class StudioException implements Exception {
  const StudioException(this.message, {this.context, this.cause});

  final String message;
  final String? context;
  final Object? cause;

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType: $message');
    if (context != null) buffer.write(' (Context: $context)');
    if (cause != null) buffer.write(' (Caused by: $cause)');
    return buffer.toString();
  }
}

// Schema Exceptions
class SchemaNotFoundException extends StudioException {
  const SchemaNotFoundException(String schemaId, {String? context})
      : super('Schema not found: $schemaId', context: context);
}

class DuplicateSchemaException extends StudioException {
  const DuplicateSchemaException(String schemaName, {String? context})
      : super('Schema name already exists: $schemaName', context: context);
}

class SchemaValidationException extends StudioException {
  const SchemaValidationException(this.errors, {String? context})
      : super('Schema validation failed', context: context);

  final List<String> errors;

  @override
  String toString() {
    return '$runtimeType: $message\nErrors:\n${errors.map((e) => '  - $e').join('\n')}';
  }
}

class SchemaInUseException extends StudioException {
  const SchemaInUseException(String schemaId, this.contentCount, {String? context})
      : super('Cannot delete schema $schemaId: has $contentCount content instances', context: context);

  final int contentCount;
}

// Content Exceptions
class ContentNotFoundException extends StudioException {
  const ContentNotFoundException(String contentId, {String? context})
      : super('Content not found: $contentId', context: context);
}

class ContentValidationException extends StudioException {
  const ContentValidationException(this.errors, {String? context})
      : super('Content validation failed', context: context);

  final List<String> errors;

  @override
  String toString() {
    return '$runtimeType: $message\nErrors:\n${errors.map((e) => '  - $e').join('\n')}';
  }
}

class VersionConflictException extends StudioException {
  const VersionConflictException(String contentId, this.localVersion, this.remoteVersion, {String? context})
      : super('Version conflict for content $contentId: local=$localVersion, remote=$remoteVersion', context: context);

  final int localVersion;
  final int remoteVersion;
}

class ContentStatusException extends StudioException {
  const ContentStatusException(String contentId, String currentStatus, String targetStatus, {String? context})
      : super('Cannot change content $contentId from $currentStatus to $targetStatus', context: context);
}

// Field Exceptions
class FieldValidationException extends StudioException {
  const FieldValidationException(String fieldName, String fieldType, this.validationErrors, {String? context})
      : super('Field validation failed for $fieldName ($fieldType)', context: context);

  final List<String> validationErrors;

  @override
  String toString() {
    return '$runtimeType: $message\nValidation Errors:\n${validationErrors.map((e) => '  - $e').join('\n')}';
  }
}

class UnsupportedFieldTypeException extends StudioException {
  const UnsupportedFieldTypeException(String fieldType, {String? context})
      : super('Unsupported field type: $fieldType', context: context);
}

class RequiredFieldException extends StudioException {
  const RequiredFieldException(String fieldName, {String? context})
      : super('Required field missing: $fieldName', context: context);
}

// Storage Exceptions
class StorageException extends StudioException {
  const StorageException(String operation, {String? context, Object? cause})
      : super('Storage operation failed: $operation', context: context, cause: cause);
}

class StorageInitializationException extends StudioException {
  const StorageInitializationException({String? context, Object? cause})
      : super('Failed to initialize storage', context: context, cause: cause);
}

class DataCorruptionException extends StudioException {
  const DataCorruptionException(String entityType, String entityId, {String? context})
      : super('Data corruption detected for $entityType: $entityId', context: context);
}

class StorageQuotaExceededException extends StudioException {
  const StorageQuotaExceededException({String? context})
      : super('Storage quota exceeded', context: context);
}

// Sync Exceptions
class SyncException extends StudioException {
  const SyncException(String operation, {String? context, Object? cause})
      : super('Sync operation failed: $operation', context: context, cause: cause);
}

class NetworkException extends StudioException {
  const NetworkException({String? context, Object? cause})
      : super('Network operation failed', context: context, cause: cause);
}

class AuthenticationException extends StudioException {
  const AuthenticationException({String? context})
      : super('Authentication failed', context: context);
}

class SyncConflictException extends StudioException {
  const SyncConflictException(String entityType, String entityId, {String? context})
      : super('Sync conflict detected for $entityType: $entityId', context: context);
}

// Code Generation Exceptions
class CodeGenerationException extends StudioException {
  const CodeGenerationException(String schemaId, {String? context, Object? cause})
      : super('Code generation failed for schema: $schemaId', context: context, cause: cause);
}

class TemplateException extends StudioException {
  const TemplateException(String templateName, {String? context, Object? cause})
      : super('Template error: $templateName', context: context, cause: cause);
}

// Service Exceptions
class ServiceNotRegisteredException extends StudioException {
  const ServiceNotRegisteredException(Type serviceType, {String? context})
      : super('Service not registered: $serviceType', context: context);
}

class ServiceInitializationException extends StudioException {
  const ServiceInitializationException(Type serviceType, {String? context, Object? cause})
      : super('Service initialization failed: $serviceType', context: context, cause: cause);
}

// Configuration Exceptions
class ConfigurationException extends StudioException {
  const ConfigurationException(String setting, {String? context})
      : super('Invalid configuration: $setting', context: context);
}

class MissingConfigurationException extends StudioException {
  const MissingConfigurationException(String setting, {String? context})
      : super('Required configuration missing: $setting', context: context);
}

// Workspace Exceptions
class WorkspaceException extends StudioException {
  const WorkspaceException(String operation, {String? context, Object? cause})
      : super('Workspace operation failed: $operation', context: context, cause: cause);
}

class InvalidWorkspaceStateException extends StudioException {
  const InvalidWorkspaceStateException({String? context})
      : super('Invalid workspace state', context: context);
}

// Generic Exceptions
class UnexpectedException extends StudioException {
  const UnexpectedException({String? context, Object? cause})
      : super('An unexpected error occurred', context: context, cause: cause);
}

class OperationCancelledException extends StudioException {
  const OperationCancelledException(String operation, {String? context})
      : super('Operation cancelled: $operation', context: context);
}

class TimeoutException extends StudioException {
  const TimeoutException(String operation, {String? context})
      : super('Operation timed out: $operation', context: context);
}

// Validation Helper Functions
class ValidationError {
  const ValidationError(this.field, this.message, {this.value});

  final String field;
  final String message;
  final dynamic value;

  @override
  String toString() => '$field: $message';
}

class ValidationResult {
  const ValidationResult({
    this.isValid = true,
    this.errors = const [],
  });

  final bool isValid;
  final List<ValidationError> errors;

  bool get hasErrors => errors.isNotEmpty;

  ValidationResult copyWith({
    bool? isValid,
    List<ValidationError>? errors,
  }) {
    return ValidationResult(
      isValid: isValid ?? this.isValid,
      errors: errors ?? this.errors,
    );
  }

  ValidationResult addError(ValidationError error) {
    return ValidationResult(
      isValid: false,
      errors: [...errors, error],
    );
  }

  ValidationResult addErrors(List<ValidationError> newErrors) {
    return ValidationResult(
      isValid: newErrors.isEmpty && isValid,
      errors: [...errors, ...newErrors],
    );
  }
}