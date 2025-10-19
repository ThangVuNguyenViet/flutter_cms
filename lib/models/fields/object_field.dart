import 'package:flutter_cms/models/fields.dart';
import 'package:flutter_cms/models/fields/string_field.dart';

class CmsObjectOption extends CmsOption {
  final List<CmsStringFieldConfig> fields;

  const CmsObjectOption({required this.fields, super.hidden});
}

class CmsObjectField extends CmsField {
  const CmsObjectField({
    required super.name,
    required super.title,
    required CmsObjectOption super.option,
  });

  @override
  CmsObjectOption get option => super.option as CmsObjectOption;
}

class CmsObjectFieldConfig extends CmsFieldConfig {
  const CmsObjectFieldConfig({
    super.name,
    super.title,
    CmsObjectOption super.option = const CmsObjectOption(
      fields: [],
    ), // Default empty list
  });

  @override
  List<Type> get supportedFieldTypes => [Object]; // Represents a generic object
}
