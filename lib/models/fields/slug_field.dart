import 'package:flutter_cms/models/fields.dart';

class CmsSlugOption extends CmsOption {
  final String source;
  final int maxLength;

  const CmsSlugOption({
    required this.source,
    required this.maxLength,
    super.hidden,
  });
}

class CmsSlugField extends CmsField {
  const CmsSlugField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsSlugFieldConfig extends CmsFieldConfig {
  const CmsSlugFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [String];
}