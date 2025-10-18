import 'package:flutter_cms/models/fields.dart';

class CmsUrlOption extends CmsOption {
  const CmsUrlOption();
}

class CmsUrlField extends CmsField {
  const CmsUrlField({
    required super.name,
    required super.title,
    required CmsUrlOption super.option,
  });

  @override
  CmsUrlOption get option => super.option as CmsUrlOption;
}

class CmsUrlFieldConfig extends CmsFieldConfig {
  const CmsUrlFieldConfig({
    super.name,
    super.title,
    CmsUrlOption super.option = const CmsUrlOption(),
  });

  @override
  List<Type> get supportedFieldTypes => [Uri];
}
