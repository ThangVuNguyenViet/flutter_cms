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
    required CmsReferenceOption super.option,
  });

  @override
  CmsReferenceOption get option => super.option as CmsReferenceOption;
}

class CmsReferenceFieldConfig extends CmsFieldConfig {
  const CmsReferenceFieldConfig({
    super.name,
    super.title,
    CmsReferenceOption super.option = const CmsReferenceOption(to: CmsReferenceTo(type: '')),
  });

  @override
  List<Type> get supportedFieldTypes => [Object]; // Assuming reference can be any object
}
