import 'package:flutter_cms/models/fields.dart';

class CmsImageOption extends CmsOption {
  final bool hotspot;

  const CmsImageOption({required this.hotspot, super.hidden});
}

class CmsImageField extends CmsField {
  const CmsImageField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsImageFieldConfig extends CmsFieldConfig {
  const CmsImageFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [String]; // Assuming image is represented by a URL string
}