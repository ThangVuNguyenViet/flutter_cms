import 'package:flutter_cms/models/fields.dart';

class CmsNumberOption extends CmsOption {
  final String validation;

  const CmsNumberOption({required this.validation, super.hidden});
}

class CmsNumberField extends CmsField {
  const CmsNumberField({
    required super.name,
    required super.title,
    required CmsNumberOption super.option,
  });

  @override
  CmsNumberOption get option => super.option as CmsNumberOption;
}

class CmsNumberFieldConfig extends CmsFieldConfig {
  const CmsNumberFieldConfig({
    super.name,
    super.title,
    CmsNumberOption super.option = const CmsNumberOption(validation: ''),
  });

  @override
  List<Type> get supportedFieldTypes => [num];
}
