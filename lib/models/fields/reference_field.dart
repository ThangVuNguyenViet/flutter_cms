import 'package:flutter_cms/models/fields.dart';

class CmsReferenceTo {
  final String type;

  const CmsReferenceTo({required this.type});
}

class CmsReferenceOption extends CmsOption {
  final CmsReferenceTo to;

  const CmsReferenceOption({required this.to, super.hidden});
}

class CmsReferenceField extends CmsField {
  const CmsReferenceField({
    required super.name,
    required super.title,
    required super.option,
  });
}

class CmsReferenceFieldConfig extends CmsFieldConfig {
  const CmsReferenceFieldConfig({
    super.name,
    super.title,
    super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [Object]; // Assuming reference can be any object
}