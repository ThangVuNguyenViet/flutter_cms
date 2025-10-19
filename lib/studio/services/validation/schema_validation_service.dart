import 'dart:async';
import '../../models/schema_model.dart';
import '../../models/field_model.dart';
import '../../models/studio_exceptions.dart';

/// Advanced schema validation service with comprehensive rule checking
/// Provides detailed validation for schema definitions and field configurations
class SchemaValidationService {
  static final SchemaValidationService _instance = SchemaValidationService._internal();
  static SchemaValidationService get instance => _instance;

  SchemaValidationService._internal();

  /// Reserved Dart keywords that cannot be used as field names
  static const Set<String> _dartKeywords = {
    'abstract', 'as', 'assert', 'async', 'await', 'base', 'bool', 'break',
    'case', 'catch', 'class', 'const', 'continue', 'covariant', 'default',
    'deferred', 'do', 'double', 'dynamic', 'else', 'enum', 'export',
    'extends', 'extension', 'external', 'factory', 'false', 'final',
    'finally', 'for', 'function', 'get', 'hide', 'if', 'implements',
    'import', 'in', 'int', 'interface', 'is', 'late', 'library', 'mixin',
    'new', 'null', 'on', 'operator', 'part', 'required', 'return', 'sealed',
    'set', 'show', 'static', 'super', 'switch', 'sync', 'this', 'throw',
    'true', 'try', 'type', 'typedef', 'var', 'void', 'when', 'while',
    'with', 'yield'
  };

  /// Common Flutter/CMS reserved names to avoid conflicts
  static const Set<String> _reservedNames = {
    'build', 'context', 'widget', 'state', 'data', 'key', 'child', 'children',
    'id', 'metadata', 'created', 'updated', 'version', 'schema', 'content',
    'type', 'value', 'name', 'title', 'description', 'options', 'validation'
  };

  /// Validate a complete schema with detailed error reporting
  Future<ValidationResult> validateSchema(StudioSchema schema) async {
    final errors = <ValidationError>[];

    // Basic schema validation
    errors.addAll(await _validateBasicSchema(schema));

    // Field validation
    errors.addAll(await _validateFields(schema.fields));

    // Cross-field validation
    errors.addAll(await _validateCrossFieldRules(schema));

    // Schema naming conventions
    errors.addAll(await _validateNamingConventions(schema));

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validate basic schema properties
  Future<List<ValidationError>> _validateBasicSchema(StudioSchema schema) async {
    final errors = <ValidationError>[];

    // Name validation
    if (schema.name.isEmpty) {
      errors.add(const ValidationError('name', 'Schema name cannot be empty'));
    } else if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(schema.name)) {
      errors.add(ValidationError('name',
        'Schema name must be a valid identifier (alphanumeric and underscore only): ${schema.name}'));
    } else if (_dartKeywords.contains(schema.name.toLowerCase())) {
      errors.add(ValidationError('name',
        'Schema name cannot be a Dart keyword: ${schema.name}'));
    } else if (_reservedNames.contains(schema.name.toLowerCase())) {
      errors.add(ValidationError('name',
        'Schema name is reserved and cannot be used: ${schema.name}'));
    }

    // Title validation
    if (schema.title.isEmpty) {
      errors.add(const ValidationError('title', 'Schema title cannot be empty'));
    } else if (schema.title.length > 100) {
      errors.add(const ValidationError('title', 'Schema title cannot exceed 100 characters'));
    }

    // Description validation
    if (schema.description != null && schema.description!.length > 500) {
      errors.add(const ValidationError('description',
        'Schema description cannot exceed 500 characters'));
    }

    // Fields validation
    if (schema.fields.isEmpty) {
      errors.add(const ValidationError('fields', 'Schema must have at least one field'));
    } else if (schema.fields.length > 100) {
      errors.add(const ValidationError('fields',
        'Schema cannot have more than 100 fields for performance reasons'));
    }

    return errors;
  }

  /// Validate individual fields
  Future<List<ValidationError>> _validateFields(List<StudioField> fields) async {
    final errors = <ValidationError>[];
    final fieldNames = <String>{};

    for (int i = 0; i < fields.length; i++) {
      final field = fields[i];
      final fieldPrefix = 'fields[$i]';

      // Field name validation
      if (field.name.isEmpty) {
        errors.add(ValidationError('$fieldPrefix.name', 'Field name cannot be empty'));
      } else if (!RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(field.name)) {
        errors.add(ValidationError('$fieldPrefix.name',
          'Field name must be a valid Dart identifier: ${field.name}'));
      } else if (_dartKeywords.contains(field.name.toLowerCase())) {
        errors.add(ValidationError('$fieldPrefix.name',
          'Field name cannot be a Dart keyword: ${field.name}'));
      } else if (_reservedNames.contains(field.name.toLowerCase())) {
        errors.add(ValidationError('$fieldPrefix.name',
          'Field name is reserved: ${field.name}'));
      } else if (fieldNames.contains(field.name)) {
        errors.add(ValidationError('$fieldPrefix.name',
          'Duplicate field name: ${field.name}'));
      } else {
        fieldNames.add(field.name);
      }

      // Field title validation
      if (field.title.isEmpty) {
        errors.add(ValidationError('$fieldPrefix.title',
          'Field title cannot be empty for field: ${field.name}'));
      } else if (field.title.length > 100) {
        errors.add(ValidationError('$fieldPrefix.title',
          'Field title cannot exceed 100 characters for field: ${field.name}'));
      }

      // Field description validation
      if (field.metadata.description != null && field.metadata.description!.length > 300) {
        errors.add(ValidationError('$fieldPrefix.description',
          'Field description cannot exceed 300 characters for field: ${field.name}'));
      }

      // Type-specific validation
      errors.addAll(await _validateFieldType(field, fieldPrefix));

      // Validation rules validation
      errors.addAll(await _validateFieldRules(field, fieldPrefix));
    }

    return errors;
  }

  /// Validate field type-specific rules
  Future<List<ValidationError>> _validateFieldType(StudioField field, String prefix) async {
    final errors = <ValidationError>[];

    switch (field.type) {
      case FieldType.string:
      case FieldType.text:
        // String fields can have max length validation
        final maxLength = field.options['maxLength'] as int?;
        if (maxLength != null && maxLength <= 0) {
          errors.add(ValidationError('$prefix.options.maxLength',
            'Max length must be positive for field: ${field.name}'));
        }
        break;

      case FieldType.number:
        // Number fields can have min/max validation
        final min = field.options['min'] as num?;
        final max = field.options['max'] as num?;
        if (min != null && max != null && min >= max) {
          errors.add(ValidationError('$prefix.options',
            'Min value must be less than max value for field: ${field.name}'));
        }
        break;

      case FieldType.array:
        // Array fields need item type specification
        final itemType = field.options['itemType'] as String?;
        if (itemType == null || itemType.isEmpty) {
          errors.add(ValidationError('$prefix.options.itemType',
            'Array field must specify item type for field: ${field.name}'));
        }

        final maxItems = field.options['maxItems'] as int?;
        if (maxItems != null && maxItems <= 0) {
          errors.add(ValidationError('$prefix.options.maxItems',
            'Max items must be positive for field: ${field.name}'));
        }
        break;

      case FieldType.reference:
        // Reference fields need target schema
        final targetSchema = field.options['targetSchema'] as String?;
        if (targetSchema == null || targetSchema.isEmpty) {
          errors.add(ValidationError('$prefix.options.targetSchema',
            'Reference field must specify target schema for field: ${field.name}'));
        }
        break;

      case FieldType.crossDatasetReference:
        // Cross-dataset references need dataset and schema
        final targetDataset = field.options['targetDataset'] as String?;
        final targetSchema = field.options['targetSchema'] as String?;

        if (targetDataset == null || targetDataset.isEmpty) {
          errors.add(ValidationError('$prefix.options.targetDataset',
            'Cross-dataset reference must specify target dataset for field: ${field.name}'));
        }

        if (targetSchema == null || targetSchema.isEmpty) {
          errors.add(ValidationError('$prefix.options.targetSchema',
            'Cross-dataset reference must specify target schema for field: ${field.name}'));
        }
        break;

      case FieldType.file:
      case FieldType.image:
        // File fields can have allowed types
        final allowedTypes = field.options['allowedTypes'] as List<String>?;
        if (allowedTypes != null && allowedTypes.isEmpty) {
          errors.add(ValidationError('$prefix.options.allowedTypes',
            'If specified, allowed types cannot be empty for field: ${field.name}'));
        }
        break;

      case FieldType.object:
        // Object fields can have nested field definitions
        final nestedFields = field.options['fields'] as List<dynamic>?;
        if (nestedFields != null && nestedFields.isNotEmpty) {
          // Validate nested fields (simplified validation)
          for (int i = 0; i < nestedFields.length; i++) {
            final nestedField = nestedFields[i];
            if (nestedField is! Map<String, dynamic>) {
              errors.add(ValidationError('$prefix.options.fields[$i]',
                'Nested field must be a valid field definition for field: ${field.name}'));
            }
          }
        }
        break;

      default:
        // Other field types don't need specific validation
        break;
    }

    return errors;
  }

  /// Validate field validation rules
  Future<List<ValidationError>> _validateFieldRules(StudioField field, String prefix) async {
    final errors = <ValidationError>[];

    for (int i = 0; i < field.validation.length; i++) {
      final rule = field.validation[i];
      final rulePrefix = '$prefix.validation[$i]';

      // Validate rule based on type
      switch (rule.type) {
        case ValidationType.required:
          // Required validation doesn't need additional value validation
          break;
        case ValidationType.minLength:
        case ValidationType.maxLength:
          if (rule.value is! int || (rule.value as int) < 0) {
            errors.add(ValidationError(rulePrefix,
              'Length validation value must be a non-negative integer for field: ${field.name}'));
          }
          break;

        case ValidationType.min:
        case ValidationType.max:
          if (rule.value is! num) {
            errors.add(ValidationError(rulePrefix,
              'Numeric validation value must be a number for field: ${field.name}'));
          }
          break;

        case ValidationType.pattern:
          if (rule.value is! String) {
            errors.add(ValidationError(rulePrefix,
              'Pattern validation value must be a string for field: ${field.name}'));
          } else {
            try {
              RegExp(rule.value as String);
            } catch (e) {
              errors.add(ValidationError(rulePrefix,
                'Pattern validation value must be a valid regex for field: ${field.name}'));
            }
          }
          break;

        case ValidationType.email:
        case ValidationType.url:
          // These don't need value validation
          break;

        case ValidationType.custom:
          if (rule.value is! String || (rule.value as String).isEmpty) {
            errors.add(ValidationError(rulePrefix,
              'Custom validation must specify a function name for field: ${field.name}'));
          }
          break;
      }
    }

    return errors;
  }

  /// Validate cross-field rules and relationships
  Future<List<ValidationError>> _validateCrossFieldRules(StudioSchema schema) async {
    final errors = <ValidationError>[];

    // Check for circular references
    errors.addAll(await _validateCircularReferences(schema));

    // Check for orphaned references
    errors.addAll(await _validateOrphanedReferences(schema));

    return errors;
  }

  /// Check for circular reference dependencies
  Future<List<ValidationError>> _validateCircularReferences(StudioSchema schema) async {
    final errors = <ValidationError>[];

    // Build reference graph
    final referenceMap = <String, Set<String>>{};

    for (final field in schema.fields) {
      if (field.type == FieldType.reference) {
        final targetSchema = field.options['targetSchema'] as String?;
        if (targetSchema != null) {
          referenceMap[schema.name] ??= <String>{};
          referenceMap[schema.name]!.add(targetSchema);
        }
      }
    }

    // Check for self-references (immediate circular reference)
    if (referenceMap[schema.name]?.contains(schema.name) == true) {
      errors.add(ValidationError('references',
        'Schema cannot reference itself directly: ${schema.name}'));
    }

    return errors;
  }

  /// Check for orphaned references
  Future<List<ValidationError>> _validateOrphanedReferences(StudioSchema schema) async {
    final errors = <ValidationError>[];

    // This would need access to all schemas to validate properly
    // For now, we'll just validate the reference format

    for (int i = 0; i < schema.fields.length; i++) {
      final field = schema.fields[i];

      if (field.type == FieldType.reference) {
        final targetSchema = field.options['targetSchema'] as String?;
        if (targetSchema != null && targetSchema.isEmpty) {
          errors.add(ValidationError('fields[$i].options.targetSchema',
            'Reference target schema cannot be empty for field: ${field.name}'));
        }
      }

      if (field.type == FieldType.crossDatasetReference) {
        final targetDataset = field.options['targetDataset'] as String?;
        final targetSchema = field.options['targetSchema'] as String?;

        if (targetDataset != null && targetDataset.isEmpty) {
          errors.add(ValidationError('fields[$i].options.targetDataset',
            'Cross-dataset reference target dataset cannot be empty for field: ${field.name}'));
        }

        if (targetSchema != null && targetSchema.isEmpty) {
          errors.add(ValidationError('fields[$i].options.targetSchema',
            'Cross-dataset reference target schema cannot be empty for field: ${field.name}'));
        }
      }
    }

    return errors;
  }

  /// Validate naming conventions and best practices
  Future<List<ValidationError>> _validateNamingConventions(StudioSchema schema) async {
    final errors = <ValidationError>[];

    // Schema name should be in PascalCase or camelCase
    if (!RegExp(r'^[a-z][a-zA-Z0-9]*$|^[A-Z][a-zA-Z0-9]*$').hasMatch(schema.name)) {
      errors.add(ValidationError('name',
        'Schema name should follow camelCase or PascalCase convention: ${schema.name}'));
    }

    // Field names should be in camelCase
    for (int i = 0; i < schema.fields.length; i++) {
      final field = schema.fields[i];
      if (!RegExp(r'^[a-z][a-zA-Z0-9]*$').hasMatch(field.name)) {
        errors.add(ValidationError('fields[$i].name',
          'Field name should follow camelCase convention: ${field.name}'));
      }
    }

    return errors;
  }

  /// Quick validation for basic schema compliance
  Future<bool> isSchemaValid(StudioSchema schema) async {
    final result = await validateSchema(schema);
    return result.isValid;
  }

  /// Get validation suggestions for improving schema
  Future<List<String>> getValidationSuggestions(StudioSchema schema) async {
    final suggestions = <String>[];

    // Performance suggestions
    if (schema.fields.length > 50) {
      suggestions.add('Consider breaking large schemas into smaller, related schemas for better performance');
    }

    // Usability suggestions
    final requiredFields = schema.fields.where((f) => f.required).length;
    final totalFields = schema.fields.length;

    if (requiredFields > totalFields * 0.8) {
      suggestions.add('Consider making some fields optional to improve user experience');
    }

    // Type suggestions
    final stringFields = schema.fields.where((f) => f.type == FieldType.string).length;
    if (stringFields > totalFields * 0.6) {
      suggestions.add('Consider using more specific field types (email, url, date) instead of generic string fields');
    }

    return suggestions;
  }
}