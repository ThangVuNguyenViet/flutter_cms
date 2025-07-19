import 'package:flutter_cms/models/fields.dart';

class CmsDateTimeOption extends CmsOption {
  const CmsDateTimeOption();
}

class CmsDateTimeField extends CmsField {
  const CmsDateTimeField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsDateTimeFieldConfig extends CmsFieldConfig {
  const CmsDateTimeFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [DateTime];
}