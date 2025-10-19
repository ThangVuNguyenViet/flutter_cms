/// Represents a field definition within a schema
/// Fields define the structure and constraints for content data
class StudioField {
  const StudioField({
    required this.name,
    required this.title,
    required this.type,
    this.options = const {},
    this.validation = const [],
    this.metadata = const FieldMetadata(),
    this.required = false,
    this.defaultValue,
  });

  /// Field name (must be valid Dart identifier)
  final String name;

  /// Human-readable field title
  final String title;

  /// Field type (determines input component and validation)
  final FieldType type;

  /// Type-specific options
  final Map<String, dynamic> options;

  /// Validation rules for this field
  final List<ValidationRule> validation;

  /// Field metadata (order, description, help text)
  final FieldMetadata metadata;

  /// Whether this field is required
  final bool required;

  /// Default value for this field
  final dynamic defaultValue;

  /// Create a copy of this field with updated properties
  StudioField copyWith({
    String? name,
    String? title,
    FieldType? type,
    Map<String, dynamic>? options,
    List<ValidationRule>? validation,
    FieldMetadata? metadata,
    bool? required,
    dynamic defaultValue,
  }) {
    return StudioField(
      name: name ?? this.name,
      title: title ?? this.title,
      type: type ?? this.type,
      options: options ?? Map<String, dynamic>.from(this.options),
      validation: validation ?? List<ValidationRule>.from(this.validation),
      metadata: metadata ?? this.metadata,
      required: required ?? this.required,
      defaultValue: defaultValue ?? this.defaultValue,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'type': type.name,
      'options': options,
      'validation': validation.map((v) => v.toJson()).toList(),
      'metadata': metadata.toJson(),
      'required': required,
      'defaultValue': defaultValue,
    };
  }

  /// Create from JSON
  factory StudioField.fromJson(Map<String, dynamic> json) {
    return StudioField(
      name: json['name'] as String,
      title: json['title'] as String,
      type: FieldType.values.byName(json['type'] as String),
      options: Map<String, dynamic>.from(json['options'] as Map<String, dynamic>? ?? {}),
      validation: (json['validation'] as List<dynamic>? ?? [])
          .map((v) => ValidationRule.fromJson(v as Map<String, dynamic>))
          .toList(),
      metadata: json['metadata'] != null
          ? FieldMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : const FieldMetadata(),
      required: json['required'] as bool? ?? false,
      defaultValue: json['defaultValue'],
    );
  }

  /// Validate this field definition
  List<String> validate() {
    final errors = <String>[];

    // Name validation (Dart identifier rules)
    if (name.isEmpty || !RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(name)) {
      errors.add('Field name must be a valid Dart identifier: $name');
    }

    // Title validation
    if (title.isEmpty) {
      errors.add('Field title cannot be empty: $name');
    }

    // Type-specific validation
    errors.addAll(_validateTypeSpecificOptions());

    // Validation rules validation
    for (final rule in validation) {
      errors.addAll(rule.validate());
    }

    return errors;
  }

  /// Validate type-specific options
  List<String> _validateTypeSpecificOptions() {
    final errors = <String>[];

    switch (type) {
      case FieldType.text:
        final rows = options['rows'];
        if (rows != null && rows is! int) {
          errors.add('Text field rows option must be an integer');
        }
        break;

      case FieldType.string:
        final maxLength = options['maxLength'];
        if (maxLength != null && maxLength is! int) {
          errors.add('String field maxLength option must be an integer');
        }
        break;

      case FieldType.number:
        final min = options['min'];
        final max = options['max'];
        if (min != null && min is! num) {
          errors.add('Number field min option must be a number');
        }
        if (max != null && max is! num) {
          errors.add('Number field max option must be a number');
        }
        if (min != null && max != null && (min as num) > (max as num)) {
          errors.add('Number field min cannot be greater than max');
        }
        break;

      case FieldType.array:
        final itemType = options['itemType'];
        if (itemType == null) {
          errors.add('Array field must specify itemType option');
        }
        break;

      case FieldType.object:
        final fields = options['fields'];
        if (fields == null) {
          errors.add('Object field must specify fields option');
        }
        break;

      case FieldType.reference:
        final to = options['to'];
        if (to == null || to is! String) {
          errors.add('Reference field must specify target schema in \'to\' option');
        }
        break;

      default:
        // No specific validation for other field types
        break;
    }

    return errors;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudioField && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'StudioField(name: $name, title: $title, type: $type)';
}

/// Supported field types in CMS Studio
enum FieldType {
  text('Text'),
  string('String'),
  number('Number'),
  boolean('Boolean'),
  date('Date'),
  datetime('DateTime'),
  image('Image'),
  file('File'),
  url('URL'),
  slug('Slug'),
  array('Array'),
  object('Object'),
  reference('Reference'),
  crossDatasetReference('Cross Dataset Reference'),
  geopoint('Geopoint'),
  block('Block');

  const FieldType(this.label);
  final String label;
}

/// Validation rule for field values
class ValidationRule {
  const ValidationRule({
    required this.type,
    this.value,
    this.message,
  });

  final ValidationType type;
  final dynamic value;
  final String? message;

  ValidationRule copyWith({
    ValidationType? type,
    dynamic value,
    String? message,
  }) {
    return ValidationRule(
      type: type ?? this.type,
      value: value ?? this.value,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'value': value,
      'message': message,
    };
  }

  factory ValidationRule.fromJson(Map<String, dynamic> json) {
    return ValidationRule(
      type: ValidationType.values.byName(json['type'] as String),
      value: json['value'],
      message: json['message'] as String?,
    );
  }

  /// Validate this validation rule
  List<String> validate() {
    final errors = <String>[];

    switch (type) {
      case ValidationType.required:
        // No additional validation needed
        break;
      case ValidationType.minLength:
      case ValidationType.maxLength:
        if (value == null || value is! int || (value as int) < 0) {
          errors.add('${type.name} validation must have a positive integer value');
        }
        break;
      case ValidationType.min:
      case ValidationType.max:
        if (value == null || value is! num) {
          errors.add('${type.name} validation must have a numeric value');
        }
        break;
      case ValidationType.pattern:
        if (value == null || value is! String) {
          errors.add('pattern validation must have a string value');
        } else {
          try {
            RegExp(value as String);
          } catch (e) {
            errors.add('pattern validation must be a valid regular expression');
          }
        }
        break;
      case ValidationType.email:
      case ValidationType.url:
        // No additional validation needed for these types
        break;
      case ValidationType.custom:
        if (value == null || value is! String) {
          errors.add('custom validation must have a string value');
        }
        break;
    }

    return errors;
  }

  @override
  String toString() => 'ValidationRule(type: $type, value: $value)';
}

/// Types of validation rules
enum ValidationType {
  required('Required'),
  minLength('Minimum Length'),
  maxLength('Maximum Length'),
  pattern('Pattern'),
  min('Minimum Value'),
  max('Maximum Value'),
  email('Email Format'),
  url('URL Format'),
  custom('Custom');

  const ValidationType(this.label);
  final String label;
}

/// Metadata for field configuration
class FieldMetadata {
  const FieldMetadata({
    this.order = 0,
    this.description,
    this.helpText,
    this.group,
  });

  final int order;
  final String? description;
  final String? helpText;
  final String? group;

  FieldMetadata copyWith({
    int? order,
    String? description,
    String? helpText,
    String? group,
  }) {
    return FieldMetadata(
      order: order ?? this.order,
      description: description ?? this.description,
      helpText: helpText ?? this.helpText,
      group: group ?? this.group,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'description': description,
      'helpText': helpText,
      'group': group,
    };
  }

  factory FieldMetadata.fromJson(Map<String, dynamic> json) {
    return FieldMetadata(
      order: json['order'] as int? ?? 0,
      description: json['description'] as String?,
      helpText: json['helpText'] as String?,
      group: json['group'] as String?,
    );
  }
}