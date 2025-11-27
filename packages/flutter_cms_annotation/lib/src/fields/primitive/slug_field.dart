import '../base/field.dart';

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
    super.description,
    required CmsSlugOption super.option,
  });

  @override
  CmsSlugOption get option => super.option as CmsSlugOption;
}

class CmsSlugFieldConfig extends CmsFieldConfig {
  const CmsSlugFieldConfig({
    super.name,
    super.title,
    super.description,
    CmsSlugOption super.option = const CmsSlugOption(source: '', maxLength: 0),
  });

  @override
  List<Type> get supportedFieldTypes => [String];
}
