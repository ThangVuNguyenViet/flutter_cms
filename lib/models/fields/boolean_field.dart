import 'package:flutter_cms/models/fields.dart';

class CmsBooleanOption extends CmsOption {
  const CmsBooleanOption();
}

class CmsBooleanField extends CmsField {
  const CmsBooleanField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsBooleanFieldConfig extends CmsFieldConfig {
  const CmsBooleanFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [bool];
}