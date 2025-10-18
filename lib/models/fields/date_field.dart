import 'package:flutter_cms/models/fields.dart';

class CmsDateOption extends CmsOption {
  const CmsDateOption();
}

class CmsDateField extends CmsField {
  const CmsDateField({
    required super.name,
    required super.title,
    required CmsDateOption super.option,
  });

  @override
  CmsDateOption get option => super.option as CmsDateOption;
}

class CmsDateFieldConfig extends CmsFieldConfig {
  const CmsDateFieldConfig({
    super.name,
    super.title,
    CmsDateOption super.option = const CmsDateOption(),
  });

  @override
  List<Type> get supportedFieldTypes => [DateTime];
}
