import 'package:flutter_cms/models/fields.dart';
import 'package:flutter_cms/validators/validators.dart';

class CmsTextOption extends CmsOption {
  final int rows;
  final CmsValidator? validation;
  final String? initialValue;
  final String? description;
  final bool readOnly;
  final String? deprecatedReason;

  const CmsTextOption({
    this.rows = 1,
    super.hidden,
    this.validation,
    this.initialValue,
    this.description,
    this.readOnly = false,
    this.deprecatedReason,
  });
}

class CmsTextField extends CmsField {
  const CmsTextField({
    required super.name,
    required super.title,
    CmsTextOption? super.option,
  });

  @override
  CmsTextOption get option => super.option as CmsTextOption;
}

class CmsTextFieldConfig extends CmsFieldConfig {
  const CmsTextFieldConfig({
    super.name,
    super.title,
    CmsTextOption? super.option,
  });

  @override
  List<Type> get supportedFieldTypes => [String];
}
