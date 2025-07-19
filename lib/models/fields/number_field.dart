import 'package:flutter_cms/models/fields.dart';

class CmsNumberOption extends CmsOption {
  final String validation;

  const CmsNumberOption({required this.validation, super.hidden});
}

class CmsNumberField extends CmsField {
  const CmsNumberField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsNumberFieldConfig extends CmsFieldConfig {
  const CmsNumberFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [num];
}