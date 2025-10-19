import 'package:flutter_cms/models/fields.dart';

class CmsStringOption extends CmsOption {
  const CmsStringOption();
}

class CmsStringField extends CmsField {
  final String? description;

  const CmsStringField({
    required super.name,
    required super.title,
    required CmsStringOption super.option,
    this.description,
  });

  @override
  CmsStringOption get option => super.option as CmsStringOption;
}

class CmsStringFieldConfig extends CmsFieldConfig {
  const CmsStringFieldConfig({
    super.name,
    super.title,
    CmsStringOption super.option = const CmsStringOption(),
  });

  @override
  List<Type> get supportedFieldTypes => [String];
}
