import 'package:flutter_cms/models/fields.dart';

class CmsUrlOption extends CmsOption {
  const CmsUrlOption();
}

class CmsUrlField extends CmsField {
  const CmsUrlField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsUrlFieldConfig extends CmsFieldConfig {
  const CmsUrlFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [Uri];
}