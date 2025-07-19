import 'package:flutter_cms/models/fields.dart';

class CmsBlockOption extends CmsOption {
  const CmsBlockOption();
}

class CmsBlockField extends CmsField {
  const CmsBlockField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsBlockFieldConfig extends CmsFieldConfig {
  const CmsBlockFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [Object]; // Blocks can contain various types
}