import 'package:flutter_cms/models/fields.dart';

class CmsGeopointOption extends CmsOption {
  const CmsGeopointOption();
}

class CmsGeopointField extends CmsField {
  const CmsGeopointField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsGeopointFieldConfig extends CmsFieldConfig {
  const CmsGeopointFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [Object]; // Represents a geographical point
}