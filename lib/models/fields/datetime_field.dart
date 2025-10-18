import 'package:flutter_cms/models/fields.dart';

class CmsDateTimeOption extends CmsOption {
  const CmsDateTimeOption();
}

class CmsDateTimeField extends CmsField {
  const CmsDateTimeField({
    required super.name,
    required super.title,
    required CmsDateTimeOption super.option,
  });

  @override
  CmsDateTimeOption get option => super.option as CmsDateTimeOption;
}

class CmsDateTimeFieldConfig extends CmsFieldConfig {
  const CmsDateTimeFieldConfig({
    super.name,
    super.title,
    CmsDateTimeOption super.option = const CmsDateTimeOption(),
  });

  @override
  List<Type> get supportedFieldTypes => [DateTime];
}
