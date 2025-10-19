import 'package:flutter_cms/models/fields.dart';

class CmsImageOption extends CmsOption {
  final bool hotspot;

  const CmsImageOption({required this.hotspot, super.hidden});
}

class CmsImageField extends CmsField {
  const CmsImageField({
    required super.name,
    required super.title,
    required CmsImageOption? super.option,
  });

  @override
  CmsImageOption? get option => super.option as CmsImageOption;
}

class CmsImageFieldConfig extends CmsFieldConfig {
  const CmsImageFieldConfig({
    super.name,
    super.title,
    CmsImageOption? super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [String]; // Assuming image is represented by a URL string
}
