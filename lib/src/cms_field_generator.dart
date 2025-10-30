import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flutter_cms/models/cms_annotations.dart';
import 'package:flutter_cms/src/utils.dart';
import 'package:source_gen/source_gen.dart';

/// Extension to provide safe field access similar to widgetbook's readOrNull pattern
extension DartObjectExtension on DartObject {
  /// Safely gets a field value, returning null if the field doesn't exist
  DartObject? getFieldOrNull(String fieldName) {
    try {
      return getField(fieldName);
    } catch (e) {
      return null;
    }
  }
}

/// Generates CmsField lists from classes annotated with @CmsConfig.
/// This generator processes the @CmsFieldConfig annotations on fields to create
/// corresponding CmsField instances for runtime use.
class CmsFieldGenerator extends GeneratorForAnnotation<CmsConfig> {
  /// Parse option from annotation following widgetbook's safe extraction pattern
  static String _parseOptionFromAnnotation(
    DartObject? config,
    String optionClassName,
    String Function(DartObject option)? customParser, [
    String? optionSource,
  ]) {
    // If direct option source is provided, use it directly (highest priority)
    if (optionSource != null && optionSource.isNotEmpty) {
      return optionSource;
    }

    final option = config?.getFieldOrNull('option');
    if (option == null || option.isNull) {
      return 'const $optionClassName()';
    }

    // Use ConstantReader to revive the option
    try {
      final reader = ConstantReader(option);
      final revived = reader.revive();

      // For enums, use accessor
      if (revived.accessor.isNotEmpty) {
        return revived.accessor;
      }

      // For constructor calls, build from revived data
      if (revived.namedArguments.isNotEmpty ||
          revived.positionalArguments.isNotEmpty) {
        final className = revived.source.toString().split('#').last;
        final args = <String>[];

        // Add positional arguments
        for (final arg in revived.positionalArguments) {
          final argValue = _dartObjectToString(arg) ?? 'null';
          args.add(argValue);
        }

        // Add named arguments
        for (final entry in revived.namedArguments.entries) {
          final value = _dartObjectToString(entry.value) ?? 'null';
          args.add('${entry.key}: $value');
        }

        if (args.isEmpty) {
          return 'const $className()';
        } else {
          return '$className(${args.join(', ')})';
        }
      }
    } catch (e) {
      // Fall back to current implementation if revive fails
    }

    // Use custom parser if provided (for complex options like dropdown)
    if (customParser != null) {
      try {
        return customParser(option);
      } catch (e) {
        // Fall back to default if custom parsing fails
        return 'const $optionClassName()';
      }
    }

    // Use generic option code generation for standard options
    return _generateOptionCode(optionClassName, option);
  }

  /// Extract option value from annotation source
  static String? _extractOptionFromSource(String annotationSource) {
    // Look for option: pattern and extract the value with proper parentheses handling
    final optionStart = annotationSource.indexOf('option:');
    if (optionStart == -1) {
      return null;
    }

    final valueStart = optionStart + 7; // 'option:'.length
    final remaining = annotationSource.substring(valueStart).trim();

    // Handle balanced parentheses and commas
    var depth = 0;
    var endIndex = remaining.length;
    var inString = false;
    var stringChar = '';

    for (var i = 0; i < remaining.length; i++) {
      final char = remaining[i];

      // Handle string literals
      if ((char == '"' || char == "'") && !inString) {
        inString = true;
        stringChar = char;
        continue;
      }
      if (char == stringChar && inString) {
        inString = false;
        stringChar = '';
        continue;
      }

      if (!inString) {
        if (char == '(' || char == '[' || char == '{') {
          depth++;
        } else if (char == ')' || char == ']' || char == '}') {
          depth--;
          if (depth < 0) {
            endIndex = i;
            break;
          }
        } else if (char == ',' && depth == 0) {
          endIndex = i;
          break;
        }
      }
    }

    final value = remaining.substring(0, endIndex).trim();

    if (value.isNotEmpty && value != 'null') {
      return value;
    }

    return null;
  }

  /// Helper method to generate option code from DartObject
  static String _generateOptionCode(
    String optionClassName,
    DartObject? option,
  ) {
    if (option == null) {
      return 'const $optionClassName()';
    }

    final params = <String>[];

    // Extract all fields from the option object
    final optionType = option.type;
    if (optionType != null) {
      for (final field in optionType.element?.children ?? <Object>[]) {
        if (field is FieldElement && !field.isStatic) {
          final fieldValue = option.getField(field.displayName);
          if (fieldValue != null && !fieldValue.isNull) {
            final paramValue = _dartObjectToString(fieldValue);
            if (paramValue != null) {
              params.add('${field.name}: $paramValue');
            }
          }
        }
      }
    }

    if (params.isEmpty) {
      return 'const $optionClassName()';
    } else {
      return '$optionClassName(${params.join(', ')})';
    }
  }

  /// Parse dropdown option following widgetbook's complex option parsing pattern
  static String _parseDropdownOption(DartObject option, String genericType) {
    try {
      // Extract properties from the CmsDropdownOption annotation
      final optionsField = option.getFieldOrNull('options');
      final defaultValueField = option.getFieldOrNull('defaultValue');
      final placeholderField = option.getFieldOrNull('placeholder');
      final allowNullField = option.getFieldOrNull('allowNull');

      // Build options list from annotation if available
      String optionsList = '[]';
      if (optionsField != null && !optionsField.isNull) {
        final optionElements = optionsField.toListValue();
        if (optionElements != null && optionElements.isNotEmpty) {
          final optionsCode = optionElements
              .map((element) {
                final valueField = element.getFieldOrNull('value');
                final labelField = element.getFieldOrNull('label');
                final value = valueField?.toStringValue() ?? '';
                final label = labelField?.toStringValue() ?? '';
                return "DropdownOption<$genericType>(value: '$value', label: '$label')";
              })
              .join(',\n        ');
          optionsList = '[\n        $optionsCode,\n      ]';
        }
      }

      // Extract other properties
      final defaultValue = defaultValueField?.toStringValue();
      final placeholder = placeholderField?.toStringValue() ?? '';
      final allowNull = allowNullField?.toBoolValue() ?? true;

      // Build the CmsDropdownOption code
      final parts = <String>['options: $optionsList'];
      if (defaultValue != null && defaultValue.isNotEmpty) {
        parts.add("defaultValue: '$defaultValue'");
      }
      if (placeholder.isNotEmpty) {
        parts.add("placeholder: '$placeholder'");
      }
      parts.add('allowNull: $allowNull');

      return 'CmsDropdownOption<$genericType>(\n      ${parts.join(',\n      ')},\n    )';
    } catch (e) {
      // If annotation extraction fails, fall back to empty options
      return 'const CmsDropdownOption<$genericType>(options: [])';
    }
  }

  /// Helper method to convert DartObject to string representation
  static String? _dartObjectToString(DartObject obj) {
    if (obj.isNull) return null;

    // Handle primitive types
    final stringValue = obj.toStringValue();
    if (stringValue != null) return "'$stringValue'";

    final intValue = obj.toIntValue();
    if (intValue != null) return intValue.toString();

    final doubleValue = obj.toDoubleValue();
    if (doubleValue != null) return doubleValue.toString();

    final boolValue = obj.toBoolValue();
    if (boolValue != null) return boolValue.toString();

    // Handle lists (for dropdown options)
    final listValue = obj.toListValue();
    if (listValue != null) {
      final items = listValue
          .map((item) {
            final value = item.getField('value');
            final label = item.getField('label')?.toStringValue() ?? '';
            final valueStr =
                value != null ? _dartObjectToString(value) : 'null';
            return 'DropdownOption(value: $valueStr, label: \'$label\')';
          })
          .join(', ');
      return '[$items]';
    }

    return null;
  }

  static final _fieldConfigs = {
    'CmsTextFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      final optionCode = _parseOptionFromAnnotation(
        config,
        'CmsTextOption',
        null,
        optionSource,
      );
      return '''CmsTextField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: $optionCode,
  )''';
    },
    'CmsStringFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      return '''CmsStringField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsStringOption(),
  )''';
    },
    'CmsNumberFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      final optionCode = _parseOptionFromAnnotation(
        config,
        'CmsNumberOption',
        null,
        optionSource,
      );
      return '''CmsNumberField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: $optionCode,
  )''';
    },
    'CmsBooleanFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      return '''CmsBooleanField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsBooleanOption(),
  )''';
    },
    'CmsCheckboxFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      final optionCode = _parseOptionFromAnnotation(
        config,
        'CmsCheckboxOption',
        null,
        optionSource,
      );
      return '''CmsCheckboxField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: $optionCode,
  )''';
    },
    'CmsDateFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      return '''CmsDateField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsDateOption(),
  )''';
    },
    'CmsDateTimeFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      return '''CmsDateTimeField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsDateTimeOption(),
  )''';
    },
    'CmsUrlFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      return '''CmsUrlField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsUrlOption(),
  )''';
    },
    'CmsSlugFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      final optionCode = _parseOptionFromAnnotation(
        config,
        'CmsSlugOption',
        null,
        optionSource,
      );
      return '''CmsSlugField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: $optionCode,
  )''';
    },
    'CmsImageFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      final optionCode = _parseOptionFromAnnotation(
        config,
        'CmsImageOption',
        null,
        optionSource,
      );
      return '''CmsImageField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: $optionCode,
  )''';
    },
    'CmsFileFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      return '''CmsFileField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsFileOption(),
  )''';
    },
    'CmsArrayFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;

      // Extract the generic type from CmsArrayFieldConfig<T>
      final configType = config?.type?.toString() ?? '';
      final genericTypeMatch = RegExp(
        r'CmsArrayFieldConfig<(.+?)>',
      ).firstMatch(configType);
      final genericType = genericTypeMatch?.group(1) ?? 'dynamic';

      // Find the class name from the field's enclosing element
      final className = field.enclosingElement.name ?? '';
      final itemBuilderName = '$className.${fieldName}ItemBuilder';

      return '''CmsArrayField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsArrayOption(),
    itemBuilder: (context, value) =>
        $itemBuilderName(context, value as $genericType),
  )''';
    },
    'CmsBlockFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      return '''CmsBlockField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsBlockOption(),
  )''';
    },
    'CmsReferenceFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final to = option?.getField('to');
      final toType = to?.getField('type')?.toStringValue() ?? '';
      return '''CmsReferenceField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsReferenceOption(to: CmsReferenceTo(type: '$toType')),
  )''';
    },
    'CmsCrossDatasetReferenceFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final dataset = option?.getField('dataset')?.toStringValue() ?? '';
      return '''CmsCrossDatasetReferenceField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsCrossDatasetReferenceOption(dataset: '$dataset', to: []),
  )''';
    },
    'CmsGeopointFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      return '''CmsGeopointField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsGeopointOption(),
  )''';
    },
    'CmsColorFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final showAlpha = option?.getField('showAlpha')?.toBoolValue() ?? false;
      return '''CmsColorField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsColorOption(showAlpha: $showAlpha),
  )''';
    },
    'CmsDropdownFieldConfig': (
      FieldElement field,
      DartObject? config, [
      String? optionSource,
    ]) {
      final fieldName = field.name!;

      // Extract the generic type from CmsDropdownFieldConfig<T>
      final configType = config?.type?.toString() ?? '';
      final genericTypeMatch = RegExp(
        r'CmsDropdownFieldConfig<(.+?)>',
      ).firstMatch(configType);
      final genericType = genericTypeMatch?.group(1) ?? 'String';

      // Use the new widgetbook-inspired pattern for option extraction
      final optionCode = _parseOptionFromAnnotation(
        config,
        'CmsDropdownOption<$genericType>',
        (option) => _parseDropdownOption(option, genericType),
        optionSource,
      );

      return '''CmsDropdownField<$genericType>(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: $optionCode,
  )''';
    },
  };

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@CmsConfig` can only be used on classes.',
        element: element,
      );
    }

    final className = element.name;
    if (className == null) {
      throw InvalidGenerationSourceError(
        'Class name is null.',
        element: element,
      );
    }

    // Extract CmsConfig annotation parameters
    final title = annotation.read('title').stringValue;
    final description = annotation.read('description').stringValue;
    final id = annotation.peek('id')?.stringValue;

    final fieldsListName =
        '${className.substring(0, 1).toLowerCase()}${className.substring(1)}Fields';
    final documentTypeName =
        '${className.substring(0, 1).toLowerCase()}${className.substring(1)}DocumentType';

    final fields = element.fields.where(
      (f) => !f.isStatic && f.name != 'defaultValue',
    );
    final fieldConfigs = <String>[];

    for (final field in fields) {
      String? configCode;

      // Check for field-specific annotations
      for (final annotation in field.metadata.annotations) {
        final annotationType = annotation.computeConstantValue()?.type;
        final displayName = annotationType?.element?.displayName;

        // Get the option property from the annotation source using improved extraction
        String? optionSource;
        final fullAnnotation = annotation.toSource();
        optionSource = _extractOptionFromSource(fullAnnotation);

        configCode = _fieldConfigs[displayName]?.call(
          field,
          annotation.computeConstantValue(),
          optionSource,
        );
        if (configCode != null) break;
      }

      // If no specific annotation but field type has @CmsConfig, treat as object field
      if (configCode == null && field.type.element is ClassElement) {
        final fieldClass = field.type.element as ClassElement;
        final fieldClassName = fieldClass.name;
        final typeChecker = TypeChecker.fromUrl(
          'package:flutter_cms/models/cms_annotations.dart#CmsConfig',
        );
        if (fieldClassName != null && typeChecker.hasAnnotationOf(fieldClass)) {
          final nestedFieldsName =
              '${fieldClassName.substring(0, 1).toLowerCase()}${fieldClassName.substring(1)}Fields';
          final fieldName = field.name!;
          configCode = '''CmsObjectField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsObjectOption(fields: $nestedFieldsName),
  )''';
        }
      }

      if (configCode != null) {
        fieldConfigs.add(configCode);
      }
    }

    if (fieldConfigs.isEmpty) return '';

    final idField =
        id != null
            ? "name: '$id',"
            : "name: '${className.substring(0, 1).toLowerCase()}${className.substring(1)}',";

    final builderName =
        '\$${className.substring(0, 1).toLowerCase()}${className.substring(1)}Builder';

    return '''
/// Generated CmsField list for $className
final $fieldsListName = [
  ${fieldConfigs.join(',\n  ')},
];

/// Generated document type for $className
final $documentTypeName = CmsDocumentType<$className>(
  $idField
  title: '$title',
  description: '$description',
  fields: $fieldsListName,
  builder: $builderName,
  createDefault: () => $className.defaultValue(),
);\n''';
  }

  /// Converts snake_case or camelCase to Title Case
  static String _titleCase(String input) {
    if (input.isEmpty) return input;

    // Split by underscores and spaces
    final words = input.split(RegExp(r'[_\s]'));

    // Convert camelCase to separate words
    final finalWords = <String>[];
    for (final word in words) {
      if (word.isEmpty) continue;
      final camelCaseWords = word
          .replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
          .trim()
          .split(' ');
      finalWords.addAll(camelCaseWords);
    }

    // Capitalize each word
    return finalWords
        .map(
          (word) =>
              word.isEmpty
                  ? ''
                  : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  /// Gets a Type from a string name
  String getAnnotationName(String configType) {
    return configType;
  }
}
