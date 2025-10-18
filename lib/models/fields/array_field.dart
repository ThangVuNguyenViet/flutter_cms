import 'package:flutter_cms/models/fields.dart';

class CmsArrayOf {
  final String type;

  const CmsArrayOf({required this.type});
}

class CmsArrayOption extends CmsOption {
  final List<CmsArrayOf> of;

  const CmsArrayOption({required this.of, super.hidden});
}

class CmsArrayField extends CmsField {
  const CmsArrayField({
    required super.name,
    required super.title,
    CmsArrayOption? super.option,
  });

  @override
  CmsArrayOption get option => super.option as CmsArrayOption;
}

class CmsArrayFieldConfig extends CmsFieldConfig {
  const CmsArrayFieldConfig({
    super.name,
    super.title,
    CmsArrayOption? super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [List];
}
