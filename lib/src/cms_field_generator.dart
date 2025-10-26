import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flutter_cms/models/cms_annotations.dart';
import 'package:source_gen/source_gen.dart';

/// Generates CmsField lists from classes annotated with @CmsConfig.
/// This generator processes the @CmsFieldConfig annotations on fields to create
/// corresponding CmsField instances for runtime use.
class CmsFieldGenerator extends GeneratorForAnnotation<CmsConfig> {
  static final _fieldConfigs = {
    'CmsTextFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final rows = option?.getField('rows')?.toIntValue() ?? 1;
      return '''CmsTextField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsTextOption(rows: $rows),
  )''';
    },
    'CmsStringFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsStringField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsStringOption(),
  )''';
    },
    'CmsNumberFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final min = option?.getField('min')?.toDoubleValue();
      final max = option?.getField('max')?.toDoubleValue();
      final minStr = min != null ? 'min: $min' : '';
      final maxStr = max != null ? 'max: $max' : '';
      final params = [minStr, maxStr].where((p) => p.isNotEmpty).join(', ');
      final optionParams = params.isNotEmpty ? '($params)' : '()';
      return '''CmsNumberField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsNumberOption$optionParams,
  )''';
    },
    'CmsBooleanFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsBooleanField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsBooleanOption(),
  )''';
    },
    'CmsCheckboxFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final label = option?.getField('label')?.toStringValue();
      final initialValue = option?.getField('initialValue')?.toBoolValue() ?? false;
      final labelParam = label != null ? "label: '$label', " : '';
      return '''CmsCheckboxField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsCheckboxOption(${labelParam}initialValue: $initialValue),
  )''';
    },
    'CmsDateFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsDateField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsDateOption(),
  )''';
    },
    'CmsDateTimeFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsDateTimeField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsDateTimeOption(),
  )''';
    },
    'CmsUrlFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsUrlField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsUrlOption(),
  )''';
    },
    'CmsSlugFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final source = option?.getField('source')?.toStringValue() ?? '';
      final maxLength = option?.getField('maxLength')?.toIntValue() ?? 96;
      return '''CmsSlugField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsSlugOption(source: '$source', maxLength: $maxLength),
  )''';
    },
    'CmsImageFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final hotspot = option?.getField('hotspot')?.toBoolValue() ?? false;
      return '''CmsImageField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsImageOption(hotspot: $hotspot),
  )''';
    },
    'CmsFileFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsFileField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsFileOption(),
  )''';
    },
    'CmsArrayFieldConfig': (FieldElement field, DartObject? config) {
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
    'CmsBlockFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsBlockField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsBlockOption(),
  )''';
    },
    'CmsReferenceFieldConfig': (FieldElement field, DartObject? config) {
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
      DartObject? config,
    ) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final dataset = option?.getField('dataset')?.toStringValue() ?? '';
      return '''CmsCrossDatasetReferenceField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsCrossDatasetReferenceOption(dataset: '$dataset', to: []),
  )''';
    },
    'CmsGeopointFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsGeopointField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsGeopointOption(),
  )''';
    },
    'CmsColorFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final showAlpha = option?.getField('showAlpha')?.toBoolValue() ?? false;
      return '''CmsColorField(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: const CmsColorOption(showAlpha: $showAlpha),
  )''';
    },
    'CmsDropdownFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;

      // Extract the generic type from CmsDropdownFieldConfig<T>
      final configType = config?.type?.toString() ?? '';
      final genericTypeMatch = RegExp(
        r'CmsDropdownFieldConfig<(.+?)>',
      ).firstMatch(configType);
      final genericType = genericTypeMatch?.group(1) ?? 'String';

      final option = config?.getField('option');
      final optionsList = option?.getField('options')?.toListValue() ?? [];
      final defaultValue = option?.getField('defaultValue');
      final placeholder = option?.getField('placeholder')?.toStringValue();

      // Generate the options list
      final optionsCode = optionsList.map((opt) {
        final value = opt.getField('value');
        final label = opt.getField('label')?.toStringValue() ?? '';
        String valueCode;

        if (genericType == 'String') {
          valueCode = "'${value?.toStringValue() ?? ''}'";
        } else if (genericType == 'int') {
          valueCode = "${value?.toIntValue() ?? 0}";
        } else if (genericType == 'double') {
          valueCode = "${value?.toDoubleValue() ?? 0.0}";
        } else if (genericType == 'bool') {
          valueCode = "${value?.toBoolValue() ?? false}";
        } else {
          // For enums or other types, use the string representation
          valueCode = value?.toString() ?? 'null';
        }

        return "DropdownOption<$genericType>(value: $valueCode, label: '$label')";
      }).join(', ');

      String defaultValueCode = 'null';
      if (defaultValue != null) {
        if (genericType == 'String') {
          defaultValueCode = "'${defaultValue.toStringValue() ?? ''}'";
        } else if (genericType == 'int') {
          defaultValueCode = "${defaultValue.toIntValue() ?? 0}";
        } else if (genericType == 'double') {
          defaultValueCode = "${defaultValue.toDoubleValue() ?? 0.0}";
        } else if (genericType == 'bool') {
          defaultValueCode = "${defaultValue.toBoolValue() ?? false}";
        } else {
          defaultValueCode = defaultValue.toString();
        }
      }

      final placeholderParam = placeholder != null ? "placeholder: '$placeholder', " : '';
      final defaultValueParam = defaultValue != null ? "defaultValue: $defaultValueCode, " : '';

      return '''CmsDropdownField<$genericType>(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsDropdownOption<$genericType>(
      options: [$optionsCode],
      $defaultValueParam${placeholderParam}allowNull: true,
    ),
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

        configCode = _fieldConfigs[displayName]?.call(
          field,
          annotation.computeConstantValue(),
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
