import 'package:flutter_cms/models/fields.dart';

class CmsBooleanOption extends CmsOption {
  const CmsBooleanOption();
}

class CmsBooleanField extends CmsField {
  const CmsBooleanField({
    required super.name,
    required super.title,
    required CmsBooleanOption super.option,
  });

  @override
  CmsBooleanOption get option => super.option as CmsBooleanOption;
}

class CmsBooleanFieldConfig extends CmsFieldConfig {
  const CmsBooleanFieldConfig({
    super.name,
    super.title,
    CmsBooleanOption super.option = const CmsBooleanOption(),
  });

  @override
  List<Type> get supportedFieldTypes => [bool];
}
