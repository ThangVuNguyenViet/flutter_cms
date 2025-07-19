import 'package:flutter_cms/models/fields.dart';

class CmsStringOption extends CmsOption {
  const CmsStringOption();
}

class CmsStringField extends CmsField {
  final String? description;

  const CmsStringField({
    required super.name,
    required super.title,
    required super.option,
    this.description,
  });
}

class CmsStringFieldConfig extends CmsFieldConfig {
  const CmsStringFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [String];
}