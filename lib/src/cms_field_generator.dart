import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flutter_cms/models/cms_annotations.dart';
import 'package:source_gen/source_gen.dart';

/// Generates field configuration lists from classes annotated with @CmsConfig.
/// This generator processes the annotations on fields to create corresponding field config lists.
class CmsFieldGenerator extends GeneratorForAnnotation<CmsConfig> {
  static final _fieldConfigs = {
    'CmsTextFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final rows = option?.getField('rows')?.toIntValue() ?? 1;
      final description = option?.getField('description')?.toStringValue();
      return '''CmsTextFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsTextOption(rows: $rows${description != null ? ", description: '$description'" : ''}),
  )''';
    },
    'CmsStringFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsStringFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
  )''';
    },
    'CmsNumberFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsNumberFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
  )''';
    },
    'CmsBooleanFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsBooleanFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
  )''';
    },
    'CmsDateFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsDateFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
  )''';
    },
    'CmsDateTimeFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsDateTimeFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
  )''';
    },
    'CmsUrlFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsUrlFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
  )''';
    },
    'CmsSlugFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final source = option?.getField('source')?.toStringValue() ?? '';
      final maxLength = option?.getField('maxLength')?.toIntValue() ?? 96;
      return '''CmsSlugFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsSlugOption(source: '$source', maxLength: $maxLength),
  )''';
    },
    'CmsImageFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final hotspot = option?.getField('hotspot')?.toBoolValue() ?? false;
      return '''CmsImageFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsImageOption(hotspot: $hotspot),
  )''';
    },
    'CmsFileFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsFileFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
  )''';
    },
    'CmsArrayFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsArrayFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
  )''';
    },
    'CmsBlockFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsBlockFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
  )''';
    },
    'CmsReferenceFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      final option = config?.getField('option');
      final to = option?.getField('to');
      final toType = to?.getField('type')?.toStringValue() ?? '';
      return '''CmsReferenceFieldConfig(
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
      return '''CmsCrossDatasetReferenceFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
    option: CmsCrossDatasetReferenceOption(dataset: '$dataset', to: []),
  )''';
    },
    'CmsGeopointFieldConfig': (FieldElement field, DartObject? config) {
      final fieldName = field.name!;
      return '''CmsGeopointFieldConfig(
    name: '$fieldName',
    title: '${_titleCase(fieldName)}',
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

    final fields = element.fields.where((f) => !f.isStatic);
    final fieldConfigs = <String>[];

    for (final field in fields) {
      String? configCode;

      // Check for field-specific annotations
      for (final entry in _fieldConfigs.entries) {
        for (final annotation in field.metadata.annotations) {
          final annotationType = annotation.computeConstantValue()?.type;
          if (annotationType != null &&
              annotationType.toString() == entry.key) {
            configCode = entry.value(field, annotation.computeConstantValue());
            break;
          }
        }
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
          configCode = '''CmsObjectFieldConfig(
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

    return '''
/// Generated field configurations for $className
final $fieldsListName = [
  ${fieldConfigs.join(',\n  ')},
];

/// Generated document type for $className
final $documentTypeName = CmsDocumentType(
  $idField
  title: '$title',
  description: '$description',
  fields: $fieldsListName,
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
