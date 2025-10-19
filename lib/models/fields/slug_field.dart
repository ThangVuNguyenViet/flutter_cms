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
    required CmsSlugOption super.option,
  });

  @override
  CmsSlugOption get option => super.option as CmsSlugOption;
}

class CmsSlugFieldConfig extends CmsFieldConfig {
  const CmsSlugFieldConfig({
    super.name,
    super.title,
    CmsSlugOption super.option = const CmsSlugOption(source: '', maxLength: 0),
  });

  @override
  List<Type> get supportedFieldTypes => [String];
}
