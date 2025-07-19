import 'package:flutter_cms/models/fields.dart';

class CmsFileOption extends CmsOption {
  const CmsFileOption();
}

class CmsFileField extends CmsField {
  const CmsFileField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsFileFieldConfig extends CmsFieldConfig {
  const CmsFileFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [String]; // Assuming file is represented by a URL string
}