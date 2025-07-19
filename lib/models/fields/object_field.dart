import 'package:flutter_cms/models/fields.dart';

class CmsObjectFieldDefinition {
  final String name;
  final String title;
  final String type;

  const CmsObjectFieldDefinition({
    required this.name,
    required this.title,
    required this.type,
  });
}

class CmsObjectOption extends CmsOption {
  final List<CmsObjectFieldDefinition> fields;

  const CmsObjectOption({required this.fields, super.hidden});
}

class CmsObjectField extends CmsField {
  const CmsObjectField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsObjectFieldConfig extends CmsFieldConfig {
  const CmsObjectFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [Object]; // Represents a generic object
}
