import 'package:flutter_cms/models/fields.dart';

class CmsDateOption extends CmsOption {
  const CmsDateOption();
}

class CmsDateField extends CmsField {
  const CmsDateField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsDateFieldConfig extends CmsFieldConfig {
  const CmsDateFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [DateTime];
}